// Label list to populate checkboxes
const labelsList = ["NH1", "NH2"];
const savedLabels = [];

// Dynamically generate checkboxes
function updatePopupLabels(labels, selectedLabels) {
  const container = document.getElementById("checkbox-container");
  container.innerHTML = ""; // Clear existing checkboxes

  labels.forEach((label) => {
    const isChecked = selectedLabels.includes(label) ? "checked" : "";
    const labelElement = document.createElement("div");
    labelElement.classList.add("form-check");
    labelElement.innerHTML = `
      <input class="form-check-input" type="checkbox" value="${label}" id="checkbox-${label}" ${isChecked}>
      <label class="form-check-label" for="checkbox-${label}">${label}</label>
    `;
    container.appendChild(labelElement);
  });
}

// Toggle the visibility of the popup for label selection
function toggleLabelPopup(id) {
  const popup = document.getElementById("labelPopup");
  popup.innerHTML = `
    <div class="popup-content">
      <h3 class="mb-3">Chọn nhãn</h3>
      <div id="checkbox-container" class="mb-3"></div>
      <button class="btn btn-success" onclick="saveSelectedLabels(${id})">Lưu nhãn</button>
      <button class="btn btn-secondary" onclick="closePopup()">Đóng</button>
    </div>
  `;

  // Initialize popup with labels, showing previously selected ones
  updatePopupLabels(labelsList, packages[id].labels || []);
  popup.style.display = "flex";
}

function closePopup() {
  document.getElementById("labelPopup").style.display = "none";
}

// Save and display the selected labels
function saveSelectedLabels(id) {
  const checkboxes = document.querySelectorAll(
    "#labelPopup .form-check-input:checked"
  );
  const selectedLabels = Array.from(checkboxes).map(
    (checkbox) => checkbox.value
  );

  // Update labels in the corresponding package
  packages[id].labels = selectedLabels;

  // Update the row's "Labels" input field
  const labelsField = document.querySelectorAll("#packages tr")[id].querySelector('input[name="labels"]');
  labelsField.value = selectedLabels.join(",");
  closePopup(); // Close the popup after saving
}
