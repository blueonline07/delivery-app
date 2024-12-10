$(document).ready(function () {
    if (localStorage.getItem("phone") == null) {
      // window.location.href = "/";
    }

    const orders = [
        { id: 'DH001', date: '2024-12-01', name: 'Nguyễn Văn A', phone: '', address: 'Hà Nội', status: 'Đang xử lý' },
        { id: 'DH002', date: '2024-12-02', name: 'Trần Thị B',phone: '', address: 'TP.HCM', status: 'Hoàn thành' },
        { id: 'DH003', date: '2024-12-03', name: 'Lê Văn C', phone: '',address: 'Đà Nẵng', status: 'Đang xử lý' }
      ];

      // Function to render order rows
      function renderOrders() {
        const orderList = $("#orderContent");
        orderList.empty(); // Clear previous rows
        orders.forEach(order => {
          const row = `
            <tr>
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
      
  

  });
  function handleTransaction() {
    
  }
  