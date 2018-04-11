
function onBiblMapClick(e) {
  query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
  execBiblQuery(query, e.layer.options.alt, e.layer.options.biblType, e.layer.options.locType);
}            

function onProfilesMapClick(e) {
  /*Should look like: getProfile__('Baghdad', 'profile_baghdad_01', 'profile_01.xslt'); */
  getProfile__(e.layer.options.alt, e.layer.options.id, 'profile_01.xslt');
}
   
function onFeaturesMapClick(e) {
  query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
  getFeature_(e.layer.options.alt, e.layer.options.id, 'features_01.xslt');
  
}  

function onSamplesMapClick(e) {
  execSampleQuery('vicav_samples', e.layer.options.id, 'sampletext_01.xslt');
}  

function onDictMapClick(e) {
  //execSampleQuery('vicav_samples', e.layer.options.id, 'sampletext_01.xslt');
  if (e.layer.options.id == 'dict_tunis') { execTextQuery('dictFrontPage_Tunis', 'TUNICO DICTIONARY', 'vicavTexts.xslt'); } 
  if (e.layer.options.id == 'dict_damascus') { execTextQuery('dictFrontPage_Damascus', 'DAMASCUS DICTIONARY', 'vicavTexts.xslt'); } 
  if (e.layer.options.id == 'dict_cairo') { execTextQuery('dictFrontPage_Cairo', 'CAIRO DICTIONARY', 'vicavTexts.xslt'); }   
}  

var mainMap = L.map('dvMainMap').setView([19.064, 24.544], 4);
L.tileLayer('https://api.mapbox.com/styles/v1/acetin/cjb22mkrf16qf2spyl3u1vee3/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYWNldGluIiwiYSI6ImNqYjIybG5xdTI4OWYyd285dmsydGFkZWQifQ.xG4sN5u8h-BoXaej6OjkXw', {
  maxZoom: 20,
  attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
  '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
  'Imagery © <a href="http://mapbox.com">Mapbox</a>'
    }).addTo(mainMap);
    
mainMap.scrollWheelZoom.disable();

var fgProfileMarkers = L.featureGroup().addTo(mainMap).on("click", onProfilesMapClick);
var fgSampleMarkers = L.featureGroup().addTo(mainMap).on("click", onSamplesMapClick);
var fgFeatureMarkers = L.featureGroup().addTo(mainMap).on("click", onFeaturesMapClick);
var fgBiblMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);
var fgGeoDictMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);
var fgDictMarkers = L.featureGroup().addTo(mainMap).on("click", onDictMapClick);