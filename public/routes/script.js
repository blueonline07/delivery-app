$(document).ready(function () {
  if (localStorage.getItem("phone") == null) {
    window.location.href = "/";
  }

  var table = $("#routes").DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: "http://localhost:8080/api/routes/data",
      type: "POST",
      data: function (d) {
        d.phone = localStorage.getItem("phone");
      },
    },
    columns: [
      { data: "stt" },
      { data: null, 
        seachable: false,
        orderable: false,
        render: function (data, type, row) {
          return data.tinhBD + ", " + data.huyenBD + ", " + data.xaBD + ", " + data.chiTietBD;
        },
      },
      { data: null, 
        seachable: false,
        orderable: false,
        render: function (data, type, row) {
          return data.tinhKT + ", " + data.huyenKT + ", " + data.xaKT + ", " + data.chiTietKT;
        },
      },
      { data: "tinhTrang" }
    ],
    pageLength: 5,
    lengthMenu: [5, 10, 25, 50],
    order: [[0, "asc"]],
  });
});