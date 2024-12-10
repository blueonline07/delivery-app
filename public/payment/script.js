$(document).ready(function () {
    if (localStorage.getItem("phone") == null) {
      window.location.href = "/";
    }
  
    var table = $("#example").DataTable({
      serverSide: true,
      processing: true,
      ajax: {
        url: "http://localhost:8080/api/payments/data",
        type: "POST",
        data: function (d) {
          d.phone = localStorage.getItem("phone");
        },
      },
      columns: [
        {
          data: null,
          orderable: false,
          searchable: false,
          className: "checkbox-column",
          render: function () {
            return '<input type="checkbox" class="orderCheckbox">';
          },
        },
        { data: "maDonHang" },
        { data: "hoTenNguoiNhan" },
        { data: "tinh" },
        { data: "huyen" },
        { data: "xa" },
        { data: "chiTiet" },
        { data: "gia" },
      ],
      pageLength: 5,
      lengthMenu: [5, 10, 25, 50],
      order: [[1, "asc"]], // Sắp xếp dựa trên mã đơn hàng (cột thứ hai)
    });

    let selectedData = [];

    $("#example tbody").on("change", ".orderCheckbox", function () {
      const row = $(this).closest("tr"); 
      const rowData = table.row(row).data().maDonHang; 
  
      if ($(this).prop("checked")) {
        // Nếu checkbox được check, thêm dữ liệu vào mảng
        selectedData.push(rowData);
      } else {
        // Nếu checkbox bị bỏ check, xóa dữ liệu khỏi mảng
        selectedData = selectedData.filter(item => item.maDonHang !== rowData.maDonHang);
      }
  
      console.log(selectedData); // Hiển thị danh sách giá trị trong console
    });
  
    $("#selectAll").on("change", function () {
      const isChecked = $(this).prop("checked");
      $(".orderCheckbox").prop("checked", isChecked);
  
      if (isChecked) {
        for (let i = 0; i < table.rows().data().length; i++) {
          const rowData = table.row(i).data().maDonHang;
          selectedData.push(rowData);
        }
      } else {
        selectedData = [];
      }
      console.log(selectedData); 
    });
  
    // Create hover info div
    var hoverInfo = $('<div class="hover-info"></div>').appendTo('body');

    $('#example tbody').on('mouseenter', 'tr', function () {
      var row = this;
      hoverTimeout = setTimeout(function () {
        var data = table.row(row).data();
        hoverInfo.text(`Receiver phone number: ${data.sdtNguoiNhan}, created_at: ${data.ngayTao}, status: ${data.tinhTrang}`);
        var position = $(row).offset();
        hoverInfo.css({
          top: position.top + $(row).height() + 5, // Position below the row
          left: position.left
        }).fadeIn();
      }, 500); // Delay of 500ms (you can adjust this value)
    });

    // Hide hover info when mouse leaves row and clear the timeout
    $('#example tbody').on('mouseleave', 'tr', function () {
      clearTimeout(hoverTimeout); // Clear the timeout if mouse leaves before the delay
      hoverInfo.fadeOut();
    });
    $("#paymentBtn").on("click", handlePayment);

    function handlePayment() {
      if (selectedData.length === 0) {
        alert("Vui lòng chọn ít nhất một đơn hàng để thanh toán.");
        return;
      }
    
      // Gửi dữ liệu đến API
      $.ajax({
        url: "http://localhost:8080/api/payments/make",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(selectedData), // Chuyển mảng dữ liệu thành JSON
        success: function (response) {
          alert("Tạo đơn thành công!");
          const billId = response.hoadonID;
          // Chuyển hướng sau khi thanh toán thành công
          const paymentUrl = `/payment/bill/?billId=${billId}`; 
          window.location.href = paymentUrl;
        },
        error: function (error) {
          alert("Đã xảy ra lỗi khi thanh toán. Vui lòng thử lại.");
          console.error("Error:", error);
        },
      });
    }
    
  });
  