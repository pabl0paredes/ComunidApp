import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dateInput", "hoursContainer", "startField"]
  static values = { commonSpaceId: Number }

  async updateHours() {
    const date = this.dateInputTarget.value
    if (!date) return

    const url = `/common_spaces/${this.commonSpaceIdValue}/bookings/available_hours?date=${encodeURIComponent(date)}`

    const response = await fetch(url, {
      headers: { "Accept": "application/json" }
    })

    if (!response.ok) {
      console.error("Error en respuesta:", await response.text())
      return
    }

    const usableHours = await response.json()

    // limpiar contenedor
    this.hoursContainerTarget.innerHTML = ""

    usableHours.forEach(slot => {
      const start = new Date(slot.start)
      const end = new Date(slot.end)

      const label = `${start.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })} - ${end.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}`

      const btn = document.createElement("button")
      btn.type = "button"
      btn.className = "btn btn-outline-primary rounded-3 px-4 py-2 fw-semibold shadow-sm hour-button"
      btn.textContent = label
      btn.dataset.start = slot.start

      btn.addEventListener("click", () => this.selectHour(btn))

      this.hoursContainerTarget.appendChild(btn)
    })
  }

  selectHour(button) {
    // limpiar selección previa
    this.hoursContainerTarget.querySelectorAll(".hour-button").forEach(b =>
      b.classList.remove("active-hour")
    )

    // marcar este botón
    button.classList.add("active-hour")

    // almacenar el valor
    this.startFieldTarget.value = button.dataset.start
  }
}
