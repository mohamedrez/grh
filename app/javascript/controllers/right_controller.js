import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition";

export default class extends Controller {
  static targets = ["rightContainer", "rightBackdrop", "rightPanel", "rightInnerContainer"];
  connect () {
    this.element[this.identifier] = this
  }
  show() {
    this.rightBackdropTarget.classList.remove("hidden");
    this.rightInnerContainerTarget.classList.remove("hidden");
    enter(this.rightContainerTarget)
  }

  submitEnd(e) {
    if (e.detail.success) {
      this.hide()
    }
  }

  hide() {
    Promise.all([
      leave(this.rightContainerTarget),
    ]).then(() => {
      this.rightBackdropTarget.classList.add("hidden");
      this.rightInnerContainerTarget.classList.add("hidden");
    });
  }
}
