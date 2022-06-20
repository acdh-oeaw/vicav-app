/* ************** REST INTERFACE ******************************************* */
/* ************************************************************************* */
/*
text
params: id, xslt

biblio
params: query, xslt

sample
params: coll, id, xslt

profile
params: coll=vicav_lingfeatures|vicav_profile, id, xslt

dict_index
params: dict, ind, str

dict_api
params: query, dict, xslt

 */

/* ************************************************************************* */
/* ************** URL SYNTAX *********************************************** */
/* ************************************************************************* */
/*
localhost:8984/vicav/index.html
map=BiblGeoMarkers&
map=[geoMarkers,vt:bedouin dialect,geo_reg]
1=[textQuery,dictFrontPage_Damascus,DAMASCUS DICTIONARY,open]

2=[biblQuery,reg:Egypt,open]

//the four volumes written by Abdelmassih
3=[biblQuery,zotid:IEMVQUR6 zotid:XB97YPPN zotid:LGYKDLM3 zotid:26MPUVYC,open]
3=[biblQuery,vt:Dictionary+reg:Egypt,open]   

4=[dictQuery,any=ktb,dc_tunico,open]

5=[biblQueryLauncher,open]
5=[createNewCrossDictQueryPanel,open]

n=[type, ( id | query), label, status]
n=[type, ( id | query), status]
 */
/* ************************************************************************* */

var inpSel = 0;
var containerCount = 0;
var lastTextPanelID = '';
var panelIDs =[];
var globalPreservePanel = -1;
var uiVersion = "@version@";
var dataVersion = "@data-version@";

/*
To create a new Version
1. Rename vicav_rest variable
2. Rename vicav_00x.xqm
3. Rename function names in vicav_00x.xqm
4. rename "/vicav_00x/index.html" in index.html
 */
/* The following tables can be created with VLE                */
/*    1. Control Form --> Analysis                             */
/*    2. Load a TEI Dictionary                                 */
/*    3. Extract Path = //tei:orth  + [ENTER]                  */
/*    4. Right-Click --> Extract all characters (with comma)   */

var charTable_tunis = '’,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_cairo = '’,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_baghdad = 'ʔ,ʕ,ā,b,č,d,ḍ,ḓ,ḏ,e,ē,ǝ,ġ,ǧ,ḥ,ī,ḷ,ṃ,ō,ṛ,š,ṣ,ṭ,ṯ,ū,ẓ';
var charTable_damasc = 'ʕ,ʔ,ā,ḅ,ʕ,ḍ,ḏ,ǝ,ᵊ,ē,ġ,ǧ,ḥ,ī,ḷ,ṃ,ō,ṛ,ṣ,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_msa = 'ˀ,ˁ,ā,ḍ,ḏ,ē,ġ,ǧ,ḥ,ī,ḷ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ʔ';

var baghdadFields =
    "                   <option value='any'>Any field</option>" +
    "                   <option value='lem'>Arabic lemma</option>" +
    "                   <option value='infl'>Arabic (infl.)</option>" +
    "                   <option value='en'>Trans. (English)</option>" +
    "                   <option value='de'>Trans. (German)</option>" +
    "                   <option value='es'>Trans. (Spanish)</option>" +
    "                   <option value='pos'>POS</option>" +
    "                   <option value='root'>Roots</option>";
var defaultFields =
	"                   <option value='any'>Any field</option>" +
	"                   <option value='lem'>Arabic lemma</option>" +
	"                   <option value='infl'>Arabic (infl.)</option>" +
	"                   <option value='en'>Trans. (English)</option>" +
	"                   <option value='de'>Trans. (German)</option>" +
	"                   <option value='fr'>Trans. (French)</option>" +
	"                   <option value='pos'>POS</option>" +
	"                   <option value='root'>Roots</option>" +
	"                   <option value='subc'>subc</option>" +
	"                   <option value='etymLang'>Lang. in etymologies</option>" +
	"                   <option value='etymSrc'>Words in etymologies</option>";
var MSAFields =
    "                   <option value='any'>Any field</option>" +
    "                   <option value='lem'>Arabic lemma</option>" +
    "                   <option value='infl'>Arabic (infl.)</option>" +
    "                   <option value='en'>Trans. (English)</option>" +
    "                   <option value='de'>Trans. (German)</option>" +
    "                   <option value='pos'>POS</option>" +
    "                   <option value='root'>Roots</option>";


/* ************************************************************************* */
/* ** Polyfill Functions that make modern features work in IE 11 *********** */
/* ************************************************************************* */
if (!String.prototype.includes) {
  String.prototype.includes = function(search, start) {
    'use strict';
    if (typeof start !== 'number') {
      start = 0;
    }
    
    if (start + search.length > this.length) {
      return false;
    } else {
      return this.indexOf(search, start) !== -1;
    }
  };
}

/* ************************************************************************* */
/* ** MAP Functions ******************************************************** */
/* ************************************************************************* */
function onBiblMapClick(e) {
    /*query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);*/
    /*execBiblQuery(query, e.layer.options.alt, e.layer.options.biblType, e.layer.options.locType);*/
    
    execBiblQuery(e.layer.options.biblQuery);
}

function onProfilesMapClick(e) {
    /*Should look like: getProfile('Baghdad', 'profile_baghdad_01', 'profile_01.xslt'); */
    getProfile(e.layer.options.alt, e.layer.options.id, 'profile_01.xslt');
}

function onFeaturesMapClick(e) {
    //query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
    getFeatureOfLocation(e.layer.options.alt, e.layer.options.id, 'features_01.xslt');
}

function onSamplesMapClick(e) {
    getSample('', e.layer.options.id, 'sampletext_01.xslt');
}

function onDictMapClick(e) {
    //execSampleQuery('vicav_samples', e.layer.options.id, 'sampletext_01.xslt');
    console.log(e.layer.options.id);
    if (e.layer.options.id == 'dict_tunis') {
        getText('TUNICO DICTIONARY', 'dictFrontPage_Tunis', 'vicavTexts.xslt');
    }
    if (e.layer.options.id == 'dict_damascus') {
        getText('DAMASCUS DICTIONARY', 'dictFrontPage_Damascus', 'vicavTexts.xslt');
    }
    if (e.layer.options.id == 'dict_baghdad') {
        getText('BAGHDAD DICTIONARY', 'dictFrontPage_Baghdad', 'vicavTexts.xslt');
    }
    if (e.layer.options.id == 'dict_cairo') {
        getText('CAIRO DICTIONARY', 'dictFrontPage_Cairo', 'vicavTexts.xslt');
    }
}

L.Icon.Default.prototype.options.iconSize = [13, 35];
L.Icon.Default.prototype.options.iconAnchor = [2, 35];

// we use a cop of the North Star map style: https://blog.mapbox.com/designing-north-star-c8574e299c94
// mapbox://styles/osiam/cl4mxp3zk003v15ufbeb1ynbc
// to copy and edit the VICAV North Star style use this link https://api.mapbox.com/styles/v1/osiam/cl4mxp3zk003v15ufbeb1ynbc.html?title=copy&access_token=pk.eyJ1Ijoib3NpYW0iLCJhIjoiY2pmMnVpZTV3MDFpNjJxbHQxb2Nna25ldiJ9.mlqREmow6onk_Zfco-qDHA&zoomwheel=true&fresh=true#4.6/31.38/26.74
// map style from acetin ~2017 https://api.mapbox.com/styles/v1/acetin/cjb22mkrf16qf2spyl3u1vee3.html?title=copy&access_token=pk.eyJ1IjoiYWNldGluIiwiYSI6ImNqYjIybG5xdTI4OWYyd285dmsydGFkZWQifQ.xG4sN5u8h-BoXaej6OjkXw&zoomwheel=true&fresh=true#4.6/31.38/26.74
var mainMap = L.map('dvMainMap').setView([19.064, 24.544], 4);
L.tileLayer('https://api.mapbox.com/styles/v1/osiam/cl4mxp3zk003v15ufbeb1ynbc/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1Ijoib3NpYW0iLCJhIjoiY2w0bXg1bnNkMTBlODNjcXBvNW95YXJxMyJ9.ZiEUkkjVe2jzAlHZTRcJXA', {
    maxZoom: 20,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
    '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
    'Imagery © <a href="http://mapbox.com">Mapbox</a>'
}).addTo(mainMap);

var layerGroupDialectRegions = L.layerGroup().addTo(mainMap);

mainMap.scrollWheelZoom.disable();
    window.addEventListener('hashchange', function(e){
    //console.log('hash changed1');
    var currentURL = window.location.toString();
    parseCurrentUrl(currentURL);
});

let overlapPopup = function(e, groupByType = false) {
    function ptDistanceSq(pt1, pt2) {
        let dx = pt1.x - pt2.x
        let dy = pt1.y - pt2.y
        return dx * dx + dy * dy
    }

    let marker = e.layer
    let featureGroup = Object.values(marker._eventParents)[0]
    let distance = Math.floor(1.5 * mainMap.getZoom())

    mainMap.closePopup();

    nearbyMarkerData = []
    nonNearbyMarkers = []
    pxSq = distance * distance
    markerPt = mainMap.latLngToLayerPoint(marker.getLatLng())
    Object.values(featureGroup._layers).forEach(m => {
        if (mainMap.hasLayer(m)){
            mPt = mainMap.latLngToLayerPoint(m.getLatLng())
            if (ptDistanceSq(mPt, markerPt) < pxSq){
              nearbyMarkerData.push({marker: m, markerPt: mPt})
            }
            else {
              nonNearbyMarkers.push(m)
            }   
        }
    })

    //console.log(nearbyMarkerData)

    if (nearbyMarkerData.length == 1) { // 1 => the one clicked => none nearby
        switch (marker.options.type) {
            case 'profile': 
                onProfilesMapClick(e);
                break;
            case 'sample':
                getSample(marker.options.alt, marker.options.id, 'sampletext_01.xslt');
                break;
            case 'feature':
                getFeatureOfLocation(marker.options.alt, marker.options.id, 'features_01.xslt');
                break;

        }
    }
    else if (groupByType) {
        let popupContent = '<h5>Near locations</h5>';
        let grouped = {}
        nearbyMarkerData.sort((a,b) => {
            return a.marker.options.alt.localeCompare(b.marker.options.alt);
        }).forEach(data => {

            if (grouped[data.marker.options.locName] === undefined) grouped[data.marker.options.locName] = {profile: [], feature: [], sample: []}
            console.log(grouped[data.marker.options.locName][data.marker.options.type])

            grouped[data.marker.options.locName][data.marker.options.type].push(data)
        })

        for (let loc in grouped) {
            popupContent += '<h6>' + loc + '</h6>';
            for (let dataType in grouped[loc]) {
                if (grouped[loc][dataType].length < 1) continue;
                let typeLink = exploreDataStrings[dataType].single_selector
                popupContent += '<em>' + dataType.charAt(0).toUpperCase() + dataType.slice(1) + '</em><ul class="overlapping-markers">';
                grouped[loc][dataType].forEach(data => {
                    popupContent += '<li class="overlapping-marker-label"><a href="#" ' + typeLink +'="'+data.marker.options.id + '">' + data.marker.options.alt + '</a></li>'
                })
                popupContent = popupContent + '</ul>';
            }
        }
        if (marker.options.locName) marker.alt = marker.options.locName;
        marker.bindPopup(popupContent).openPopup()
    }
    else {
        let popupContent = '<h5>Near locations</h5><ul class="overlapping-markers">'
        nearbyMarkerData.sort((a,b) => {
            return a.marker.options.alt.localeCompare(b.marker.options.alt); }
        ).forEach(data => {
            let typeLink = exploreDataStrings[data.marker.options.type].single_selector
            popupContent += '<li class="overlapping-marker-label"><a href="#" ' + typeLink +'="'+data.marker.options.id + '">' + data.marker.options.alt + '</a></li>'
        })

        popupContent = popupContent + '</ul>';
        if (marker.options.locName) marker.alt = marker.options.locName
        marker.bindPopup(popupContent).openPopup()
      }
}


