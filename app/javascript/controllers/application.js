import { Application } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";
// import * as bootstrap from "bootstrap";
import "./community";

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }
