$(document).ready(function () {
  const locations = {
    "Hà Nội": {
      "Ba Đình": ["Phúc Xá", "Cống Vị", "Liễu Giai"],
      "Hoàn Kiếm": ["Hàng Bài", "Cửa Đông", "Hàng Trống"],
      "Tây Hồ": ["Quảng An", "Tứ Liên", "Phú Thượng"],
      "Long Biên": ["Gia Thụy", "Sài Đồng", "Ngọc Thụy"],
      "Cầu Giấy": ["Dịch Vọng", "Quan Hoa", "Yên Hòa"],
      "Đống Đa": ["Khâm Thiên", "Hàng Bột", "Trung Liệt"],
      "Hai Bà Trưng": ["Bạch Mai", "Lê Đại Hành", "Trương Định"]
    },
    "Hồ Chí Minh": {
      "Quận 1": ["Bến Nghé", "Nguyễn Cư Trinh", "Đa Kao"],
      "Quận 2": ["Thạnh Mỹ Lợi", "An Phú", "Cát Lái"],
      "Quận 3": ["Phường 1", "Phường 3", "Phường 5"],
      "Bình Thạnh": ["Bình Quới", "Nghĩa Đô", "Phú Nhuận"],
      "Gò Vấp": ["Hiệp Thành", "Linh Tây", "Linh Đông"],
      "Phú Nhuận": ["Phú Thuận", "Hòa Thạnh", "Nhơn Phú"],
      "Tân Bình": ["Phú Thọ", "Tân Quý", "Tân Thành"]
    },
    "Đà Nẵng": {
      "Hải Châu": ["Phước Ninh", "Thạch Thang", "Cẩm Lệ"],
      "Cẩm Lệ": ["Hòa Xuân", "Khuê Trung", "Hòa An"],
      "Thanh Khê": ["An Khê", "Thanh Khê Đông", "Tân Chính"],
      "Ngũ Hành Sơn": ["Khuê Mỹ", "Phước Mỹ", "Mỹ An"],
      "Sơn Trà": ["Thọ Quang", "Mỹ Khê", "Phước Mỹ"],
      "Liên Chiểu": ["Hòa Khánh Bắc", "Hòa Khánh Nam", "Lý Tín"],
    },
    "Hải Phòng": {
      "Hồng Bàng": ["Niệm Nghĩa", "Quán Nam", "Chợ Rồng"],
      "Lê Chân": ["Dư Hàng Kênh", "Nghĩa Xá", "Cầu Đất"],
      "Ngô Quyền": ["Vạn Mỹ", "Lạch Tray", "Đằng Lâm"],
      "Hải An": ["Cát Bi", "Hùng Vương", "Cát Dài"],
      "Kiến An": ["Nam Sơn", "Cao Xá", "Tú Sơn"],
      "Dương Kinh": ["Lý Hòa", "An Tiến", "Vĩnh Khê"]
    }
  };

  // Populate provinces
  for (const province in locations) {
    $("#tinh").append(new Option(province, province));
  }

  // Update districts and communes when province or district changes
  $("#tinh").on("change", function () {
    const selectedProvince = $(this).val();
    const districts = locations[selectedProvince] || {};
    const $district = $("#huyen");
    const $commune = $("#xa");

    $district.empty().append(new Option("Chọn huyện", ""));
    $commune.empty().append(new Option("Chọn xã", ""));
    
    for (const district in districts) {
      $district.append(new Option(district, district));
    }
  });

  // Update communes when district changes
  $("#huyen").on("change", function () {
    const selectedProvince = $("#tinh").val();
    const selectedDistrict = $(this).val();
    const communes = locations[selectedProvince][selectedDistrict] || [];
    const $commune = $("#xa");

    $commune.empty().append(new Option("Chọn xã", ""));
    communes.forEach(function (commune) {
      $commune.append(new Option(commune, commune));
    });
  });

  // Handle order form submission
  
});


$("#orderForm").on("submit", function (e) {
  const phoneRegex = /^(0)+([0-9]{9})$/;
  e.preventDefault();
  const sdt = $("#sdt").val();
  if (!phoneRegex.test(sdt)) {
    alert("Số điện thoại không hợp lệ! Vui lòng nhập lại.");
    return;
  }

  const orderData = {
    hoTenNguoiNhan: $("#hotennguoinhan").val(),
    sdtNguoiNhan: $("#sdt").val(),
    tinh: $("#tinh").val(),
    huyen: $("#huyen").val(),
    xa: $("#xa").val(),
    chiTiet: $("#chiTiet").val(),
    packages: [],
    phone : localStorage.getItem("phone")
  };

  const rows = document.querySelectorAll('#packages tr');
  rows.forEach((row) => {
    const description = row.querySelector('input[name="description"]').value;
    const weight = row.querySelector('input[name="weight"]').value;
    const labels = row.querySelector('input[name="labels"]').value;

    // Push the package details to the array
    orderData.packages.push({
      description,
      weight,
      labels, // If this value is dynamic, fetch it similarly
    });
  });

  console.log(orderData);
  $.ajax({
    url: "http://localhost:8080/api/orders/",  
    type: "POST",
    contentType: "application/json",
    data: JSON.stringify(orderData),
    success: function (response) {
      alert("Order added successfully!");
      dataTable.ajax.reload();  
      $("#orderForm")[0].reset();  
    },
    error: function () {
      alert("Error adding order!");
    },
  });
});