let overlapHandler = function(e) {
    overlapPopup(e);
}

let overlapGroupByType = function(e) {
    overlapPopup(e, true);
}

var fgBiblMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);
var fgProfileMarkers = L.featureGroup().addTo(mainMap).on('click', overlapHandler);
var fgSampleMarkers = L.featureGroup().addTo(mainMap).on('click', overlapHandler); // Click event is now handled through OverlappingMarkerSpiderifier
var fgFeatureMarkers = L.featureGroup().addTo(mainMap).on('click', overlapHandler);
var fgDataMarkers = L.featureGroup().addTo(mainMap).on('click', overlapGroupByType);
var fgGeoDictMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);
var fgDictMarkers = L.featureGroup().addTo(mainMap).on("click", onDictMapClick);

mainMap.on('zoomend', (e) => {
    e.target.closePopup();
})

/* ************************************************************************* */
/* ************************************************************************* */
/* ************************************************************************* */
function createCharTable(idSuffix_, chars_) {
    //console.log('idSuffix_: ' + idSuffix_);
    //console.log('chars_: ' + chars_);
    
    sarr = chars_.split(',');
    s = '';
    for (var i = 0, len = sarr.length; i < len; i++) {
        s = s + "   <div id='ct" + idSuffix_ + "' class='dvLetter'>" + sarr[i] + "</div>";
    }
    return "   <div class='dvCharTable' id='dvCharTable" + idSuffix_ + "'>" + s + "   </div>";
}

function createMatchString(s_) {
    res = "";
    s_ = s_.trim();
    if ((s_.indexOf('*') > -1) ||
    (s_.indexOf('.') > -1) ||
    (s_.indexOf('^') > -1) ||
    (s_.indexOf('$') > -1) ||
    (s_.indexOf('+') > -1)) {
        //next line is necessary for IE
        s_ = encodeURIComponent(s_);
        res = 'matches(., "' + s_ + '")';
    } else {
        s_ = encodeURIComponent(s_);
        res = '.="' + s_ + '"';
    }
    return res;
}

function panelsBack() {
    for (var i = 0; i < sarray.length; i++) {
    }
}

function addID(id_) {
    panelIDs.push(id_);
    document.getElementById("dvOpenPanels").innerHTML = panelIDs.toString();
}

function makeAudioInVisible(obj_) {
    if (!$('audio', obj_).hasClass('playing')) {
        $(obj_).css("cursor", "none");
        $(obj_).find("audio").css("left", "-500px");
    }
}

function makeAudioVisible(obj_) {
    $(obj_).css("cursor", "pointer");
    var x = $(obj_).position();
    var audioWidth = $(obj_).find("audio").width();

    $(obj_).find("audio").css("left", $(obj_).width() - audioWidth);
    $(obj_).find("audio").css("top", x.top);
}

function changeURLMapParameter(newParameter) {
    var currentURL = window.location.toString();
    console.log(currentURL);
    if (currentURL.includes('#')) {
        var args = currentURL.split('#');
        var baseUrl = args[0];
        var args = args[1].split('&');
        // Parse the map
        var mapArg = args[0].split('=');
        if (mapArg[0] == 'map') {
            args[0] = 'map=' + newParameter;
        }
        args = args.join("&");
        console.log('replaceState changeURLMapParameter');
        //window.history.replaceState( {} , "", baseUrl + "#" + args);
    }
}

function changePanelVisibility(panel, type, expand)   {
    var pID = panel.data('pid');
    var currentURL = window.location.toString();
    var args = currentURL.split('#');
    var baseUrl = args[0];
    var args = args[1].split('&');

    if (type == 'minimize' || type == 'maximize') {
        if (type == 'minimize') {
            if (pID != globalPreservePanel) {
                var visState = 'closed';
                panel.removeClass('open-panel');
                panel.addClass('closed-panel');
            }
        } else {
            if (expand) {
              var visState = 'expanded';
            } else {
              var visState = 'open';
            }
            panel.removeClass('closed-panel');
            panel.addClass('open-panel');
        }
        for (var i = 1; i < args.length; i++) {
            if (args[i].charAt(0) == pID) {
                var pArgs = args[i].split('=');
                pArgs = pArgs[1].replace(/((\[\s*)|(\s*\]))/g, "");
                pArgs = pArgs.split(',');
                pArgs.pop();
                pArgs.push(visState);
                pArgs = "[" + pArgs.join(",") + "]";
                args[i] = pID + "=" + pArgs;
                break;
            }
        }
        args = args.join("&");
        console.log('replaceState (8)');
        window.history.replaceState({ }, "", baseUrl + "#" + args);
    } else if (type == 'close') {
        for (var i = 1; i < args.length; i++) {
            if (args[i].charAt(0) == pID) {
                args.splice(i, 1);
                break;
            }
        }
        args = args.join("&");
        //console.log('replaceState (changePanelVisibility 3)');
        //console.log('baseUrl + args: ' + baseUrl+"#"+args);
        //console.log('replaceState (9)');
        window.history.replaceState({}, "", baseUrl + "#" + args);
        panel.remove();
    }
}

function appendPanel(contents_, panelType_, secLabel_, contClass_, query_, teiLink_, locType_, snippetID_, pID_, pVisiblity_, pURL_) {
    var openPans = 0;
    var toBeClosed = -1;
    //console.log('appendPanel (secLabel): ' + secLabel_);
    secLabel_ = secLabel_.replace(/%20/, ' ');
    secLabel_ = secLabel_.replace(/_/, ' ');
    query_ = query_.replace(/%2b/,' & ');
    query_ = query_.replace(/,/,' & ');
    contents_ = contents_.replace(/{query}/, query_);

    $('.content-panel').each(function () {
        if (pVisiblity_ != 'closed') $(this).removeClass('expanded-panel');
        var panelID = $(this).data('pid');
        if ($(this).hasClass("open-panel")) {
            openPans += 1;
        }
    });

    if (openPans > 2 && ! pURL_) {
        var closeCnt = 0;
        $('.content-panel').each(function () {
            var panelID = $(this).data('pid');
            if ($(this).hasClass("open-panel")) {
                if ((panelID != globalPreservePanel) || (closeCnt < 1)) {
                    changePanelVisibility($(this), 'minimize');
                    closeCnt = closeCnt + 1;
                }
            }
        })
        /*
        var firstOpenPan = $(".open-panel").first();
        changePanelVisibility(firstOpenPan, 'minimize')
         */
    }

    /* ******************************************************/
    /* ***** Add a button to create TEI view ****************/
    /* ******************************************************/
    var teiLink = '';
    console.log('appendPanel: ' + teiLink_ + '  panelType_: ' + panelType_);
    if (teiLink_ == 'hasTeiLink') {
        switch (panelType_) {
            case 'profileQuery': teiLink_ = 'getProfile("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xslt")';
                                 break;
            case 'featureQuery': teiLink_ = 'getFeatureOfLocation("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xslt")';
                                 break;
            case 'crossFeaturesResults': teiLink_ = 'showLingFeatures("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xslt")';
                                 break;
            case 'sampleQuery': teiLink_ = 'getSample("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xslt")';
                                 break;
            case 'textQuery': teiLink_ = 'getText("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xslt")';
                                 break;
        }
    } else {
        teiLink_ = '';
    }

    //console.log('teiLink_: ' + teiLink_);
    if ((contents_.indexOf('<pre ') == -1) &&(teiLink_.length > 0)) {
        teiLink = "<a href='javascript:" + teiLink_ + "' class='aTEIButton'>TEI</a>";        
    } else {
        teiLink = '';
    }
    //console.log('teiLink: ' + teiLink);
    contents_ = contents_.replace(/{teiLink}/, teiLink);

    /* ******************************************************/
    /* ********* Add panel definition to URL ****************/
    /* ******************************************************/
    //console.log('pURL_: ' + pURL_);
    if (! pID_) {
        var pID = $('.content-panel').last().data('pid') + 1;
        if (! pURL_) {
            var currentURL = window.location.toString();

            switch (panelType_) {
                case 'crossFeaturesForm':
                case 'crossFeaturesResult':
                case 'crossSamplesForm':
                case 'crossSamplesResult':
                case 'biblQuery':
                qry = query_.replace(/&/g, "+").replace(/=/g, '|');
                var argList = pID + "=[" + panelType_ + "," + qry + ",";
                break;

                case 'biblQueryLauncher':
                    var argList = pID + "=[" + panelType_ + ",";
                    break;

                case 'crossDictQueryLauncher':
                    var argList = pID + "=[" + panelType_ + ",";
                    break;

                default:
                    var argList = pID + "=[" + panelType_ + "," + snippetID_ + "," + secLabel_ + ",";
            }

            if (locType_) {
                argList = argList + locType_ + ",";
            }
            argList = argList + "open]";
            //console.log('replaceState (appendPanel): ' + currentURL + "&" + argList);
            //console.log('replaceState (10)');            
            window.history.replaceState({ }, "", currentURL + "&" + argList);
        }
    } else {
        var pID = pID_;
    }

    if (pURL_) {
        var cssClass = pVisiblity_ + "-panel";
    } else {
        var cssClass = "open-panel";
    }

    /* ******************************************************/
    /* ******  Create additional panel  *********************/
    /* ******************************************************/
    var resCont = "<div class='" + contClass_ + "'>" + contents_ + "</div>";
    if (secLabel_.length == 0) {
       var htmlCont = panelType_;
    } else {
        if (panelType_.length == 0) {
           var htmlCont = secLabel_;
        } else {
           var htmlCont = panelType_ + ": " + secLabel_;    
        }
        
    }
    $(".initial-closed-panel").clone().removeClass('closed-panel initial-closed-panel').addClass(cssClass).attr("data-pid", pID).addClass(cssClass).attr("data-query", query_).attr("data-snippetID", snippetID_).appendTo(".panels-wrap").append(resCont).find(".chrome-title").html(htmlCont);
    return pID
}

function setExplanation(s_) {
    document.getElementById("dvExplanations").innerHTML = s_;
}

function createBiblExplanationPanel() {
    getText('BIBLIOGRAPHY: Explanation', 'vicavExplanationBibliography', 'vicavTexts.xslt');
}

