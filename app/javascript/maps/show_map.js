document.addEventListener("turbo:load", () => {
  const mapDiv = document.getElementById("map-show");
  if (!mapDiv) return;

  const lat = parseFloat(mapDiv.dataset.lat);
  const lng = parseFloat(mapDiv.dataset.lng);

  const mapboxToken = document.querySelector('meta[name="mapbox-token"]').content;
  mapboxgl.accessToken = mapboxToken;

  const map = new mapboxgl.Map({
    container: "map-show",
    style: "mapbox://styles/mapbox/streets-v12",
    center: [lng, lat],
    zoom: 15,
    interactive: true
  });

  new mapboxgl.Marker({ color: "#d00" })
    .setLngLat([lng, lat])
    .addTo(map);
});
