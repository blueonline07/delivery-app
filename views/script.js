$(document).ready(function () {
  console.log("HI")
  $('#example').DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: 'http://localhost:8000/api/data',
      type: 'POST',
    },
    columns: [
      { data: 'maDonHang' }, 
      { data: 'ngayTao' }, 
      { data: 'hoTenNguoiNhan' },  
      { data: 'tinh' },
      { data: 'huyen' },
      { data: 'xa' },
      { data: 'chiTiet' }
      // {
      //   data: null, // No actual data source for this column
      //   orderable: false, // Prevent sorting
      //   searchable: false, // Exclude from search
      // },
    ],
    pageLength: 10,
    lengthMenu: [10, 25, 50, 100],
    order: [[0, 'asc']],
  });
});
