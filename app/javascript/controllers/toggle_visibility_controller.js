import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-visibility"
export default class extends Controller {
  connect() {
    document.addEventListener("DOMContentLoaded", function() {
      const filterButton = document.getElementById("filter-button");
      const filterForm = document.getElementById("filter-form");
    
      filterButton.addEventListener("click", function() {
        filterForm.classList.toggle("hidden");
      });
    });    
  }
}
