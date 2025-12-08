import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["manualList"]

  connect() {
    console.log("Stimulus conectado!")
    // Al cargar la página, decidimos si mostramos u ocultamos la lista
    this.toggle()
  }

  toggle(event) {
    // Si viene de un click/change de un radio, usamos ese valor
    const fromEvent = event?.target?.value

    // Si no hay event (por ejemplo, en connect), miramos el que esté marcado
    const fromDom = this.element
      .querySelector("input[type='radio']:checked")
      ?.value

    const mode = fromEvent || fromDom

    if (mode === "manual") {
      this.manualListTarget.classList.remove("d-none")
    } else {
      this.manualListTarget.classList.add("d-none")
    }
  }
}
