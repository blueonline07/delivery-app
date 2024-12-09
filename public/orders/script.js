$(document).ready(function () {
  if (localStorage.getItem("phone") == null) {
    window.location.href = "/";
  }

  var table = $("#example").DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: "http://localhost:8080/api/orders/data",
      type: "POST",
      data: function (d) {
        d.phone = localStorage.getItem("phone");
      }
    },
    columns: [
      { data: "maDonHang" },
      { data: "hoTenNguoiNhan" },
      { data: "tinh" },
      { data: "huyen" },
      { data: "xa" },
      { data: "chiTiet" },
      { data: "gia" }
    ],
    pageLength: 5,
    lengthMenu: [5, 10, 25, 50],
    order: [[0, "asc"]],
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

});

