$(document).ready(function () {
  let username = "test";
  $("#example").DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: "http://localhost:8000/api/orders/data",
      type: "POST"
    },
    columns: [
      { data: "maDonHang" },
      { data: "ngayTao" },
      { data: "sdtNguoiNhan" },
      { data: "hoTenNguoiNhan" },
      { data: "tinh" },
      { data: "huyen" },
      { data: "xa" },
      { data: "chiTiet" },
      { data: "tinhTrang" },
      {
        data: null,
        searchable: false,
        orderable: false,
        render: function (data, type, row) {
          console.log(row);
          return `
                <button class="btn btn-primary btn-sm edit-btn" data-id="${row.maDonHang}">Edit</button>
            `;
        },
      },
    ],
    pageLength: 5,
    lengthMenu: [5, 10, 25, 50],
    order: [[0, "asc"]],
  });

  // Example event handlers for action buttons
  $("#example tbody").on("click", ".edit-btn", function () {
    const id = $(this).data("id");
    alert("Edit button clicked for ID: " + id);
    // Implement your edit logic here
    // window.location.href = "/orders/create";
  });
  
});