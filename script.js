$(document).ready(function () {
  $('#example').DataTable({
    serverSide: true,
    processing: true,
    ajax: {
      url: 'http://localhost:3000/api/data',
      type: 'POST',
    },
    columns: [
      { data: 'name' }, // Name column
      { data: 'age' },  // Age column
      { data: 'country' }, // Country column
      { data: 'role' }, // Role column
      {
        data: null, // No actual data source for this column
        orderable: false, // Prevent sorting
        searchable: false, // Exclude from search
        render: function (data, type, row) {
          return `
            <button class="btn btn-primary btn-sm" onclick="viewDetails(${row.id})">View</button>
            <button class="btn btn-danger btn-sm" onclick="deleteUser(${row.id})">Delete</button>
          `;
        },
      },
    ],
    pageLength: 10,
    lengthMenu: [10, 25, 50, 100],
    order: [[0, 'asc']],
  });
});

function viewDetails(id) {
  alert(`Viewing details for user ID: ${id}`);
}

function deleteUser(id) {
  if (confirm(`Are you sure you want to delete user ID: ${id}?`)) {
    // Add your AJAX delete logic here
    console.log(`Deleting user ID: ${id}`);
  }
}