function getCaptionFromMenuID(id_) {
   /***********************************************************************/
   /** Put _ instead of blank *********************************************/
   /** These ids are called from the menu: vicav_project/vicav.xml ********/
   /** There the start with li_ "list item"     ***************************/
   /** The caption is displayed on the left side of the panels. They are **/
   /** important when the panels are closed. ******************************/
   /***********************************************************************/
   var sRes = '';
   if (id_ == 'vicavArabicTools') { sRes = 'ARABIC_TOOLS'} else
   if (id_ == 'vicavContributeBibliography') { sRes = 'CONTRIBUTE TO BIBLIOGRAPHY'} else
   if (id_ == 'vicavContributeDictionary') { sRes = 'CONTRIBUTE A DICTIONARY'} else
   if (id_ == 'vicavContributeFeature') { sRes = 'CONTRIBUTE A FEATURE LIST'} else
   if (id_ == 'vicavContributeProfile') { sRes = 'CONTRIBUTE A PROFILE'} else
   if (id_ == 'vicavContributeSample') { sRes = 'CONTRIBUTE A SAMPLE'} else

   if (id_ == 'vicavContributors') { sRes = 'CONTRIBUTORS'} else
   if (id_ == 'vicavDictionaryEncoding') { sRes = 'DICTIONARIES_(ENCODING)'} else
   if (id_ == 'vicavDictionariesTechnicalities') { sRes = 'DICTIONARIES_(TECHNICALITIES)'} else
   if (id_ == 'vicavOverview_corpora_spoken') { sRes = 'CORPORA_OF_SPOKEN_ARABIC'} else
   if (id_ == 'vicavOverview_corpora_msa') { sRes = 'MSA_CORPORA'} else
   if (id_ == 'vicavOverview_special_corpora') { sRes = 'SPECIAL_CORPORA'} else
   if (id_ == 'vicavOverview_corpora_historical_varieties') { sRes = 'CORPORA_OF_HISTORICAL_LANGUAGE'} else
   if (id_ == 'vicavOverview_dictionaries') { sRes = 'DICTIONARY PROJECTS'} else
   if (id_ == 'vicavOverview_nlp') { sRes = 'ARABIC NLP'} else
   if (id_ == 'vicavOverview_otherStuff') { sRes = 'OTHER STUFF'} else
   if (id_ == 'vicavLearning') { sRes = 'LEARNING'} else
   if (id_ == 'vicavLearningTextbookDamascus') { sRes = 'TEXTBOOK_DAMASCUS'} else
   if (id_ == 'vicavLearningSmartphone') { sRes = 'VOCABULARIES ON SMARTPHONES'} else
   if (id_ == 'vicavLearningPrograms') { sRes = 'LEARNING PROGRAMS'} else
   if (id_ == 'vicavLearningData') { sRes = 'LEARNING DATA'} else
   if (id_ == 'vicavKeyboards') { sRes = 'KEYBOARDS'} else
   if (id_ == 'vicavVLE') { sRes = 'DICTIONARY_EDITOR (VLE)'} else

  if (id_ == 'vicavExplanationBibliography') { sRes = 'BIBLIOGRAPHY (DETAILS)'} else
  if (id_ == 'vicavExplanationCorpusTexts') { sRes = 'CORPUS TEXTS (DETAILS)'} else
  if (id_ == 'vicavExplanationFeatures') { sRes = 'FEATURES (DETAILS)'} else
  if (id_ == 'vicavExplanationProfiles') { sRes = 'PROFILES_(DETAILS)'} else
  if (id_ == 'vicavExplanationSamples') { sRes = 'SAMPLES_(DETAILS)'} else
  if (id_ == 'vicavExploreFeatures') { sRes = 'EXPLORE FEATURES'} else


  if (id_ == 'vicavLinguistics') { sRes = 'LINGUISTICS'} else
  if (id_ == 'vicavMission') { sRes = 'MISSION'} else
  if (id_ == 'vicavNews') { sRes = 'VICAV NEWS'} else
  if (id_ == 'vicavTypesOfText') { sRes = 'TYPES OF TEXT'} else 
  {}

  return sRes;
}

function createNewQueryBiblioPanel(pID_, pVisiblity_, pURL_) {
    var searchContainer =
    "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>" +
    "    <input class='form-control mr-sm-2' type='text' style='flex: 1;' placeholder='Search in bibliographies ...' aria-label='Search'>" +
    "    <button class='biblQueryBtn'>Query</button><br/>" +
    "</form>" +
    "<div class='selQueryType'>" +
    "   <input type='checkbox' id='cbAsText' class='checkbox' value='As text' checked='checked'><label class='checkboxLabel' for='cbAsText'>Display as text</label>" +
    "   <input type='checkbox' id='cbAsMap' value='On map'><label class='checkboxLabel' for='cbAsMap'>Display on map</label>" +
    "</div>" +
    "<p>For details as to how to formulate meaningful queries in the bibliography <a class='aVicText' href='javascript:createBiblExplanationPanel()'>click here</a>.</p>";
    appendPanel(searchContainer, "biblQueryLauncher", "", "grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
}

function createDisplayFeaturesPanel() {
    var searchContainer =
    "<div class='dvCrossFeatures' id='dvCrossFeatures'></div>";
    //appendPanel(searchContainer, "crossFeaturesResults", "", "grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
    appendPanel(searchContainer, "crossFeaturesResults", "", "grid-wrap", '', 'hasTeiLink', '', '');
}

function createNewCrossDictQueryPanel(pID_, pVisiblity_, pURL_) {
    var jsText = "getText(&#39;TUNICO DICTIONARY&#39;, &#39;dictFrontPage_Tunis&#39;, &#39;vicavTexts.xslt&#39;)";

    var searchContainer =
    "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>" +
    "    <input class='form-control mr-sm-2' type='text' style='flex: 1;' placeholder='Search in dictionaries ...' aria-label='Search'>" +
    "    <button class='crossDictQueryBtn'>Query</button><br/>" +
    "</form>" +
    "<div class='selQueryType'>" +
    "<input type='checkbox' id='cbCairo' class='checkbox' value='Cairo'><label class='checkboxLabel' for='cbCairo'>Cairo</label>" +
    "   <input type='checkbox' id='cbDamascus' class='checkbox' value='Damascus'><label class='checkboxLabel' for='cbDamascus'>Damascus</label>" +
    "   <input type='checkbox' id='cbTunis' class='checkbox' value='Tunis' checked='checked'><label class='checkboxLabel' for='cbTunis'>Tunis</label>" +
    "   <input type='checkbox' id='cbBaghdad' class='checkbox' value='Baghdad' checked='checked'><label class='checkboxLabel' for='cbBaghdad'>Baghdad</label>" +
    "   <input type='checkbox' id='cbMSA' class='checkbox' value='MSA'><label class='checkboxLabel' for='cbMSA'>MSA</label>" +
    "</div>" +
    "<div class='selQueryType'><input type='checkbox' id='cbIntegratedResult' class='checkbox' value='MSA'><label class='checkboxLabel' for='cbIntegratedResult'>Integrated Results</label></div>" + 
    "<p>For details as to how to formulate meaningful dictionary queries " +
    "consult the <a class='aVicText' href='javascript:" + jsText + "'>examples of the TUNICO dictionary</a>.</p>";
    appendPanel(searchContainer, "crossDictQueryLauncher", "", "grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
}

function createNewCrossDictResultsPanel(pID_, pVisiblity_, pURL_) {
    //console.log('chartable_:' + chartable_);

    //console.log("selectFields_: " + selectFields_);
    var displayContainer =
    "<div id='dvDictResults_cross' class='dvDictResults'></div>" +
    "";

    appendPanel(displayContainer, 'crossDictQueryResult', '', "grid-wrap dict-grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);

}

function createNewDictQueryPanel(dict_, dictName_, idSuffix_, xslt_, chartable_, selectFields_, pID_, pVisiblity_, pURL_) {
    //console.log('chartable_:' + chartable_);
    
    ob = $("#loading-wrapper" + idSuffix_).length;
    if (ob > 0) {
        alert('Dict query panel already exists');
    } else {
    	//console.log("selectFields_: " + selectFields_);
        var js = 'javascript:execDictQuery_tei("' + idSuffix_ + '")';
        var searchContainer =
        "   <div class='loading-wrapper' id='loading-wrapper" + idSuffix_ + "'><img class='imgPleaseWait' id='imgPleaseWait" + idSuffix_ + "' src='images/balls_in_circle.gif' alt='Query'></div>" +
        "   <div class='dict-search-wrapper'>" +
        "    <table class='tbHeader'>" +
        "        <tr><td><h2>" + dictName_ + "</h2></td><td class='tdTeiLink'><a href=\'" + js + "\' class='aTEIButton'>TEI</a></td></tr>" +
        "    </table>" +
        createCharTable(idSuffix_, chartable_) +

        "      <div class='form-inline mt-2 mt-md-0'>" +
        "        <div class='tdInputFrameMiddle' class='mr-sm-2' style='flex: 1;'><input type='text' id='inpDictQuery" + idSuffix_ + "' xslt='" + xslt_ + "' path='tunico' dict='" + dict_ + "' teiQuery='' value='' placeholder='Search in dictionary ...' class='form-control inpDictQuery" + idSuffix_ + "'/>" +
        "   <div id='dvWordSelector" + idSuffix_ + "' class='dvWordSelector'>" +
        "      <select class='form-control' size='10' id='slWordSelector" + idSuffix_ + "'>" +
        "         <option></option>" +
        "       </select>" +
        "   </div></div>" +
        "            <div id='dvFieldSelect" + idSuffix_ + "' class='dvFieldSelect'>" +
        "               <select id='slFieldSelect" + idSuffix_ + "' class='slFieldSelect form-control'>" +
        "                  " + selectFields_ +
        "               </select>" +
        "            </div>" +
        "        <div class='tdInputFrameRight my-2 my-sm-0'><span id='dictQuerybtn" + idSuffix_ + "' class='spTeiLink'><a class='aVicText'>Search</a></span></div>" +
        "      </div>" +

        "   </div>" +
        "   <div id='dvDictResults" + idSuffix_ + "' class='dvDictResults'></div>" +
        "";

        appendPanel(searchContainer, 'dictQuery', dict_, "grid-wrap dict-grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
    }
}

/* *************************************************************************** */
/* ** This func is used by the examples of the explanation texts (vicav_texts) */
/* *************************************************************************** */
function autoDictQuery(suffixes_, query_, field_) {
    suffixes = suffixes_.split(',');
    //console.log('suffixes.length: ' + suffixes.length);
    for (var i = 0; i < suffixes.length; i++) {
        //console.log('suffix: ' + suffixes[i]);
        ob = document.getElementById('inpDictQuery' + suffixes[i]);
        if (ob == null) {
            switch (suffixes[i]) {
                case '_tunis':
                    createNewDictQueryPanel('dc_tunico', 'TUNICO Dictionary', '_tunis', 'tunis_dict_001.xslt', charTable_tunis, defaultFields);
                    break;
                case '_cairo':
                    createNewDictQueryPanel('dc_arz_eng_publ', 'Cairo Dictionary Query', '_cairo', 'cairo_dict_001.xslt', charTable_cairo, defaultFields);
                    break;

                case '_damascus':
                    createNewDictQueryPanel('dc_apc_eng_publ', 'Damascus Dictionary Query', '_damascus', 'damascus_dict_001.xslt', charTable_damasc, defaultFields);
                    break;

                case '_baghdad':
                    //console.log('baghdad dict');
                    createNewDictQueryPanel('dc_acm_baghdad_eng_publ', 'Baghdad Dictionary Query', '_baghdad', 'baghdad_dict_001.xslt', charTable_baghdad, baghdadFields);
                    break;

                case '_MSA':
                    createNewDictQueryPanel('dc_ar_en_publ', 'MSA Dictionary Query', '_MSA', 'fusha_dict_001.xslt', charTable_msa, MSAFields);
                    break;
            }
            dealWithFieldSelectVisibility(query_, suffixes_[i]);
        }

        ob = document.getElementById('inpDictQuery' + suffixes[i]);
        if (ob) {
            query_ = query_.trim();
            $('#' + 'inpDictQuery' + suffixes[i]).val(query_);
            $('#slFieldSelect' + suffixes[i]).val(field_).change();
            execDictQuery(suffixes[i]);
        }
    }
}

function delElement(id_) {
    $(id_).remove();
}

function hideElement(id_) {
    $(id_).hide();
}

function getText(secLabel_, snippetID_, style_, pID_, pVisibility_, pURL_) {
   //console.log('getText: ' + secLabel_ + " : #" + snippetID_.substring(0,3) + "# : " + style_ + " : " + pID_ + " : " + pVisibility_ + " : " + pURL_);
   if (snippetID_.substring(0, 3) == 'li_') {
      snippetID_ = snippetID_.substring(3);
   }

   qs = './text?id=' + snippetID_ + '&xslt=' + style_;
   //console.log('getText: ' + qs);

   $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
           if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
           } else {
              /*
              var doc = new DOMParser().parseFromString(result, "text/html");
              if (doc) {
                 var el = doc.getElementsByTagName("div")[0];
                 if (el) {
                    console.log('secLabel_ (1): ' + secLabel_);
                    var shortTitle = el.getAttribute("n");
                    if (shortTitle) {
                       secLabel_ = shortTitle;
                    }
                    console.log('secLabel_ (2): ' + secLabel_);
                 } else {
                 }
              } else {
                 //console.log('doc not ok');
              }
              */
              //appendPanel(result, "textQuery", secLabel_, "grid-wrap", "", "hasTeiLink", "", snippetID_, pID_, pVisibility_, pURL_);*/
              appendPanel(result, "textQuery", secLabel_, "grid-wrap", "", "hasTeiLink", "", snippetID_, pID_, pVisibility_, pURL_);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 681' + errorThrown);
        }
    });
}

function getDBSnippet(s_) {
    /******************************************************************/
    /*  This function is being triggered by calls such as those below */
    /*      <rs ref="text:vicavExplanationProfiles">                  */
    /*      <rs ref="func:openDict_Baghdad()">                        */
    /******************************************************************/
    console.log('getDbSnippet: ' + s_);
    var refStrings = s_.split(';');
    
    for (var i = 0, len = refStrings.length; i < len; i++) {
        console.log('refString: ' + i + ': ' + refStrings[i]);
        
        //refStrings[i] = refStrings[i].replace(/_/, ' ');
        splitPoint = refStrings[i].indexOf(":");
        sHead = refStrings[i].substr(0, splitPoint);
        sTail = refStrings[i].substring(splitPoint + 1);       
        console.log('sTail: ' + sTail);
        //console.log('sHead: ' + sHead);
        sh = sTail.split('/');
        snippetID = trim(sh[0]);
        var secLabel = '';
        if (sh[1]) {
            secLabel = trim(sh[1]);
            secLabel = secLabel.replace(/_/g, ' ');
        }

        console.log('sHead: ' + sHead);
        switch (sHead) {
                case 'bibl':
                        //console.log(sTail);
                        execBiblQuery_tei(sTail);
                        break;

                case 'func':
                        //console.log(sTail);
                        eval(trim(sTail));
                        break;

                case 'dictID':
                        console.log('sHead2: ' + sHead);
                        st5 = sTail.split(',');
                        sid = st5[0];
                        sDict = st5[1];
                        console.log('sid: ' + sid);
                        console.log('dict: ' + sDict);
                        switch (sDict) {
                           case 'ar-arz-x-cairo-vicav': autoDictQuery('_cairo', 'id=' + sid, ); break;
                           case 'ar-aeb': autoDictQuery('_tunis', 'id=' + sid, ); break;
                           case 'ar-acm-x-baghdad-vicav': autoDictQuery('_baghdad', 'id=' + sid, ); break;
                           case 'ar-apc-x-damascus-vicav': autoDictQuery('_damascus', 'id=' + sid, ); break;
                           case 'ar-x-DMG': autoDictQuery('_MSA', 'id=' + sid, ); break;
                        }
                        if (sDict = '')

                        break;

                case 'mapMarkers':
                        clearMarkerLayers();
                        insertGeoRegMarkers(sTail, 'geo_reg');
                        break;

                case 'sound':
                        break;

                case 'flashcards':
                        dict = sh[0];
                        lesson = sh[1];
                        type = sh[2];
                        getFlashCards(lesson, dict, type);
                        break;

                case 'corpus':
                        //console.log(snippetID + ' : ' + secLabel);
                        getCorpusText(secLabel, snippetID, 'sampletext_01.xslt', '', '', '');
                        break;

                case 'sample':
                        //console.log(snippetID + ' : ' + secLabel);
                        getSample(secLabel, snippetID, 'sampletext_01.xslt', '', '', '');
                        break;

                case 'feature':
                        getFeatureOfLocation(secLabel, snippetID, 'features_01.xslt', '', '', '');
                        break;

                case 'profile':
                        getProfile(secLabel, snippetID, 'profile_01.xslt', '', '', '');
                        break;

                case 'text':
                        //console.log('seclabel: ' + secLabel + '   snippetID: ' + snippetID);

                        getText(secLabel, snippetID, 'vicavTexts.xslt', '', '', '');
                        break;

                case 'zotid':
                        //console.log('sTail: ' + sTail);
                        execBiblQuery_zotID(sTail);
                        break;
        }
    }
}

function execBiblQuery_tei(query_, pID_, pVisiblity_, pURL_) {
    console.log('execBiblQuery_tei: ' + query_);
    query1_ = query_.replace(/&/g, '+');
    //console.log('query1_: ' + query1_);
    query1_ = query1_.replace(/=/g, ':');
    query1_ = query1_.replace(/,/g, '+');
    query1_ = query1_.replace(/ \+/g, '+');
    query1_ = query1_.replace(/\+ /g, '+');
    query1_ = query1_.replace(/\+/g, '%2b');
    //query1_ = query1_.replace(/\+/g, ',');
    query1_ = query1_.replace(/bibl:/g, '');
    qs = './biblio_tei?query=' + query1_ + '&xslt=biblio_tei_01.xslt'
    console.log('qs: ' + qs);

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
            } else {
                appendPanel(result, "biblQuery", query1_, "grid-wrap", query_, "noTeiLink", "", "", pID_, pVisiblity_, pURL_);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 785: ' + errorThrown);
        }
    });
}

function execBiblQuery_zotID(query_, pID_, pVisiblity_, pURL_) {
    //console.log('execBiblQuery_zotID');
    //console.log('   query_: ' + query_);
    //console.log('   pID: ' + pID_);

    query_ = query_.replace(/zotid:/g, '');
    qs = './biblio_id?query=' + query_ + '&xslt=biblio_tei_01.xslt'

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
            } else {
                appendPanel(result, "biblQuery", "", "grid-wrap", 'zotid:' + query_, 'noTeiLink', '', pID_, '', pVisiblity_, pURL_);
                //appendPanel(result, "profileQuery", caption_, "grid-wrap", '',     'hasTeiLink', '', snippetID_, pID_, pVisiblity_, pURL_);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 814: ' + errorThrown);
        }
    });
}

function execBiblQuery(query_, pID_, pVisiblity_, pURL_) {
    console.log('execBiblQuery:: query: ' + query_);

    if (sss('reg:', query_) || sss('geo:', query_) || sss('vt:', query_)) {
       execBiblQuery_tei(query_, pID_, pVisiblity_, pURL_);
    } else if (sss('zotid:', query_)) {
       execBiblQuery_zotID(query_, pID_, pVisiblity_, pURL_);
    } else {
       execBiblQuery_tei(query_, pID_, pVisiblity_, pURL_);
    }
}

function getDataList(type, pID_, pVisiblity_, pURL_) {
    $.ajax({
        url: 'data_list',
        data: {'type':  type },
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            //console.log(result);
            appendPanel(result, "dataList", type, "grid-wrap", '', 'hasTeiLink', '', type, pID_, pVisiblity_, pURL_);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 844: ' + errorThrown);
        }
    });
}

function getSample(caption_, snippetID_, style_, pID_, pVisiblity_, pURL_) {
    id_ = snippetID_.replace(/sampleText:/, '');
    qs = './sample?coll=vicav_samples&id=' + snippetID_ + '&xslt=' + style_;
    //console.log(qs);

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            //console.log(result);
            appendPanel(result, "sampleQuery", caption_, "grid-wrap", '', 'hasTeiLink', '', snippetID_, pID_, pVisiblity_, pURL_);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 866' + errorThrown);
        }
    });
}

function getCorpusText(caption_, snippetID_, style_, pID_, pVisiblity_, pURL_) {
    id_ = snippetID_.replace(/sampleText:/, '');
    qs = './sample?coll=vicav_corpus&id=' + snippetID_ + '&xslt=' + style_;
    //console.log(qs);

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            //console.log(result);
            appendPanel(result, "sampleQuery", caption_, "grid-wrap", '', 'hasTeiLink', '', snippetID_, pID_, pVisiblity_, pURL_);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 888' + errorThrown);
        }
    });
}

function showLingFeatures(ana_, expl_, type_) {
    ana_ = ana_.replace("#", '');
    //console.log('expl_: ' + expl_);
    if (type_ == 'tei') {
        qs = './features?ana=' + encodeURIComponent(ana_) + '&expl=' + encodeURIComponent(expl_) + '&xslt=tei_2_html__v004__gen.xslt';
    } else {
        qs = './features?ana=' + encodeURIComponent(ana_) + '&expl=' + encodeURIComponent(expl_) + '&xslt=cross_features_01.xslt';
    }
    //console.log('qs: ' + qs);

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
            } else {
                //appendPanel(result, "featureQuery", "features", "grid-wrap", '', 'hasTeiLink', '', snippetID_, pID_, pVisiblity_, pURL_);
                //console.log(result);
                result = result.replace(/==teiFuncID==/, '#' + ana_);
                result = result.replace(/==teiFuncLabel==/, expl_);
                
                ob = document.getElementById("dvCrossFeatures");
                if (ob) {
                  ob.innerHTML = result;
                } else {
                  createDisplayFeaturesPanel();  
                  ob = document.getElementById("dvCrossFeatures");
                  if (ob) {
                    ob.innerHTML = result;
                  }
                }
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 932' + errorThrown);
        }
    });
}


function getFeatureOfLocation(caption_, snippetID_, style_, pID_, pVisiblity_, pURL_) {
    qs = './profile?coll=vicav_lingfeatures&id=' + snippetID_ + '&xslt=' + style_;

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
            } else {
                appendPanel(result, "featureQuery", caption_, "grid-wrap", '', 'hasTeiLink', '', snippetID_, pID_, pVisiblity_, pURL_);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 956' + errorThrown);
        }
    });
}

