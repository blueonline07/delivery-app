const api = "http://localhost:8080/api";


// Validation and Backend Submission
document.getElementById("login-form").addEventListener("submit", function (e) {
  e.preventDefault(); // Prevent form submission

  const phoneInput = document.getElementById("phone");
  const passwordInput = document.getElementById("password");

  // Regular expression for 10-digit phone number
  const phoneRegex = /^\d{10}$/;
  let isValid = true;

  // Validate phone number
  if (!phoneRegex.test(phoneInput.value)) {
    phoneInput.classList.add("is-invalid");
    isValid = false;
  } else {
    phoneInput.classList.remove("is-invalid");
  }

  // Validate password length
  if (passwordInput.value.length < 6) {
    passwordInput.classList.add("is-invalid");
    isValid = false;
  } else {
    passwordInput.classList.remove("is-invalid");
  }

  // If valid, send data to backend
  if (isValid) {
    const loginData = {
      phone: phoneInput.value,
      password: passwordInput.value,
    };

    // Send POST request to backend
    fetch(api + "/login/", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(loginData),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Login failed");
        }
        return response.json();
      })
      .then((data) => {
        alert("Login successful!");
        localStorage.setItem("phone", phoneInput.value);
        localStorage.setItem("name", data.name);
        window.location.href = "/orders";

        // Redirect to another page or perform further actions here
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("Login failed. Please check your credentials and try again.");
      });
  }
});
