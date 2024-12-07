$(document).ready(function () {
    $("#routeForm").on("submit", function (e) {
      e.preventDefault();

      const orderID = {
        maDonHang: $("#maDonHang").val(),
      };

      $.ajax({
        url: "http://localhost:8000/api/routes/create",  
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(orderID),
        success: function (response) {
          alert("Order added successfully!");
          dataTable.ajax.reload();  
          $("#routeForm")[0].reset();  
        },
        error: function () {
          alert("Error adding order!");
        },
      });
    });
  });