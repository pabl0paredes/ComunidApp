import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static values = {
    dateFormat: String,
    altFormat: String,
    defaultDate: String,
    commonSpaceId: Number
  }

  async connect() {
    const allowedDates = await this.fetchAvailableDates()

    flatpickr(this.element, {
      altInput: true,
      altFormat: this.altFormatValue || "d-m-Y",
      dateFormat: this.dateFormatValue || "Y-m-d",
      defaultDate: this.defaultDateValue,
      disableMobile: true,

      enable: allowedDates.map(date => date) // Flatpickr solo deja clicar estas fechas
    })
  }

  async fetchAvailableDates() {
    const url = `/common_spaces/${this.commonSpaceIdValue}/bookings/available_dates`

    const response = await fetch(url)
    if (!response.ok) return []

    const dates = await response.json()
    return dates // formato ["2025-12-01", "2025-12-08", ...]
  }
}

// // app/javascript/controllers/flatpickr_controller.js
// import { Controller } from "@hotwired/stimulus";
// import flatpickr from "flatpickr";

// // Connects to data-controller="flatpickr"
// export default class extends Controller {
// static values = { weekdays: Array }
//   connect() {
//     console.log("Desde Stimulus:", this.weekdaysValue);
//     flatpickr(this.element, {
//       enableTime: true,
//       dateFormat: "Y-m-d H:i",
//       minDate: "today",
//       disable: [
//         (date) => {
//           return !this.weekdaysValue.includes(date.getDay())
//         }
//       ]
//     });
//   }
// }
