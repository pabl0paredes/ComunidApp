import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.element.style.cursor = "pointer"
  }

  go() {
    window.location.href = this.urlValue
  }
}
