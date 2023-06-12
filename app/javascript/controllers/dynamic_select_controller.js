import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "choice", "long"]

  connect() {
    this.selected()
  }

  selected() {
    this.hideFields()
    switch (this.selectTarget.value) {
      case 'single_select':
        this.choiceTarget.classList.remove('hidden')
        break;
      case 'multiple_select':
        this.choiceTarget.classList.remove('hidden')
        break;
      case 'textbox':
        this.longTarget.classList.remove('hidden')
        break;
    }
  }

  hideFields() {
    this.choiceTarget.classList.add('hidden')
    this.longTarget.classList.add('hidden')
  }
}
