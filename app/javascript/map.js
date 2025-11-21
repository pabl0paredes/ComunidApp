document.addEventListener("turbo:load", () => {
  const mapDiv = document.getElementById("map");
  if (!mapDiv) return;

  const mapboxToken = document.querySelector('meta[name="mapbox-token"]').content;
  mapboxgl.accessToken = mapboxToken;

  const existingLat = mapDiv.dataset.lat;
  const existingLng = mapDiv.dataset.lng;

  // Si el formulario tiene lat/lng, centramos ahí. Si no, centramos en Santiago.
  const startLat = existingLat ? parseFloat(existingLat) : -33.4569;
  const startLng = existingLng ? parseFloat(existingLng) : -70.6483;

  const map = new mapboxgl.Map({
    container: "map",
    style: "mapbox://styles/mapbox/streets-v12",
    center: [startLng, startLat],
    zoom: existingLat ? 15 : 12,
  });

  let marker = null;

  // Si había coordenadas en BD → crea el pin inicial
  if (existingLat && existingLng) {
    marker = new mapboxgl.Marker({ color: "#d00" })
      .setLngLat([startLng, startLat])
      .addTo(map);
  }

  map.on("click", (e) => {
    const { lng, lat } = e.lngLat;

    // 🔥 Guardar en los inputs ocultos
    document.getElementById("community_latitude").value = lat;
    document.getElementById("community_longitude").value = lng;

    // 🔥 Mover o crear el único marcador
    if (marker) {
      marker.setLngLat([lng, lat]);
    } else {
      marker = new mapboxgl.Marker({ color: "#d00" })
        .setLngLat([lng, lat])
        .addTo(map);
    }
  });
});
