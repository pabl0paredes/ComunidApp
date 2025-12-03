// app/javascript/controllers/flatpickr_controller.js
import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
static values = { weekdays: Array }
  connect() {
    console.log("Desde Stimulus:", this.weekdaysValue);
    flatpickr(this.element, {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      minDate: "today",
      disable: [
        (date) => {
          return !this.weekdaysValue.includes(date.getDay())
        }
      ]
    });
  }
}