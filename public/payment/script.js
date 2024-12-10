$(document).ready(function () {
    if (localStorage.getItem("phone") == null) {
      // window.location.href = "/";
    }
  
    var table = $("#example").DataTable({
      serverSide: true,
      processing: true,
      ajax: {
        url: "http://localhost:8080/api/orders/data",
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
        { data: "tinhTrang" },
      ],
      pageLength: 5,
      lengthMenu: [5, 10, 25, 50],
      order: [[1, "asc"]], // Sắp xếp dựa trên mã đơn hàng (cột thứ hai)
    });
    const orders = [
        { id: 'DH001', date: '2024-12-01', name: 'Nguyễn Văn A', phone: '', address: 'Hà Nội', status: 'Đang xử lý' },
        { id: 'DH002', date: '2024-12-02', name: 'Trần Thị B',phone: '', address: 'TP.HCM', status: 'Hoàn thành' },
        { id: 'DH003', date: '2024-12-03', name: 'Lê Văn C', phone: '',address: 'Đà Nẵng', status: 'Đang xử lý' }
      ];

      // Function to render order rows
      function renderOrders() {
        const orderList = $("#orderList");
        orderList.empty(); // Clear previous rows
        orders.forEach(order => {
          const row = `
            <tr>
               <td class="checkbox-column">
                <input type="checkbox" class="orderCheckbox">
              </td>
              <td>${order.id}</td>
              <td>${order.date}</td>
              <td>${order.name}</td>
              <td>${order.phone}</td>
              <td>${order.address}</td>
              <td>${order.status}</td>
            </tr>
          `;
          orderList.append(row);
        });
      }

      // Render initial orders
      renderOrders();
    // Handle "Select All" checkbox
    $("#selectAll").on("change", function () {
      $(".orderCheckbox").prop("checked", $(this).prop("checked"));
    });
  
    // Create hover info div
    var hoverInfo = $('<div class="hover-info"></div>').appendTo("body");
  
    $("#example tbody").on("mouseenter", "tr", function () {
      var row = this;
      hoverTimeout = setTimeout(function () {
        var data = table.row(row).data();
        hoverInfo.text(
          `Receiver phone number: ${data.sdtNguoiNhan}, created_at: ${data.ngayTao}`
        );
        var position = $(row).offset();
        hoverInfo.css({
          top: position.top + $(row).height() + 5, // Position below the row
          left: position.left,
        }).fadeIn();
      }, 500);
    });
  
    // Hide hover info when mouse leaves row and clear the timeout
    $("#example tbody").on("mouseleave", "tr", function () {
      clearTimeout(hoverTimeout); 
      hoverInfo.fadeOut();
    });
  });
  