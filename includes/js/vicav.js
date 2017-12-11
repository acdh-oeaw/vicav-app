
    function onBiblMapClick(e) {
       query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
       execBiblQuery(query, e.layer.options.alt, e.layer.options.biblType, e.layer.options.locType);
   }            

     function onProfilesMapClick(e) {
       query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
       getProfile_(query, e.layer.options.alt);
   }
   
     function onFeaturesMapClick(e) {
       query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
       getFeature_(query, e.layer.options.alt, e.layer.options.id);
   }  




  var mainMap = L.map('dvMainMap').setView([32.064, 20.544], 4);
  L.tileLayer('https://api.mapbox.com/styles/v1/acetin/cjb22mkrf16qf2spyl3u1vee3/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYWNldGluIiwiYSI6ImNqYjIybG5xdTI4OWYyd285dmsydGFkZWQifQ.xG4sN5u8h-BoXaej6OjkXw&fresh=true', {
    maxZoom: 20,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
    '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
    'Imagery © <a href="http://mapbox.com">Mapbox</a>'
    }).addTo(mainMap);
    
    mainMap.scrollWheelZoom.disable();

  var fgProfileMarkers = L.featureGroup().addTo(mainMap).on("click", onProfilesMapClick);
  var fgFeatureMarkers = L.featureGroup().addTo(mainMap).on("click", onFeaturesMapClick);
  var fgBiblMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);
  var fgGeoDictMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);