function getProfile(caption_, snippetID_, style_, pID_, pVisiblity_, pURL_) {
    qs = './profile?coll=vicav_profiles&id=' + snippetID_ + '&xslt=' + style_;
    caption_ = caption_.replace("%20", " ");
    console.log('getProfile: ' + caption_ + " : #" + snippetID_ + "# : " + style_ + " : " + pID_ + " : " + pVisiblity_ + " : " + pURL_);

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
            } else {
                appendPanel(result, "profileQuery", caption_, "grid-wrap", '', 'hasTeiLink', '', snippetID_, pID_, pVisiblity_, pURL_);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 981' + errorThrown);
        }
    });
}

function clearMarkerLayers() {
    $("#dvOnMapText").hide();

    fgProfileMarkers.clearLayers();
    fgSampleMarkers.clearLayers();
    fgBiblMarkers.clearLayers();
    fgDictMarkers.clearLayers();

    fgFeatureMarkers.clearLayers();
    fgGeoDictMarkers.clearLayers();
}

/* **************************************************** */
/* *** DICTIONARY FUNCTIONS *************************** */
/* **************************************************** */
function execDictQuery_ajax(query_, idSuffix_) {
    if (query_.length > 0) {
        console.log("execDictQuery_ajax");
        console.log("query: " + query_);
        console.log("idSuffix: " + idSuffix_);

        xslt = $("#inpDictQuery" + idSuffix_).attr('xslt');
        teiQuery = query_.replace(xslt, "tei_2_html__v004__gen.xslt");
        $("#inpDictQuery" + idSuffix_).attr('teiQuery', teiQuery);

        $.ajax({
            url: query_,
            type: 'GET',
            dataType: 'html',
            cache: false,
            crossDomain: true,
            contentType: 'application/html; charset=utf-8',
            success: function (result) {
                if (result.includes('error type="user authentication"')) {
                    alert('Error: authentication did not work');
                } else {
                    $("#dvWordSelector" + idSuffix_).hide();
                    $("#slWordSelector" + idSuffix_).hide();
                    $("#imgPleaseWait" + idSuffix_).css('visibility', 'hidden');
                    $("#loading-wrapper" + idSuffix_).css('visibility', 'hidden');
                    $("#dvDictResults" + idSuffix_).html(result);
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert('Line 1029' + errorThrown);
                $("#imgPleaseWait" + idSuffix_).css('visibility', 'hidden');
                $("#loading-wrapper" + idSuffix_).css('visibility', 'hidden');
            }
        });
    }
}

function fillWordSelector(q_, dictInd_, idSuffix_) {
    /*
    if (q_.length == 0) {
        q_ = '.*';
    }
    */
    if (q_.length > 1) {
      $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');

      if (q_.length > 1 && q_.indexOf(' ') === -1) {
          q_ += '.*'
      }
       sInd = $("#slFieldSelect" + idSuffix_).val();
       sIndexUrl = './dict_index?dict=' + dictInd_ + '&ind=' + sInd + '&str=' + encodeURI(q_);
       console.log(sIndexUrl);
       $.ajax({
           url: sIndexUrl,
           type: 'GET',
           dataType: 'html',
           contentType: 'application/html; charset=utf-8',
           success: function (result) {
               if (result.indexOf('option') !== -1) {
                   $("#dvWordSelector" + idSuffix_).show();
                   $("#slWordSelector" + idSuffix_).html(result);
                   $("#slWordSelector" + idSuffix_).show();
               } else {
                   $("#dvWordSelector" + idSuffix_).hide();
               }
               $("#imgPleaseWait" + idSuffix_).css('visibility', 'hidden');
           },
           error: function (jqXHR, textStatus, errorThrown) {
               alert('Line 1063' + errorThrown);
               $("#imgPleaseWait" + idSuffix_).css('visibility', 'hidden');
           }
       });
    }
}

var timeoutFillWordSelector;

// Returns a function, that, as long as it continues to be invoked, will not
// be triggered. The function will be called after it stops being called for
// N milliseconds. If `immediate` is passed, trigger the function on the
// leading edge, instead of the trailing.
function debounceFillWordSelector(func, wait, immediate, arguments) {
    var context = this, args = arguments;
    var later = function() {
      timeoutFillWordSelector = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeoutFillWordSelector;
    clearTimeout(timeoutFillWordSelector);
    timeoutFillWordSelector = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
};

function getSuffixID(id_) {
    sid = id_;
    sids = sid.split('_');
    return sids[1];
}

function updateUrl_biblMarker(query_, scope_) {
    console.log('updateUrl_biblMarker');
    console.log('query: ' + query_ + ' scope_: ' + scope_);
    currentURL = window.location.toString();
//    if (currentURL.includes('#')) {
        console.log('replaceState (4a): ' + query_ + ':' + scope_);
        var args_01 = currentURL.split('#');
        var args_02 = (args_01[1] || '').split('&');
        var sOut = '';
        for (var i = 0; i < args_02.length; i++) {
            if (i == 0) {
                sOut = 'map=[biblMarkers,' + query_ + ',' + scope_ + ']';
            } else {
                sOut = sOut + '&' + args_02[i];
            }
        }
        var newUrl = args_01[0] + '#' + sOut;
        console.log('updateUrl_biblMarker::newUrl: ' + newUrl);
        //console.log(currentURL);
        console.log('replaceState (4)');
        window.history.replaceState({ }, "", newUrl);
//    }
}

function updateUrl_dictQuery(idSuffix_, query_, collname_) {
    pid = $("#inpDictQuery" + idSuffix_).closest("*[data-pid]").attr("data-pid");
    query_ = query_.replace("=", "-eq-");

    currentURL = window.location.toString();
    var args = currentURL.split('#');
    //console.log('query_: ' + query_);
    //console.log(args[1]);
    var args_ = args[1].split('&');
    //console.log(args_.length);
    for (var i = 1; i < args_.length; i++) {
        //console.log(i + ' ' + args_[i]);
        parts = args_[i].split('=');
        //console.log('parts[0]: "' + parts[0] + '"');
        //console.log('pid: "' + pid + '"');
        if (parts[0] == pid) {
            //console.log('ident');
            //console.log('old: ' + args[i]);
            //console.log('   new: ' + pid + '=[dictQuery,' + query_ + ',' + collname_ + ',open]');
            args_[i] = pid + '=[dictQuery,' + query_ + ',' + collname_ + ',open]';
        } else {
            //console.log('not ident');
        }
    }

    var sout = args_[0];
    for (var i = 1; i < args_.length; i++) {
        sout = sout + "&" + args_[i];
    }
    console.log('replaceState (5)');
    window.history.replaceState({
    },
    "", args[0] + '#' + sout);
}

function execDictQuery(idSuffix_) {
    //console.log('execDictQuery');

    XSLTName = $("#inpDictQuery" + idSuffix_).attr('xslt');
    pathName = $("#inpDictQuery" + idSuffix_).attr('path');
    collName = $("#inpDictQuery" + idSuffix_).attr('dict');

    $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');
    $("#dvDictResults" + idSuffix_).html('');

    var sq = $("#inpDictQuery" + idSuffix_).val();
    var field = $("#slFieldSelect" + idSuffix_).val();
    if (sq.length > 0) {
        sq = sq.replace(/\[/g, '');
        sq = sq.replace(/\]/g, '');
        sq = sq.trim();

        if (sq.indexOf("=") == -1) {
            sq = field + '="' + sq + '"';
        }
        sq = sq.replace(/&/g, ',');
        //console.log('execDictQuery: ' + sq);
        sq = sq.replace(/\+/g, '~~pl~~');
        //console.log('execDictQuery: ' + sq);
        sq = sq.replace(/min=/g, 'min~~eq~~');
        //console.log('execDictQuery1: ' + sq);

        sQuery = './dict_api?query=' + encodeURI(sq) + '&dict=' + collName + '&xslt=' + XSLTName;

        if (sQuery.length > 0) {
            execDictQuery_ajax(sQuery, idSuffix_);
            updateUrl_dictQuery(idSuffix_, sq, collName);
        } else {
            alert('Could not create query.');
        }
    } else {
        $("#imgPleaseWait" + idSuffix_).css('visibility', 'hidden');
    }
}

function execDictQuery_tei(idSuffix_) {
    var teiQuery = $('#inpDictQuery' + idSuffix_).attr('teiQuery');
    execDictQuery_ajax(teiQuery, idSuffix_);
}

function execCrossDictQuery(dicts_, query_) {
    //qs = './dicts_api?query=' + query_ + '&dicts=dc_tunico,dc_acm_baghdad_eng_publ&xslt=dicts_cross_query_001.xslt';
    //*****************************************************
    //*** root=ktb & pos=verb  --> root=ktb , pos=verb ****
    //*****************************************************
    if (query_.indexOf("&") > 0) {
       query_ = query_.replace(/\&/, ',');
    }

    //*****************************************************
    //*** adds a field identifier if there is none ********
    //*****************************************************
    var queries = query_.split(',');
    for (i in queries) {
       if (queries[i].indexOf("=") == -1) {
          queries[i] = 'any="' + queries[i] + '"';
       }                                       }
    /*
    for (var i = 0; i < queries.length; i++) {
       if (queries[i].indexOf("=") == -1) {
          queries[i] = 'any="' + queries[i] + '"';
       }
    }
    */

    query_ = '';
    for (var i = 0; i < queries.length; i++) {
       if (i == 0) {
         query_ = queries[0];
       } else {
         query_ = query_ + ',' + queries[1];
       }
    }

    qs = './dicts_api?query=' + query_ + '&dicts=' + dicts_ + '&xslt=dicts_cross_query_001.xslt';
    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
            } else {
                //alert(result);
                //appendPanel(contents_, panelType_,       secLabel_, contClass_,  query_, teiLink_, locType_,         snippetID_, pID_, pVisiblity_, pURL_) {
                ob = document.getElementById('dvDictResults_cross');
                if (ob == null) {
                  //appendPanel(result,    'crossDictQuery', '',           'grid-wrap', '',     '',       '_crossDictQuery', '',         '',    '',         '');
                  createNewCrossDictResultsPanel('', '', '');
                } else {
                  console.log('');
                }
                ob = document.getElementById('dvDictResults_cross');
                if (ob) {
                   //ob.innerHtml = result;
                   $("#dvDictResults_cross").html(result);
                } else {
                   alert('on not found');
                }


            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 814: ' + errorThrown);
        }
    });

};

function dealWithFieldSelectVisibility(query_, suffix_) {
    //console.log(query_ + ':' + suffix_);
    if (query_.indexOf('=') > -1) {
        $('#dvFieldSelect' + suffix_).hide();
    } else {
        $('#dvFieldSelect' + suffix_).show();
    }
}

function dealWithDictQueryKeyInput(event_, idSuffix_) {
    collName = $("#inpDictQuery" + idSuffix_).attr('dict');

    if (event_.which == 13) {
        execDictQuery(idSuffix_);
    } else if (event_.which == 40)
    /* Arrow Down */ {
        $("#slWordSelector" + idSuffix_).focus();
        $("#slWordSelector" + idSuffix_ + " option:first").attr('selected', 'selected');
    } else {
        $("#dvCharTable" + idSuffix_).show();
        var sq = $("#inpDictQuery" + idSuffix_).val();

        dealWithFieldSelectVisibility(sq, idSuffix_);
        if (sq.indexOf('=') == -1) {
            debounceFillWordSelector(fillWordSelector, 500, false, [sq, collName + '__ind', idSuffix_]);
        } else {
            $("#dvWordSelector" + idSuffix_).hide();
        }
    }
}

