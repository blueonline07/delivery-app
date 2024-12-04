$(document).ready(function () {
  let username = "test";
  $("#example").DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: "http://localhost:8000/api/orders/data",
      type: "POST",
    },
    columns: [
      { data: "maDonHang" },
      { data: "ngayTao" },
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
                <button class="btn btn-danger btn-sm delete-btn" data-id="${row.maDonHang}">Delete</button>
            `;
        },
      },
    ],
    pageLength: 10,
    lengthMenu: [10, 25, 50, 100],
    order: [[0, "asc"]],
  });

  // Example event handlers for action buttons
  $("#example tbody").on("click", ".edit-btn", function () {
    const id = $(this).data("id");
    alert("Edit button clicked for ID: " + id);
    // Implement your edit logic here
    window.location.href = "/orders/create";
  });

  $("#example tbody").on("click", ".delete-btn", function () {
    const id = $(this).data("id");
    alert("Delete button clicked for ID: " + id);
    // Implement your delete logic here
  });
  
});