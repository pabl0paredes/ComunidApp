import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static values = {
    dateFormat: String,
    altFormat: String,
    defaultDate: String,
    commonSpaceId: Number,
    inline: Boolean
  }

  async connect() {
    const allowedDates = await this.fetchAvailableDates()

    flatpickr(this.element, {
      inline: this.inlineValue || false, // 👈 AHORA SOPORTA DIV INLINE
      altInput: !this.inlineValue,       // 👈 sin input extra cuando inline
      altFormat: this.altFormatValue || "d-m-Y",
      dateFormat: this.dateFormatValue || "Y-m-d",
      defaultDate: this.defaultDateValue,
      disableMobile: true,
      enable: allowedDates
    })
  }

  async fetchAvailableDates() {
    const url = `/common_spaces/${this.commonSpaceIdValue}/bookings/available_dates`

    const response = await fetch(url)
    if (!response.ok) return []

    return await response.json()
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
