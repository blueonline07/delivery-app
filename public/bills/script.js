$(document).ready(function() {
    $("#bill").DataTable({
        serverSide: true,
        processing: true,
        ajax: {
            url: "http://localhost:8000/api/bills/data",
            type: "POST",
        },
        columns: [
            {data: "maHoaDon"},
            {data: "tongTien"},
            {data: "tinhTrang"},
        ],
        pageLength: 10,
        lengthMenu: [10, 25, 50, 100],
        order: [[0, "asc"]]  
    })
});