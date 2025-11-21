import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "./map"
import "./maps/show_map"
// Flatpickr JS
import flatpickr from "flatpickr"

document.addEventListener("turbo:load", () => {
  flatpickr(".datetime-picker", {
    enableTime: true,
    dateFormat: "Y-m-d H:i",
    altInput: true,
    altFormat: "F j, Y H:i",
    time_24hr: true,
    minuteIncrement: 30,
    minDate: "today"
  });
});