function insertBiblGeoMarkers() {
    insertGeoRegMarkers('', 'geo_reg');
}

function adjustNav(id_, activateID_) {
    $(".sub-nav-map-items .active").removeClass("active");
    if (activateID_.indexOf('sub') !== -1) {
        $(activateID_).addClass("active");
    }
    changeURLMapParameter(id_);
}

function openDictFront_Damascus() {
    //createNewDictQueryPanel('dc_apc_eng_publ', 'Damascus Dictionary Query', '_damascus', 'damascus_dict_001.xslt', charTable_damasc, defaultFields);
    getText('DAMASCUS DICTIONARY', 'dictFrontPage_Damascus', 'vicavTexts.xslt');
}

function openDict_Damascus() {
    createNewDictQueryPanel('dc_apc_eng_publ', 'Damascus Dictionary Query', '_damascus', 'damascus_dict_001.xslt', charTable_damasc, defaultFields);
    //getText('DAMASCUS DICTIONARY', 'dictFrontPage_Damascus', 'vicavTexts.xslt');
}

function openDictFront_Tunis() {
    //createNewDictQueryPanel('dc_tunico', 'TUNICO Dictionary Query', '_tunis', 'tunis_dict_001.xslt', charTable_tunis, defaultFields);
    getText('TUNICO DICTIONARY', 'dictFrontPage_Tunis', 'vicavTexts.xslt');
}

function openDict_Tunis() {
    createNewDictQueryPanel('dc_tunico', 'TUNICO Dictionary Query', '_tunis', 'tunis_dict_001.xslt', charTable_tunis, defaultFields);
    //getText('TUNICO DICTIONARY', 'dictFrontPage_Tunis', 'vicavTexts.xslt');
}

function openDictFront_Baghdad() {
    //createNewDictQueryPanel('dc_acm_baghdad_eng_publ', 'Baghdad Dictionary Query', '_baghdad', 'baghdad_dict_001.xslt', charTable_baghdad, baghdadFields);
    getText('BAGHDAD DICTIONARY', 'dictFrontPage_Baghdad', 'vicavTexts.xslt');
}

function openDict_Baghdad() {
    createNewDictQueryPanel('dc_acm_baghdad_eng_publ', 'Baghdad Dictionary Query', '_baghdad', 'baghdad_dict_001.xslt', charTable_baghdad, baghdadFields);
    //getText('BAGHDAD DICTIONARY', 'dictFrontPage_Baghdad', 'vicavTexts.xslt');
}

function openDictFront_Cairo() {
    //createNewDictQueryPanel('dc_arz_eng_publ', 'Cairo Dictionary Query', '_cairo', 'cairo_dict_001.xslt', charTable_cairo, defaultFields);
    getText('CAIRO DICTIONARY', 'dictFrontPage_Cairo', 'vicavTexts.xslt');
}

function openDict_Cairo() {
    createNewDictQueryPanel('dc_arz_eng_publ', 'Cairo Dictionary Query', '_cairo', 'cairo_dict_001.xslt', charTable_cairo, defaultFields);
    //getText('CAIRO DICTIONARY', 'dictFrontPage_Cairo', 'vicavTexts.xslt');
}

function openDictFront_MSA() {
    //createNewDictQueryPanel('dc_ar_en_publ', 'MSA Dictionary Query', '_MSA', 'fusha_dict_001.xslt', charTable_msa, MSAFields);
    getText('MSA DICTIONARY', 'dictFrontPage_MSA', 'vicavTexts.xslt');
}

function openDict_MSA() {
    createNewDictQueryPanel('dc_ar_en_publ', 'MSA Dictionary Query', '_MSA', 'fusha_dict_001.xslt', charTable_msa, MSAFields);
    //getText('MSA DICTIONARY', 'dictFrontPage_MSA', 'vicavTexts.xslt');
}



// Load cached skin.
if (window.localStorage.vicavStyle) {
    $("<style>").append(window.localStorage.vicavStyle).appendTo('head')
}

/*$(document).on('mousedown', '[data-type="vicavTexts"]', function(event) {
    getText($(event.target).text(), $(event.target).attr('data-target'), 'vicavTexts.xslt');    
})
*/

function parseCurrentUrl(curUrl) {
    if (curUrl.includes('#')) {
        var args = curUrl.split('#');

        var args = args[1].split('&');
        // Parse the map
        var mapArg = args[0].split('=');
        if (mapArg[0] == 'map') {
            console.log('mapArg: ' + mapArg);

            //window["insert" + mapArg[1]]();
            $(".sub-nav-map-items .active").removeClass("active");

            pArgs = mapArg[1].replace(/((\[\s*)|(\s*\]))/g, "");
            pArgs = pArgs.split(',');
            //console.log('pArgs[0]: ' + pArgs[0]);
            //console.log('pArgs[1]: ' + pArgs[1]);
            switch (pArgs[1]) {
                case '_vicavDicts_':
                insertVicavDictMarkers();
                break;

                case '_features_':
                insertFeatureMarkers();
                break;

                case '_profiles_':
                //clearMarkerLayers();  
                insertProfileMarkers();
                break;

                case '_samples_':
                insertSampleMarkers();
                break;


                case '_data_':
                insertAllDataMarkers();
                break;

                default:
                //console.log('pArgs[1]: ' + pArgs[2]);

                insertGeoRegMarkers(pArgs[1], pArgs[2]);
            }
            //$("#" + mapArg[1]).addClass("active");
        }

        // Parse the panels
        // console.log('args: ' + args);
        for (var i = 1; i < args.length; i++) {
            setTimeout(function (y) {
                var pArgs = args[y].split('=');

                var pID_ = pArgs[0];
                pArgs = pArgs[1].replace(/((\[\s*)|(\s*\]))/g, "");
                pArgs = pArgs.split(',');
                var queryFunc = pArgs[0];

                if (queryFunc == 'biblQueryLauncher') {
                    var pVisiblity = pArgs[1];
                    createNewQueryBiblioPanel(pID_, pVisiblity, true);
                } else
                if (queryFunc == 'crossFeaturesForm') {
                    var query = pArgs[1];
                    var pVisiblity = pArgs[2];
                    createDisplayExploreDataPanel('feature', query, pID_, pVisiblity, true);
//                    (query, pID_, pVisiblity, true);
                } else
                if (queryFunc == 'crossFeaturesResult') {
                    var query = pArgs[1];
                    var pVisiblity = pArgs[2];
                    createExploreDataResultsPanel('feature', '', query, pID_, pVisiblity, true);
//                    (query, pID_, pVisiblity, true);
                } else

                if (queryFunc == 'crossSamplesForm') {
                    var query = pArgs[1];
                    var pVisiblity = pArgs[2];
                    createDisplayExploreDataPanel('sample', query, pID_, pVisiblity, true);
//                    (query, pID_, pVisiblity, true);
                } else
                if (queryFunc == 'crossSamplesResult') {
                    var query = pArgs[1];
                    var pVisiblity = pArgs[2];
                    createExploreDataResultsPanel('sample', '', query, pID_, pVisiblity, true);
//                    (query, pID_, pVisiblity, true);
                } else

                if (queryFunc == 'dataList') {
                    var query = pArgs[1];
                    var pVisiblity = pArgs[2];
                    var pVisiblity = pArgs[3];
                    getDataList(query, pID_, pVisiblity, true);
                } else

                if (queryFunc == 'biblQuery') {
                    var query = pArgs[1];
                    var pVisiblity = pArgs[2];
                    var pVisiblity = pArgs[3];
                    execBiblQuery(query, pID_, pVisiblity, true);
                } else

                if (queryFunc == 'textQuery') {
                    var snippetID = pArgs[1];
                    var secLabel = pArgs[2];
                    var pVisiblity = pArgs[3];
                    getText(secLabel, snippetID, 'vicavTexts.xslt', pID_, pVisiblity, true);
                } else

                if (queryFunc == 'profileQuery') {
                    var snippetID = pArgs[1];
                    var caption = pArgs[2];
                    var pVisiblity = pArgs[3];
                    getProfile(caption, snippetID, 'profile_01.xslt', pID_, pVisiblity, true);
                } else

                if (queryFunc == 'featureQuery') {
                    var snippetID = pArgs[1];
                    var caption = pArgs[2];
                    var pVisiblity = pArgs[3];
                    getFeatureOfLocation(caption, snippetID, 'features_01.xslt', pID_, pVisiblity, true);
                } else

                if (queryFunc == 'sampleQuery') {
                    var snippetID = pArgs[1];
                    var caption = pArgs[2];
                    var pVisiblity = pArgs[3];
                    getSample(caption, snippetID, 'sampletext_01.xslt', pID_, pVisiblity, true);
                } else

                if (queryFunc == 'crossDictQueryLauncher') {
                    var pVisiblity = pArgs[1];
                    createNewCrossDictQueryPanel(pID_, pVisiblity, true);
                } else

                if (queryFunc == 'dictQuery') {
                    var query = pArgs[1];
                    query = query.replace("-eq-", "=");
                    var dict = pArgs[2];
                    var pVisiblity = pArgs[3];

                    if (dict == 'dc_tunico') {
                        createNewDictQueryPanel('dc_tunico', 'TUNICO Dictionary Query', '_tunis', 'tunis_dict_001.xslt', charTable_tunis, pID_, pVisiblity, true);
                        query = './dict_api?query=' + query + '&dict=dc_tunico&xslt=tunis_dict_001.xslt';
                        execDictQuery_ajax(query, '_tunis');
                    }
                }
            },
            200 * i, i);
        }
    } else {
    }   
}

