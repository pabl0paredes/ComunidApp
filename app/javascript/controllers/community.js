// app/javascript/controllers/community_modal.js
document.addEventListener("turbo:load", () => {
  const modalButton = document.getElementById("admin-info-button");
  const modalElement = document.getElementById("admin-info-modal");

  // Si el botón y el modal existen en la página
  if (modalButton && modalElement) {
    const modal = new bootstrap.Modal(modalElement); // Inicializamos el modal

    // Mostrar el modal al hacer clic en el botón
    modalButton.addEventListener("click", (event) => {
      event.preventDefault(); // Prevenir el comportamiento por defecto
      modal.show(); // Mostrar el modal
    });
  }
});
