import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["container", "backdrop", "panel"];
  show() {
    this.containerTarget.classList.remove("hidden");
    enter(this.backdropTarget);
    enter(this.panelTarget);
  }

  hide() {
    Promise.all([
      leave(this.backdropTarget),
      leave(this.panelTarget),
    ]).then(() => {
      this.containerTarget.classList.add("hidden");
    });
  }
}
