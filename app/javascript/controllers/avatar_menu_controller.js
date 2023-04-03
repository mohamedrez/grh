import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar-menu"
export default class extends Controller {

  greet() {
    console.log("Hello, Stimulus!", this.element)
  }
  toggle() {
    getElementbyId("avatar-menu").classList.toggle("hidden");
  }
}
