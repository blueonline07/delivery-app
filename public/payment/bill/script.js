
$(document).ready(function() {
  // Assuming you have the following data from the server
  loadInvoiceData();
  async function loadInvoiceData() {
    const urlParams = new URLSearchParams(window.location.search);
    const invoiceId = urlParams.get("billId"); // Lấy `billId` từ URL
    $('#invoiceId').text(invoiceId);
    
    let orders = [];
    try {
      // Gọi API để lấy dữ liệu hóa đơn
      const response = await $.ajax({
        url: `http://localhost:8080/api/payments/bill/${invoiceId}`, // Đường dẫn API lấy thông tin hóa đơn
        type: "GET",
        contentType: "application/json",
      });
  
      orders = response;
  
      // Nhóm dữ liệu hóa đơn
      const groupedData = orders.reduce((result, item) => {
        if (!result[item.maHoaDon]) {
          result[item.maHoaDon] = {
            maHoaDon: item.maHoaDon,
            tongTien: item.tongTien,
            tinhTrang: item.tinhTrang,
            ngayTao: item.ngayTao,
            orders: [],
          };
        }
  
        result[item.maHoaDon].orders.push({
          maDonHang: item.maDonHang,
          hoTenNguoiNhan: item.hoTenNguoiNhan,
          sdtNguoiNhan: item.sdtNguoiNhan,
          gia: item.gia,
          tinh: item.tinh,
          huyen: item.huyen,
          xa: item.xa,
          chiTiet: item.chiTiet,
        });
  
        return result;
      }, {});
  
      // Lấy dữ liệu cho hóa đơn hiện tại
      const invoiceData = groupedData[invoiceId];
      if (!invoiceData) {
        alert("Không tìm thấy thông tin hóa đơn!");
        return;
      }
  
      // Cập nhật thông tin trên giao diện
      $('#creationDate').text(invoiceData.ngayTao);
      $('#status').text(invoiceData.tinhTrang);
      $('#totalAmount').text(invoiceData.tongTien);
  
      // Hiển thị danh sách đơn hàng trong bảng
      const orderContent = invoiceData.orders.map(order => {
        return `
          <tr>
            <td>${order.maDonHang}</td>
            <td>${order.hoTenNguoiNhan}</td>
            <td>${order.tinh}</td>
            <td>${order.huyen}</td>
            <td>${order.xa}</td>
            <td>${order.chiTiet}</td>
            <td>${order.gia}</td>
          </tr>
        `;
      }).join('');
  
      $('#orderContent').html(orderContent);
  
      // Khởi tạo DataTable
      $('#ordersTable').DataTable();
  
    } catch (error) {
      console.error(error);
    }
  }

  $("#paymentBtn").on("click", handlePayment);
  function handlePayment() {
    const urlParams = new URLSearchParams(window.location.search);
    const invoiceId = urlParams.get("billId");
    const paymentUrl = `/payment/transaction/?transaction=${invoiceId}`; 
    window.location.href = paymentUrl;
  }
});