$(document).ready(
function () {
    $("#dvMainMapCont").show();
    //insertGeoRegMarkers('', 'geo');

    // Parse the given url parameters for views
    var currentURL = decodeURI(window.location.toString());
    console.log('reload: currentUrl: ' + currentURL);

    $.ajax({
        url: "project",
        dataType: "xml",
        success: function( xmlResponse ) {
            $( "project", xmlResponse ).map(function() {
                $('head > title').text( $( "projectConfig > title", this ).text() )

                let icon = $( "projectConfig > icon", this ).text()
                if (icon != '') {
                    L.Icon.Default.prototype.options.iconUrl = icon;
                }

                $('a.navbar-brand').html( $( "projectConfig > logo", this ).html() )
                let zoom = $( "projectConfig > map > zoom", this ).text();
                let center = [$( "projectConfig > map > center > lat", this ).text(), $( "projectConfig > map > center > lng", this ).text()];
                
                if (zoom !== '' && center[0] !== '' && center[1] !== '')
                mainMap.setView(center, zoom);

                $('#navbarsExampleDefault').html( $( "renderedMenu menu > main", this ).html() )  
                $('.sub-nav-map-items').html($("renderedMenu menu subnav", this).html())

                if ($( "projectConfig > style", this ).text()) {
                    window.localStorage.vicavStyle = $( "projectConfig > style", this ).text()
                    let style = $("<style>").append(window.localStorage.vicavStyle)
                    style.appendTo('head')
                }

                if (!currentURL.includes('#')) {
                     let params = $( "projectConfig > frontpage > param", this).map((i, item) => {
                        return $(item).text()
                    })
                    switch($( "projectConfig > frontpage", this).attr('method')) {
                        case 'samples': 
                            insertSampleMarkers();
                            break;
                        case 'geo':
                        default:
                         if (params.length == 0) params = ['.*', 'geo']
                            insertGeoRegMarkers(params[0], params[1]);
                            updateUrl_biblMarker(params[0], params[1])
                            break 
                    }

                    $( "projectConfig > frontpage panel", this).each((i, item) => {
                        var menuItem = $(item).text();
                        getText(menuItem, $(item).attr('target'), 'vicavTexts.xslt');
                    })


        // console.log('replaceState (6)');
        // &1=[textQuery,vicavMission,MISSION,open]&2=[textQuery,vicavNews,NEWS,open]");

                }
            })
        }
    });

    parseCurrentUrl(currentURL);


    $(document).on('mousedown', "button", function (event) {
        //console.log('Click');
        //alert('Line 1465');
    });

    $(document).on('click', 'a[href*=".jpg"]', function (event) {
        event.preventDefault();
        event.stopPropagation();
        var options = { index: event.target, event: event }
        var links = $(event.target).parent().parent().children('a[href*=".jpg"]')
        blueimp.Gallery(links, options)
    });

    $(document).on('DOMNodeInserted', ".content-panel .grid-wrap", function(event) {
        $('.gallery-item img', event.target).each((_i, i) => {
            i.onload = function(){
                if (this.naturalWidth > this.naturalHeight) {
                    $(this).addClass('landscape');

                    $(this).attr('style', $(this).attr('style') + 'margin-left: -' + this.width / 4 + 'px;');
                    if ($(this).attr('style') !== undefined) {
                        $(this).attr('style', $(this).attr('style') + '; margin-left: -' + this.width / 4 + 'px;');
                    } else {
                        $(this).attr('style', 'margin-left: -' + this.width / 4 + 'px;');
                    }
                }
                if (this.naturalWidth < this.naturalHeight) {
                    $(this).addClass('portrait');
                }
            }
        })

        
    });


    /**
     * HANLING AUDIO PLAYER
     */
    // This extra function is needed because audio control events do not bubble
    // in jQuery for some reason.
    jQuery.createEventCapturing = (function () {
        var special = jQuery.event.special;
        return function (names) {
            if (!document.addEventListener) {
                return;
            }
            if (typeof names == 'string') {
                names = [names];
            }
            jQuery.each(names, function (i, name) {
                var handler = function (e) {
                    e = jQuery.event.fix(e);

                    return jQuery.event.dispatch.call(this, e);
                };
                special[name] = special[name] || {};
                if (special[name].setup || special[name].teardown) {
                    return;
                }
                jQuery.extend(special[name], {
                    setup: function () {
                        this.addEventListener(name, handler, true);
                    },
                    teardown: function () {
                        this.removeEventListener(name, handler, true);
                    }
                });
            });
        };
    })();

    jQuery.createEventCapturing(['play', 'ended', 'pause'])

    $(document).on('play', 'audio', function(e) {
        e.target.classList.add('playing')
        $('audio').each((_a2, a2) => {
            if (a2 !== e.target) {
                a2.pause()
                a2.classList.remove('playing')
                makeAudioInVisible($(a2).parent())
            }
        })
    })

     $(document).on('pause', 'audio', function(e) {
        e.target.classList.remove('playing')
    })

     $(document).on('ended', 'audio', function(e) {
        e.target.classList.remove('playing')
    })


    /* *************************** */
    /* ****  Explanations  ******* */
    /* *************************** */
    /*$(document).on('mousedown', "#liBibliographyExplanation", function (event) {
        createBiblExplanationPanel();
    });
    */

    /* This is needed to collapse the menu after click in small screens */
    $('.navbar-nav li a').on('click', function () {
        if (! $(this).hasClass('dropdown-toggle')) {
            $('.navbar-collapse').collapse('hide');
        }
    });

    $(document).on('mousedown', "#liBiblNewQuery", function (event) { createNewQueryBiblioPanel();});    
    $(document).on('mousedown', "#liVicavCrossDictQuery", function (event) { createNewCrossDictQueryPanel(); });

    /* ******************************** */
    /* ****  DICTIONARY QUERIES ******* */
    /* ******************************** */
    $(document).on("click", '#liVicavDict_Tunis', function () { openDictFront_Tunis(); });
    $(document).on("click", '#liVicavDict_Damascus', function () { openDictFront_Damascus(); });
    $(document).on("click", '#liVicavDict_Baghdad', function () { openDictFront_Baghdad(); });
    $(document).on("click", '#liVicavDict_Cairo', function () { openDictFront_Cairo(); });
    $(document).on("click", '#liVicavDict_MSA', function () { openDictFront_MSA(); });

    /* ********************************************* */
    /* ****  DICTIONARY Auto Complete Events ******* */
    /* ********************************************* */
    $(document).on("keyup", '.inpDictQuery_tunis', function (event) {
        dealWithDictQueryKeyInput(event, '_tunis');
    });
    $(document).on("keyup", '.inpDictQuery_damascus', function (event) {
        dealWithDictQueryKeyInput(event, '_damascus');
    });
    $(document).on("keyup", '.inpDictQuery_baghdad', function (event) {
        dealWithDictQueryKeyInput(event, '_baghdad');
    });
    $(document).on("keyup", '.inpDictQuery_cairo', function (event) {
        dealWithDictQueryKeyInput(event, '_cairo');
    });
    $(document).on("keyup", '.inpDictQuery_MSA', function (event) {
        dealWithDictQueryKeyInput(event, '_MSA');
    });

    /* ******************************** */
    /* ****  PROFILES ***************** */
    /* ******************************** */

    $(document).on('mousedown', "[id^=li_]", function (event) {
        var sid = $(this).attr('id');
        sid = sid.substring(3);
        var sCaption = getCaptionFromMenuID(sid);
        console.log('mouseDown - sid: ' + sid + '   sCaption: ' + sCaption);
        getText(sCaption, sid, 'vicavTexts.xslt');
    });

    /* **************************************** */
    /* ****  Show map with locators *********** */
    /* **************************************** */
    $(document).on('mousedown', "#navBiblGeoMarkers,#subNavBiblGeoMarkers", 
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('.*', 'geo');
        adjustNav(this.id, "#subNavBiblGeoMarkers");
    });

    $(document).on('mousedown', "#navBiblRegMarkers,#subNavBiblRegMarkers", 
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('.*', 'reg');
        adjustNav(this.id, "#subNavBiblRegMarkers");
    });

    $(document).on('mousedown', "#navBiblDiaGroupMarkers,#subNavBiblRegMarkers",
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('.*', 'diaGroup');
        adjustNav(this.id, "#subNavBiblRegMarkers");
    });

    $(document).on('mousedown', "#navDictGeoRegMarkers,#subNavDictGeoRegMarkers,#navDictGeoRegMarkers1",
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('vt:dictionary', 'geo_reg');
        adjustNav(this.id, "#subNavDictGeoRegMarkers");
    });

    $(document).on('mousedown', "#navTextbookGeoRegMarkers,#subNavTextbookGeoRegMarkers", 
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('vt:textbook', 'geo_reg');
        adjustNav(this.id, "#subNavTextbookGeoRegMarkers");
    });

    $(document).on('mousedown', "#navProfilesGeoRegMarkers,#subNavProfilesGeoRegMarkers", function (event) {        
        //clearMarkerLayers();	
        insertProfileMarkers();
        adjustNav(this.id, "#subNavProfilesGeoRegMarkers");
    });

    $(document).on('mousedown', "#navFeaturesGeoRegMarkers,#subNavFeaturesGeoRegMarkers", function (event) {        
        insertFeatureMarkers();
        adjustNav(this.id, "#subNavFeaturesGeoRegMarkers");
    });

    $(document).on('mousedown', "#navSamplesGeoRegMarkers,#subNavSamplesGeoRegMarkers", function (event) {
        clearMarkerLayers();
        insertSampleMarkers();
        adjustNav(this.id, "#subNavSamplesGeoRegMarkers");
    });

    $(document).on('mousedown', "#navDataGeoRegMarkers,#subNavDataGeoRegMarkers", function (event) {
        clearMarkerLayers();
            insertAllDataMarkers();
            console.log(this.id)
        adjustNav(this.id, "#subNavDataGeoRegMarkers");
    });

    $(document).on('mousedown', "#navVicavDictMarkers,#subNavVicavDictMarkers", function (event) {
        clearMarkerLayers();
        insertVicavDictMarkers();
        adjustNav(this.id, "#subNavVicavDictMarkers");
    });

    /* ********************** */
    /* ****  SAMPLES ******** */
    /* ********************** */

    // @todo Needs refactoring as a lot of samples are coming.

    $(document).on('mousedown', "#liSampleCairo", function (event) {
        getSample('Cairo', 'cairo_sample_01', 'sampletext_01.xslt');
    });
    $(document).on('mousedown', "#liSampleBaghdad", function (event) {
        getSample('Baghdad', 'baghdad_sample_01', 'sampletext_01.xslt');
    });
    $(document).on('mousedown', "#liSampleDamascus", function (event) {
        getSample('Damascus', 'damascus_sample_01', 'sampletext_01.xslt');
    });
    $(document).on('mousedown', "#liSampleUrfa", function (event) {
        getSample('Urfa', 'urfa_sample_01', 'sampletext_01.xslt');
    });
    $(document).on('mousedown', "#liSampleTunis", function (event) {
        getSample('Tunis', 'tunis_sample_01', 'sampletext_01.xslt');
    });
    $(document).on('mousedown', "#liSampleDouz", function (event) {
        getSample('Souz', 'douz_sample_01', 'sampletext_01.xslt');
    });
    $(document).on('mousedown', "#liSampleMSA", function (event) {
        getSample('Modern Standard Arabic', 'msa_sample_01', 'sampletext_01.xslt');
    });

    $(document).on('mousedown', "#liFeaturesList", function (event) {
        getDataList('lingfeatures')
    });

    $(document).on('mousedown', "#liSamplesList", function (event) {
        getDataList('samples')
    });

    $(document).on('mousedown', "#liProfilesList", function (event) {
        getDataList('profiles')
    });

    $(document).on('mousedown', "#liDataListAll", function (event) {
        getDataList('')
    });
    
    /* ******************************** */
    /* ****  CORPUS ******************* */
    /* ******************************** */
    //$(document).on("click", '#liTextCukurova_001', function(){ getSample('Cukurova', 'cukurova_001', 'sampletext_01.xslt'); });
    //$(document).on("click", '#liTextJakal_001', function(){ getSample('Morocco', 'killing_jackal', 'sampletext_01.xslt'); });



    /* *******************************************************/
    /* ***********PANEL BEHAVIOR *****************************/
    /* *******************************************************/
    $(document).on("click", '.chrome-minimize', function () {
        if ($(this).parents(':eq(1)').hasClass('open-panel')) {
            var panel = $(this).parents(':eq(1)');
            changePanelVisibility(panel, 'minimize');
        } else if ($(this).parents(':eq(1)').hasClass('closed-panel')) {
            var panel = $(this).parents(':eq(1)');
            changePanelVisibility(panel, 'maximize');
        }
    });

    $(document).on("click", '.chrome-expand', function () {
        var panel = $(this).parents(':eq(1)');
        $('.content-panel').each(function() {
          var currentPanel = $(this);
          currentPanel.removeClass('expanded-panel');
          changePanelVisibility(currentPanel, 'minimize');
        });
        changePanelVisibility(panel, 'maximize', true);
        panel.addClass('expanded-panel');
    });

    /* *******************************************************/
    /* ********* WORD SELECTOR *******************************/
    /* *******************************************************/

    /* TODO: replace this with jquery-ui autocomplete to use html instead of select */
    $("[id^=id_opt]").click ( function (event) { });

    $(document).on("keyup", '[id^=slWordSelect]',
    function (event) {
        suf = getSuffixID($(this).attr('id'));

        inpID = '#inpDictQuery_' + suf;
        sh = $("#slWordSelector_" + suf + " option:selected").text();
        sh = sh.trim().replace(/[\[\]]/g, '');
        $(inpID).val(sh);
        console.log('keyup: ' + sh);
    });

    $(document).on("keydown", '[id^=slWordSelect]',
    function (event) {
        suf = getSuffixID($(this).attr('id'));
        inpID = 'inpDictQuery_' + suf;

        if (event.which == 13) {
            sh = $("#slWordSelector_" + suf + " option:selected").text();
            sh = sh.trim().replace(/[\[\]]/g, '');
            sh = sh.replace(/\[/g, '');
            sh = sh.replace(/\]/g, '');

            $('#' + inpID).val(sh);
            $('#' + inpID).focus();
            $('#dvWordSelector_' + suf).hide();
        } else if (event.which == 27) {
            /* Key: ESCAPE */
            $("#dvWordSelector_" + suf).hide();
            $('#' + inpID).focus();
        } else if (event.which == 38) {
            /* Key: Up */
            if (document.getElementById("slWordSelector_" + sids[1]).selectedIndex == 0) {
                $("#slWordSelector_" + suf + " option:first").removeAttr('selected');
                $('#' + inpID).focus();
            }
        }
    });

    $(document).on("click", '[id^=slWordSelect]', function () {
        var selectedVal = $(this).val();
        selectedVal = selectedVal.trim().replace(/[\[\]]/g, '');
        var idSuffix = $(this).attr('id').split('_');
        var idSuffix = idSuffix[1];
        $('#inpDictQuery_' + idSuffix).val(selectedVal);
    });

    $(document).on('mousedown', '.grid-wrap', function () {
        var click_panel = $(this).parents('.content-panel');
        var click_panel_id = $(click_panel).data('pid');
        globalPreservePanel = click_panel_id;
    });

    /* ***************************/
    /* Query Bibliography Button */
    /* ***************************/
    $('.search-button').on('click', function () {
        createNewQueryBiblioPanel();
    });

    /* *******************************************************/
    /* ********* CHAR-TABLE **********************************/
    /* *******************************************************/

    $(document).on("mousedown", '[id^=ct]',
    function (event) {
        suf = getSuffixID($(this).attr('id'));
        inpID = 'inpDictQuery_' + suf;
        var inputEl = $('#' + inpID);
        var s1 = inputEl.val();
        var s2 = $(this).text();
        var cursorPosition = inputEl[0].selectionStart;
        inputEl.val(s1.substring(0, cursorPosition) + s2 + s1.substring(cursorPosition));
        document.getElementById(inpID).selectionStart = cursorPosition + 1;
        document.getElementById(inpID).selectionEnd = cursorPosition + 1;
        var sq = $("#" + inpID).val();
        collName = $("#" + inpID).attr('dict');
        debounceFillWordSelector(fillWordSelector, 500, false, [sq, collName + '__ind', '_' + suf]);
        setTimeout(function() {
            $("#" + inpID).focus();
        },
        0);
    });

    $(document).on("mouseover", '[id^=ct]',
    function (event) {
        $(this).css('cursor', 'pointer');
    });

    $(document).on("mouseout", '[id^=ct]',
    function (event) {
        $(this).css('cursor', 'auto');
    });


    /* *******************************************************/
    /* ** Close Panel ****************************************/
    /* *******************************************************/
    $(document).on("click", '.chrome-close', function () {
        var panel = $(this).parents(':eq(1)');
        changePanelVisibility(panel, 'close');
    });

    $(document).on("click", '.grid-wrap', function () {
        $(this).find('.dvWordSelector').hide();
    });


    /* ********************************************************/
    /* **** Copy cite content *********************************/
    /* ********************************************************/
    $(document).on("click", '#sub-nav-share', function () {
        var URLtoCopy = window.location.toString();
        var result = copyToClipboard(URLtoCopy);
        if (result) {
            $('#sub-nav-share-confirmation').fadeIn(100);
            setTimeout(function () {
                $('#sub-nav-share-confirmation').fadeOut(200);
            }, 2000);
        }
    });

    /* *******************************************************/
    /* ****Query Bibliography Button Action  *****************/
    /* *******************************************************/
    $(document).on("click", '.biblQueryBtn', function () {
        query = $(this).prev().val()
        if (query.length > 0) {
            if (document.getElementById("cbAsText").checked == true) {
                execBiblQuery(query);
            }

            if (document.getElementById("cbAsMap").checked == true) {

                clearMarkerLayers();
                insertGeoRegMarkers(query, 'geo_reg');
                //adjustNav(this.id, "#subNavBiblGeoMarkers");
            }
        } else {
            alert('Query string is empty.');
        }
    });

    /* *******************************************************/
    /* ****Cross Dict Query Button Action    *****************/
    /* *******************************************************/
    $(document).on("click", '.crossDictQueryBtn', function () {

        query = $(this).prev().val()
        if (query.length > 0) {
            sField = 'any';

            if (document.getElementById("cbIntegratedResult").checked == true) {
                var sDicts = '';
                if (document.getElementById("cbDamascus").checked == true) { sDicts = 'dc_apc_eng_publ';}
                if (document.getElementById("cbTunis").checked == true) { if (sDicts.length > 0) { sDicts = sDicts + ',dc_tunico'; } else { sDicts = 'dc_tunico' }}
                if (document.getElementById("cbCairo").checked == true) { if (sDicts.length > 0) { sDicts = sDicts + ',dc_arz_eng_publ'; } else { sDicts = 'dc_arz_eng_publ' }}
                if (document.getElementById("cbBaghdad").checked == true) { if (sDicts.length > 0) { sDicts = sDicts + ',dc_acm_baghdad_eng_publ'; } else { sDicts = 'dc_acm_baghdad_eng_publ' }}
                if (document.getElementById("cbMSA").checked == true) { if (sDicts.length > 0) { sDicts = sDicts + ',dc_ar_en_publ'; } else { sDicts = 'dc_ar_en_publ' }}

                execCrossDictQuery(sDicts, query);

            } else {
                if (document.getElementById("cbDamascus").checked == true) {
                    autoDictQuery('_damascus', query, sField);
                }

                if (document.getElementById("cbTunis").checked == true) {
                    autoDictQuery('_tunis', query, sField);
                }

                if (document.getElementById("cbCairo").checked == true) {
                    autoDictQuery('_cairo', query, sField);
                }

                if (document.getElementById("cbBaghdad").checked == true) {
                    autoDictQuery('_baghdad', query, sField);
                }

                if (document.getElementById("cbMSA").checked == true) {
                    autoDictQuery('_MSA', query, sField);
                }

            }

        } else {
            alert('Query string is empty.');
        }
    });

    /* *******************************************************/
    /* ****Query Dictionary Button Action  *******************/
    /* *******************************************************/
    $(document).on("click", '[id^=dictQuerybtn]', function () {
        suf = getSuffixID($(this).attr('id'));
        $("#imgPleaseWait" + suf).css('visibility', 'visible');
        $("#loading-wrapper" + suf).css('visibility', 'visible');
        execDictQuery('_' + suf);
    });

    /* *******************************************************/
    /* **** Expand Panels Over Map ***************************/
    /* *******************************************************/
    $('#sub-nav-expand').on('click', function () {
        if (! $(this).hasClass('panels-expanded')) {
            $('.panels-wrap').addClass('panels-wrap-expanded');
            $(this).addClass('panels-expanded');
            $(this).html('<i class="fa fa-compress" aria-hidden="true"></i> Minimize Panels Below Map');
        } else {
            $(this).removeClass('panels-expanded');
            $('.panels-wrap').removeClass('panels-wrap-expanded');
            $(this).html('<i class="fa fa-expand" aria-hidden="true"></i> Expand Panels Over Map');
        }
    });


    /* *******************************************************/
    /* **** Close All Panels Over Map ************************/
    /* *******************************************************/
    $('#sub-nav-close').on('click', function () {
        $('.content-panel:not(.initial-closed-panel)').each(function (i, obj) {
            changePanelVisibility($(this), 'close');
        });
    });

    $("body").tooltip({
        selector: '[data-toggle="tooltip"]',
        trigger: 'hover focus'
    });
});


