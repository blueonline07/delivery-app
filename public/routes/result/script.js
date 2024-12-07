$(document).ready(function() {
    $("#route").DataTable({
        serverSide: true,
        processing: true,
        ajax: {
            url: "http://localhost:8000/api/routes/data",
            type: "POST",
        },
        columns: [
            {data: "STT"},
            {data: "BatDau"},
            {data: "KetThuc"},
            {data: "TramDamNhan"},
            {data: "TaiXeDamNhan"},
            {data: "TinhTrang"},
        ],
        pageLength: 10,
        lengthMenu: [10, 25, 50, 100],
        order: [[0, "asc"]]  
    })
});