import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["manualList"]

  connect() {
    this.toggle()
  }

  toggle() {
    const mode = document.querySelector("input[name='assign_mode']:checked")?.value

    if (mode === "manual") {
      this.manualListTarget.classList.remove("d-none")
    } else {
      this.manualListTarget.classList.add("d-none")
    }
  }
}
