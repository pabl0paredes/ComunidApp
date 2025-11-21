import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { Spanish } from "flatpickr/dist/l10n/es.js"

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: true,
      time_24hr: true,
      dateFormat: "Y-m-d H:i",
      locale: Spanish
    })
  }
}