import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="applicant"
export default class extends Controller {
  connect() {
    const fileInput = document.querySelector('#job_application_resume');
    const fileNameDisplay = document.querySelector('#file-name');
    const fileTypeText = document.querySelector('#file-type-text');

    fileInput.addEventListener('change', function() {
      const files = fileInput.files;
      if (files.length > 0) {
        fileNameDisplay.textContent = files[0].name;
        fileTypeText.style.display = 'table-column';
      } else {
        fileNameDisplay.textContent = '';
        fileTypeText.style.display = 'block'; 
      }
    });
  }
}