function getFlashCards(unit_, dict_, format_) {
    uri = 'https://cs.acdh-dev.oeaw.ac.at/modules/fcs-aggregator/switch.php?version=1.2&operation=searchRetrieve&query=unit=' +
    unit_ + '&x-context=' + dict_ + '&startRecord=1&maximumRecords=1000&x-format=' + format_ + '&x-dataview=kwic,title';
    window.location.href = uri;
}

function refEvent(url_) {
    if (url_.indexOf("biblid") > -1) {
        execBiblQuery(url_);
    } else if (url_.indexOf("vt:") > -1) {
        execBiblQuery(url_);
    } else if (url_.indexOf("reg:") > -1) {
        execBiblQuery(url_);
    } else if (url_.indexOf("geo:") > -1) {
        execBiblQuery(url_);
    } else if (url_.indexOf("tax:") > -1) {
        execBiblQuery(url_);
    } else if (url_.indexOf("sampleText") > -1) {
        execSampleQuery(url_);
    } else {
        var win = window.open(url_, '_blank');
        win.focus();
    }
}

function copyToClipboard(text) {
    if (window.clipboardData && window.clipboardData.setData) {
        // IE specific code path to prevent textarea being shown while dialog is visible.
        return clipboardData.setData("Text", text);
    } else if (document.queryCommandSupported && document.queryCommandSupported("copy")) {
        var textarea = document.createElement("textarea");
        textarea.textContent = text;
        textarea.style.position = "fixed";
        // Prevent scrolling to bottom of page in MS Edge.
        document.body.appendChild(textarea);
        textarea.select();
        try {
            return document.execCommand("copy");
            // Security exception may be thrown by some browsers.
        }
        catch (ex) {
            console.warn("Copy to clipboard failed.", ex);
            return false;
        }
        finally {
            document.body.removeChild(textarea);
        }
    }
}

/** COOKIES **/
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

//Cookies warning first page
var cookiesAccepted = getCookie("cookiesAccepted");
if (!cookiesAccepted) {
    $("#cookie-overlay").fadeIn(100);
}

//Accept cookies
$(".cookie-accept-btn").on('click', function(){
    setCookie("cookiesAccepted", true, 180);
    $("#cookie-overlay").fadeOut(100);
});

/** COOKIES END **/
