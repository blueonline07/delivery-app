document.addEventListener('DOMContentLoaded', function() {
  const userName = localStorage.getItem('name');
  
  if (userName) {
    // Display the username and the logout button, hide login link
    document.getElementById('user-name').textContent = `Hello, ${userName}`;
    document.getElementById('user-name-container').style.display = 'block'; // Show the username
    document.getElementById('logout-link').style.display = 'block'; // Show the logout button
    document.getElementById('login-link').style.display = 'none'; // Hide the login link
  } else {
    // Show login link and hide user-related content if not logged in
    document.getElementById('user-name-container').style.display = 'none';
    document.getElementById('logout-link').style.display = 'none';
    document.getElementById('login-link').style.display = 'block';
  }

  // Logout button logic
  document.getElementById('logout-btn')?.addEventListener('click', function() {
    // Clear the localStorage
    localStorage.removeItem('name');
    localStorage.removeItem('phone');

    // Hide the user info and show login link again
    document.getElementById('user-name-container').style.display = 'none';
    document.getElementById('logout-link').style.display = 'none';
    document.getElementById('login-link').style.display = 'block';

    // Optionally, redirect to the login page or home page
    window.location.href = '/'; // Redirect to login page
  });
});
