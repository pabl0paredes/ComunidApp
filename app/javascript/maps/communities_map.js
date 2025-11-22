document.addEventListener("turbo:load", () => {
  const mapDiv = document.getElementById("map-communities");
  if (!mapDiv) return;

  const token = document.querySelector('meta[name="mapbox-token"]').content;
  mapboxgl.accessToken = token;

  const communities = JSON.parse(mapDiv.dataset.communities);
  const selector = document.getElementById("community-selector");

  const map = new mapboxgl.Map({
    container: "map-communities",
    style: "mapbox://styles/mapbox/streets-v12",
    center: [-70.6483, -33.4569],
    zoom: 11,
  });

  // Ajusta el mapa a todos los puntos
  const bounds = new mapboxgl.LngLatBounds();

  communities.forEach((community) => {
    if (community.latitude && community.longitude) {
      const lng = community.longitude;
      const lat = community.latitude;

      // 1) Crear tooltip (popup)
      const popup = new mapboxgl.Popup({
        closeButton: false,
        closeOnClick: false,
        offset: 20,
        className: "popup-hover" // opcional para estilos
      }).setText(community.name);

      // 2) Crear marker
      const marker = new mapboxgl.Marker({ color: "#0066ff" })
        .setLngLat([lng, lat])
        .addTo(map);

      // 3) Mostrar popup al pasar el mouse por encima
      marker.getElement().addEventListener("mouseenter", () => {
        popup.addTo(map).setLngLat([lng, lat]);
      });

      // 4) Ocultar popup al sacar el mouse
      marker.getElement().addEventListener("mouseleave", () => {
        popup.remove();
      });

      // 🔥 CLICK: elegir comunidad en el selector
      marker.getElement().addEventListener("click", () => {
        selector.value = community.id;   // selecciona opción
        selector.dispatchEvent(new Event("change")); // dispara evento de cambio si lo usas
      });

      bounds.extend([lng, lat]);
    }
  });

  if (!bounds.isEmpty()) {
    map.fitBounds(bounds.pad(0.3));
  }
});
