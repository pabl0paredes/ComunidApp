import { Application } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";
// import * as bootstrap from "bootstrap";
import "./community";

const application = Application.start()
application.debug = false
window.Stimulus = application

document.addEventListener("turbo:load", () => {
  const navbar = document.getElementById("mainNavbar");
  if (!navbar) return;

  const page = document.body.dataset.page;

  const isHome = page === "pages-home";

  function updateNavbar() {
    if (!isHome) {
      // Todas las páginas que NO son homepage => navbar fija blanca
      navbar.classList.add("nav-on-white");
      navbar.classList.remove("nav-over-hero");
      return;
    }

    // Solo homepage usa el scroll dinámico
    if (window.scrollY > 120) {
      navbar.classList.remove("nav-over-hero");
      navbar.classList.add("nav-on-white");
    } else {
      navbar.classList.add("nav-over-hero");
      navbar.classList.remove("nav-on-white");
    }
  }

  updateNavbar();
  document.addEventListener("scroll", updateNavbar);
});

document.addEventListener("turbo:load", () => {
  const page = document.body.dataset.page;

  const isHome = page === "pages-home";

  if (isHome) {
    document.body.classList.add("homepage");
    document.body.classList.remove("with-navbar-padding");
  } else {
    document.body.classList.add("with-navbar-padding");
    document.body.classList.remove("homepage");
  }
});


export { application }
