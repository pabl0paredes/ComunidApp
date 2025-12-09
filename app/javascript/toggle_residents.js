// app/javascript/toggle_residents.js

function setupToggleResidentsButtons() {
  const buttons = document.querySelectorAll(".toggle-residents-btn");

  buttons.forEach((btn) => {
    // Evitamos agregar el listener más de una vez
    if (btn.dataset.toggleResidentsInitialized === "true") return;

    btn.dataset.toggleResidentsInitialized = "true";

    btn.addEventListener("click", () => {
      const targetId = btn.dataset.target;
      const target = document.getElementById(targetId);
      if (!target) return;

      const isHidden =
        target.style.display === "none" || target.style.display === "";

      target.style.display = isHidden ? "block" : "none";
      btn.textContent = isHidden
        ? "Ocultar vecinos asignados"
        : "Mostrar vecinos asignados";
    });
  });
}

// Soporte para Turbo (Rails 7)
document.addEventListener("turbo:load", setupToggleResidentsButtons);

// Fallback por si no estás usando Turbo en alguna vista puntual
document.addEventListener("DOMContentLoaded", setupToggleResidentsButtons);
