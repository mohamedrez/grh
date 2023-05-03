import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition";

// Connects to data-controller="sidebar-menu"
export default class extends Controller {
  static targets = [ "overlay", "sidebar", "sidebarContainer" ]
  connect() {
    console.log('this')
  }
  hide() {
    // this.overlayTarget.classList.add("hidden");
    // this.sidebarTarget.classList.add("hidden");
    Promise.all([
      leave(this.overlayTarget),
      leave(this.sidebarTarget)

      // leave(this.closeButtonTarget),
      // leave(this.panelTarget),
    ]).then(() => {
      this.overlayTarget.classList.add("hidden");
      this.sidebarContainerTarget.classList.add("hidden");
      this.sidebarTarget.classList.add("hidden");
    });
  }
  show() {
    this.overlayTarget.classList.remove("sm:hidden");
    this.overlayTarget.classList.remove("hidden");
    this.sidebarTarget.classList.remove("sm:hidden");
    this.sidebarTarget.classList.remove("hidden");
    this.sidebarContainerTarget.classList.remove("hidden");
    this.sidebarContainerTarget.classList.remove("sm:hidden");
    enter(this.sidebarTarget);
    enter(this.overlayTarget);
    // enter(this.panelTarget);
  }
}
