/* ******************************************** */
/* Create geodata with http://www.latlong.net/ */
/* ******************************************** */
/* Return data looks like this:
/* ********************************************
<r type="geo">
<loc>30.04, 31.23</loc>
<alt>Cairo</alt>
<kw>vt:Dictionary</kw>
<freq>8</freq>
</r>
 */

function convertDMSToDD(degrees, minutes, seconds, direction) {
    var dd = parseInt(degrees) + parseInt(minutes)/60 + parseInt(seconds)/(60*60);

    if (direction == "S" || direction == "W") {
        dd = dd * -1;
    } // Don't do anything for N or E
    return dd;
}

function coordToDD(co_) {
    sdir = '';
    if (co_.indexOf('W') !== -1) { sdir = 'W'; co_ = co_.replace(/′W/g, ""); }
    if (co_.indexOf('N') !== -1) { sdir = 'N'; co_ = co_.replace(/′N/g, ""); }
    if (co_.indexOf('S') !== -1) { sdir = 'S'; co_ = co_.replace(/′S/g, ""); }
    if (co_.indexOf('E') !== -1) { sdir = 'E'; co_ = co_.replace(/′E/g, ""); }
    s1 = co_.split("°");
    //console.log(s);
    //console.log("   " + s1[0] + ' # ' + s1[1] + ' # ' + sdir);
    return convertDMSToDD(s1[0], s1[1], 0, sdir);
}

function splitCoords(s_, loc_) {
   var mem = s_;
   if (s_.indexOf("N ") == 0) { s_ = "N" + s_.substring(2); }
   if (s_.indexOf("S ") == 0) { s_ = "S" + s_.substring(2); }
   s_ = s_.replace(/"/g, '″');
   s_ = s_.replace(/'/g, '′');
   s_ = s_.replace(/′/g, '′');
   s_ = s_.replace(/′ /g, '′');
   s_ = s_.replace(/″ /g, '″');
   s_ = s_.replace(/° /g, '°');
   s_ = s_.replace(/E/g, ' E');
   s_ = s_.replace(/W/g, ' W');
   s_ = s_.replace(/,/g, ', ');
   s_ = s_.replace(/  /g, ' ');
   s_ = s_.replace(/  /g, ' ');
   s_ = s_.replace(/E /g, 'E');
   s_ = s_.replace(/W /g, 'W');
   s_ = s_.replace(/′ W$/g, '′W');
   s_ = s_.replace(/′ E$/g, '′E');
   s_ = s_.replace(/″ W$/g, '″W');
   s_ = s_.replace(/″ E$/g, '″E');
   s_ = s_.replace(/ ,/g, ',');

   var latlng = s_.split(' ');
   if (latlng.length !== 2) {
     //console.log(s_);
     console.log('Can not deal with ' + mem + ', ' + loc_ + '   (pos: splitCoords)');
   } else {
     latlng[0] = latlng[0].replace(/,/g, "");
     latlng[1] = latlng[1].replace(/,/g, "");
   }
   //return rs;

   let lat = latlng[0];
   let lng = latlng[1];
   return { lat, lng };
}

function parseStringToDMS(s_) {
   let deg = -1;
   let min = -1;
   let sec = -1;
   let dir = 'noDir';

   s_ = s_.replace(/°/g, ' ');
   s_ = s_.replace(/′/g, ' ');
   s_ = s_.replace(/″/g, ' ');
   if (s_.indexOf('N') !== -1) { dir = 'N' }
   if (s_.indexOf('S') !== -1) { dir = 'S' }
   if (s_.indexOf('W') !== -1) { dir = 'W' }
   if (s_.indexOf('E') !== -1) { dir = 'E' }

   s_ = s_.replace(/S/, '');
   s_ = s_.replace(/N/, '');
   s_ = s_.replace(/W/, '');
   s_ = s_.replace(/E/, '');
   s_ = s_.trim();

   dms = s_.split(' ');
   if (dms.length > 0) { deg = dms[0] }
   if (dms.length > 1) { min = dms[1] }
   if (dms.length > 2) { sec = dms[2] }

   return { deg, min, sec, dir };
}

function normalizeLocCoord(s_) {
    //              
    s_ = s_.replace(/°/g, ".");
    s_ = s_.replace(/′N/g, ",");
    s_ = s_.replace(/′E/g, "");
    if (s_.indexOf('′W') !== -1) {
        s_ = s_.replace(/ /g, " -");
        s_ = s_.replace(/′W/g, "");
    }

    return s_;
}

function parseCoords(coords_) {
    if (coords_.indexOf(',') !== -1) {
        return coords_.split(",");
    } else {
        return coords_.split(" ");
    }
}

function insertVicavDictMarkers() {
    setExplanation('Dictionaries');
    
    fgDictMarkers.addLayer(L.marker([30.05, 31.23], { alt: 'Cairo', id: 'dict_cairo'  }).bindTooltip('Cairo'));
    fgDictMarkers.addLayer(L.marker([33.51, 36.29], { alt: 'Damascus', id: 'dict_damascus' }).bindTooltip('Damascus'));
    fgDictMarkers.addLayer(L.marker([36.8, 10.18], {  alt: 'Tunis', id: 'dict_tunis' }).bindTooltip('Tunis'));
    fgDictMarkers.addLayer(L.marker([33.33, 44.38], { alt: 'Baghdad', id: 'dict_baghdad' }).bindTooltip('Baghdad'));
    
    updateUrl_biblMarker('_vicavDicts_', '');
}

function insertFeatureMarkers() {
    /* ******************************** */
    /* Create with loc_features__001.xq */
    /* ******************************** */
    clearMarkerLayers();
    
    setExplanation('Features');
    /* fgFeatureMarkers.addLayer(L.marker([30.05, 31.23], {  alt: 'Cairo', id: 'ling_features_cairo' }).bindTooltip('Cairo'));
    fgFeatureMarkers.addLayer(L.marker([33.51, 36.29], {  alt: 'Damascus', id: 'ling_features_damascus' }).bindTooltip('Damascus'));
    fgFeatureMarkers.addLayer(L.marker([36.8, 10.18], {  alt: 'Tunis', id: 'ling_features_tunis' }).bindTooltip('Tunis'));
    fgFeatureMarkers.addLayer(L.marker([37.15, 38.79], { alt: 'Şanlıurfa', id: 'ling_features_urfa'  }).bindTooltip('Şanlıurfa'));
    fgFeatureMarkers.addLayer(L.marker([33.45, 9.01], { alt: 'Douz', id: 'ling_features_douz' }).bindTooltip('Douz'));
    fgFeatureMarkers.addLayer(L.marker([33.33, 44.38], {alt: 'Baghdad', id: 'ling_features_baghdad'}).bindTooltip('Baghdad'));
    clearMarkerLayers(); */
    $.ajax({
        url: 'feature_markers',
        type: 'GET',
        dataType: 'xml',
        contentType: 'application/html; charset=utf-8',
        success: function (result) {
            s = '';
            cnt = 0;
            $(result).find('r').each(function (index) {
                cnt = cnt + 1;
                sLoc = $(this).find('loc').text();
                sAlt = $(this).find('alt').text();
                //sLocName = $(this).find('locName').text();
                sID = $(this).attr('xml:id');
                
                /*
                console.log(sLoc);

                let sCnt = sID.replace(/^[\w-]+_?0?/, '')
                if (sCnt && parseInt(sCnt) > 1) {
                    sAlt = sAlt + ' (' + sCnt + ')'
                }

                sCoords = parseCoords(sLoc)
                sCoordNS = trim(normalizeLocCoord(sCoords[0]));
                console.log(sCoordNS);
                sCoordWE = trim(normalizeLocCoord(sCoords[1]));
                console.log(sCoordWE);
                dd1 = coordToDD(sCoordNS)
                dd2 = coordToDD(sCoordWE);
                r1 = dd1.toFixed(2);
                r2 = dd2.toFixed(2);                             
                */


                //sQuery = 'profile:' + sTooltip + '';
                //marker = L.marker([v1, v2], { alt: sAlt, title: sAlt, id: sID, type: 'feature' }).bindTooltip(sTooltip);
                var coord = splitCoords(sLoc, sAlt);
                //console.log('(' + coord.lat + ') (' + coord.lng + ')');

                var dmslat = parseStringToDMS(coord.lat);
                var declat = convertDMSToDD(dmslat.deg, dmslat.min, dmslat.sec, dmslat.dir)

                var dmslng = parseStringToDMS(coord.lng);
                var declng = convertDMSToDD(dmslng.deg, dmslng.min, dmslng.sec, dmslng.dir)

                marker = L.marker([declat, declng], { alt: sAlt, id: sID, type: 'feature' }).bindTooltip(sAlt);
                fgFeatureMarkers.addLayer(marker);
                //oms.addMarker(marker);
            });
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 199' + errorThrown);
        }
    });
    
    updateUrl_biblMarker('_features_', '');
}

function insertSampleMarkers() {
    clearMarkerLayers();
    $.ajax({
        url: 'sample_markers',
        type: 'GET',
        dataType: 'xml',
        contentType: 'application/html; charset=utf-8',
        success: function (result) {
            $(result).find('r').each(function (index) {
                sLoc = $(this).find('loc').text();
                sAlt = $(this).find('alt').text();
                sID = $(this).attr('xml:id');

                /*
                sCoords = loc.split(" ");
                sCoordNS = sCoords[0];
                sCoordWE = sCoords[1];
                dd1 = coordToDD(sCoordNS)
                dd2 = coordToDD(sCoordWE);
                r1 = dd1.toFixed(2);
                r2 = dd2.toFixed(2);
                */
                var coord = splitCoords(sLoc, sAlt);
                //console.log('(' + coord.lat + ') (' + coord.lng + ')');

                var dmslat = parseStringToDMS(coord.lat);
                var declat = convertDMSToDD(dmslat.deg, dmslat.min, dmslat.sec, dmslat.dir)

                var dmslng = parseStringToDMS(coord.lng);
                var declng = convertDMSToDD(dmslng.deg, dmslng.min, dmslng.sec, dmslng.dir)

                marker = L.marker([declat, declng], { alt: sAlt, id: sID, type: 'sample' }).bindTooltip(sAlt);
                fgSampleMarkers.addLayer(marker);                
            });
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 242' + errorThrown);
        }
    });
        
    updateUrl_biblMarker('_samples_', '');
}


function insertProfileMarkers() {
    //setExplanation('Profiles');
    /*
    m1 = L.marker([33.51, 36.29], {alt:"Damascus", id: "damascus_01"});
    fg5.addLayer(m1);
    
    m2 = L.marker([34.02, -6.83], {alt:'Salé', id: 'sale_01'});
    fg5.addLayer(m2);
     */
    //console.log('getProfileMarkers');
    clearMarkerLayers();
    $.ajax({
        url: 'profile_markers',
        type: 'GET',
        dataType: 'xml',
        contentType: 'application/html; charset=utf-8',
        success: function (result) {
            cnt = 0;
            $(result).find('r').each(function (index) {
                cnt = cnt + 1;
                //console.log(sUrl);
                sLoc = $(this).find('loc').text();
                sType = $(this).attr('type');
                sAlt = $(this).find('alt').text();
                sID = $(this).attr('xml:id');

                /*
                sCoords = sLoc.split(" ");
                sCoordNS = trim(sCoords[0]);
                sCoordWE = trim(sCoords[1]);
                console.log(sCoordNS + ' ' + sCoordWE);
                dd1 = coordToDD(sCoordNS);
                dd2 = coordToDD(sCoordWE);
                console.log(dd1 + ' ' + dd2);
                r1 = dd1.toFixed(2);
                r2 = dd2.toFixed(2); 

                console.log(r1 + ' # ' + r2 + ' # ' + sLoc + ' :: ' + sCoordNS + ' # ' + sCoordWE +' # ' + sAlt + ' (' + sID +')');
                //console.log(s + ' # ' + sAlt);
                //console.log(s[0] + ' # ' + s[1] + ' # ' + sAlt);
                //console.log(dd1 + '  ' + sAlt);
                //console.log(cnt + ':  ' + r1 + '  ' + sAlt + ' : ' + sID);

                //sTooltip = sAlt;
                //sQuery = 'profile:' + sAlt + '';
                //fgProfileMarkers.addLayer(L.marker([v1, v2], { alt: sAlt, id: sID }).bindTooltip(sTooltip));
                */

                /******************************************************/
                /** NEW ***********************************************/
                /******************************************************/
                var coord = splitCoords(sLoc, sAlt);
                //console.log(sAlt + ' (' + coord.lat + ') (' + coord.lng + ')');

                var dmslat = parseStringToDMS(coord.lat);
                var declat = convertDMSToDD(dmslat.deg, dmslat.min, dmslat.sec, dmslat.dir)

                var dmslng = parseStringToDMS(coord.lng);
                var declng = convertDMSToDD(dmslng.deg, dmslng.min, dmslng.sec, dmslng.dir)

                console.log('(' + declat + ') (' + declng + ')' + sAlt + ': ' + sType);
                if ((sType == 'tribe')||(sType == 'region')) {
                   marker = L.circle([declat, declng], { color: 'rgb(168, 93, 143)', weight: 1, fillColor: 'rgb(168, 93, 143)', radius: 90000, alt: sAlt, id: sID, type:'profile'  }).bindTooltip(sAlt);                  
                } else {
                   marker = L.marker([declat, declng], { alt: sAlt, id: sID, type:'profile' }).bindTooltip(sAlt);
                }
                fgProfileMarkers.addLayer(marker);
                
            });
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 321' + errorThrown);
        }
    });
    
    updateUrl_biblMarker('_profiles_', '');
    
    /* ******************************** */
    /* Create with geo_profiles_txt__002.xq */
    /* ******************************** */
    
    /* fgProfileMarkers.addLayer(L.marker([33.51, 36.29], {alt:'Damascus', id:'profile_damascus_01'}).bindTooltip('Damascus'));
    fgProfileMarkers.addLayer(L.marker([30.05, 31.23], {alt:'Cairo', id:'profile_cairo_01'}).bindTooltip('Cairo'));
    fgProfileMarkers.addLayer(L.marker([36.80, 10.18], {alt:'Tunis', id:'profile_tunis_01'}).bindTooltip('Tunis'));
    fgProfileMarkers.addLayer(L.marker([34.02, -6.83], {alt:'Salé', id:'profile_sale_01'}).bindTooltip('Salé'));
    fgProfileMarkers.addLayer(L.marker([23.96, 57.09], {alt:'al-Khaburah', id:'profile_khabura_01'}).bindTooltip('al-Khaburah'));
    fgProfileMarkers.addLayer(L.marker([33.45, 9.01], {alt:'Douz', id:'profile_douz_01'}).bindTooltip('Douz'));
    fgProfileMarkers.addLayer(L.marker([35.82, 10.64], {alt:'Sousse', id:'profile_sousse_001'}).bindTooltip('Sousse'));
    fgProfileMarkers.addLayer(L.marker([37.15, 38.79], {alt:'Şanlıurfa', id:'profile_urfa_01'}).bindTooltip('Şanlıurfa'));
    fgProfileMarkers.addLayer(L.marker([33.33, 44.38], {alt:'Baghdad', id:'profile_baghdad_01'}).bindTooltip('Baghdad'));
     */
}

/* function insertBiblRegMarkers() {
setExplanation('Identified Regions');
/* ******************************** */
/* Create with create_reg_markers__001.xq */
/* ********************************

fgBiblMarkers.addLayer(L.circle([31.46, -6.39], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Morocco', locType:'region', biblQuery:'reg:Morocco'}).bindTooltip('Morocco (913)'));
fgBiblMarkers.addLayer(L.circle([32.93, 36.53], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syro-Palestine', locType:'region', biblQuery:'reg:Syro-Palestine'}).bindTooltip('Syro-Palestine (319)'));
fgBiblMarkers.addLayer(L.circle([31.26, 36.15], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Jordan', locType:'region', biblQuery:'reg:Jordan'}).bindTooltip('Jordan (55)'));
fgBiblMarkers.addLayer(L.circle([27.39, 30.26], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Egypt', locType:'region', biblQuery:'reg:Egypt'}).bindTooltip('Egypt (263)'));
fgBiblMarkers.addLayer(L.circle([31.53, 34.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Israel', locType:'region', biblQuery:'reg:Israel'}).bindTooltip('Israel (114)'));
fgBiblMarkers.addLayer(L.circle([31.89, 35.25], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Palestine', locType:'region', biblQuery:'reg:Palestine'}).bindTooltip('Palestine (93)'));
fgBiblMarkers.addLayer(L.circle([22.36, 46.81], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Arabian Peninsula', locType:'region', biblQuery:'reg:Arabian Peninsula'}).bindTooltip('Arabian Peninsula (186)'));
fgBiblMarkers.addLayer(L.circle([29.25, 47.88], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Kuweit', locType:'region', biblQuery:'reg:Kuweit'}).bindTooltip('Kuweit (8)'));
fgBiblMarkers.addLayer(L.circle([30.40, 50.60], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iran', locType:'region', biblQuery:'reg:Iran'}).bindTooltip('Iran (8)'));
fgBiblMarkers.addLayer(L.circle([35.14, 42.48], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mesopotamia', locType:'region', biblQuery:'reg:Mesopotamia'}).bindTooltip('Mesopotamia (165)'));
fgBiblMarkers.addLayer(L.circle([21.40, 57.76], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Oman', locType:'region', biblQuery:'reg:Oman'}).bindTooltip('Oman (14)'));
fgBiblMarkers.addLayer(L.circle([16.31, 47.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Yemen', locType:'region', biblQuery:'reg:Yemen'}).bindTooltip('Yemen (89)'));
fgBiblMarkers.addLayer(L.circle([33.71, 35.66], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Lebanon', locType:'region', biblQuery:'reg:Lebanon'}).bindTooltip('Lebanon (51)'));
fgBiblMarkers.addLayer(L.circle([39.92, -3.02], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Spain', locType:'region', biblQuery:'reg:Spain'}).bindTooltip('Spain (2)'));
fgBiblMarkers.addLayer(L.circle([16.14, 30.29], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Sudan', locType:'region', biblQuery:'reg:Sudan'}).bindTooltip('Sudan (35)'));
fgBiblMarkers.addLayer(L.circle([40.26, 65.35], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Uzbekistan', locType:'region', biblQuery:'reg:Uzbekistan'}).bindTooltip('Uzbekistan (10)'));
fgBiblMarkers.addLayer(L.circle([39.92, -3.02], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Andalusia', locType:'region', biblQuery:'reg:Andalusia'}).bindTooltip('Andalusia (91)'));
fgBiblMarkers.addLayer(L.circle([28.79, 18.04], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Libya', locType:'region', biblQuery:'reg:Libya'}).bindTooltip('Libya (33)'));
fgBiblMarkers.addLayer(L.circle([34.61, 38.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syria', locType:'region', biblQuery:'reg:Syria'}).bindTooltip('Syria (107)'));
fgBiblMarkers.addLayer(L.circle([31.64, 45.33], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iraq', locType:'region', biblQuery:'reg:Iraq'}).bindTooltip('Iraq (91)'));
fgBiblMarkers.addLayer(L.circle([33.59, 9.37], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Tunisia', locType:'region', biblQuery:'reg:Tunisia'}).bindTooltip('Tunisia (133)'));
fgBiblMarkers.addLayer(L.circle([11.12, 12.24], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Nigeria', locType:'region', biblQuery:'reg:Nigeria'}).bindTooltip('Nigeria (10)'));
fgBiblMarkers.addLayer(L.circle([34.54, 3.30], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Algeria', locType:'region', biblQuery:'reg:Algeria'}).bindTooltip('Algeria (92)'));
fgBiblMarkers.addLayer(L.circle([19.45, -13.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mauritania', locType:'region', biblQuery:'reg:Mauritania'}).bindTooltip('Mauritania (33)'));
fgBiblMarkers.addLayer(L.circle([38.08, 41.10], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Turkey', locType:'region', biblQuery:'reg:Turkey'}).bindTooltip('Turkey (74)'));
fgBiblMarkers.addLayer(L.circle([35.87, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Malta', locType:'region', biblQuery:'reg:Malta'}).bindTooltip('Malta (25)'));
fgBiblMarkers.addLayer(L.circle([22.95, 46.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Saudi Arabia', locType:'region', biblQuery:'reg:Saudi Arabia'}).bindTooltip('Saudi Arabia (33)'));
fgBiblMarkers.addLayer(L.circle([25.25, 51.18], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Qatar', locType:'region', biblQuery:'reg:Qatar'}).bindTooltip('Qatar (6)'));
fgBiblMarkers.addLayer(L.circle([26.57, 49.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Gulf', locType:'region', biblQuery:'reg:Gulf'}).bindTooltip('Gulf (27)'));
fgBiblMarkers.addLayer(L.circle([33.66, 66.14], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Afghanistan', locType:'region', biblQuery:'reg:Afghanistan'}).bindTooltip('Afghanistan (4)'));
fgBiblMarkers.addLayer(L.circle([11.30, 17.86], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Chad', locType:'region', biblQuery:'reg:Chad'}).bindTooltip('Chad (14)'));
fgBiblMarkers.addLayer(L.circle([37.62, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Sicily', locType:'region', biblQuery:'reg:Sicily'}).bindTooltip('Sicily (12)'));
fgBiblMarkers.addLayer(L.circle([26.00, 50.57], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Bahrain', locType:'region', biblQuery:'reg:Bahrain'}).bindTooltip('Bahrain (5)'));
fgBiblMarkers.addLayer(L.circle([21.40, 57.76], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Oman', locType:'region', biblQuery:'reg:Oman'}).bindTooltip('Oman (1)'));

}
 */

/* function insertBiblGeoMarkers() {
setExplanation('Identified Locations');
/* ************************************** */
/* Create with create_geo_markers__001.xq */
/* **************************************

fgBiblMarkers.addLayer(L.marker([31.94, 35.92], {alt:'Amman', biblQuery:'geo:Amman', locType:'point'}).bindTooltip('Amman (4)'));
fgBiblMarkers.addLayer(L.marker([35.75, -5.83], {alt:'Tanger', biblQuery:'geo:Tanger', locType:'point'}).bindTooltip('Tanger (17)'));

}
 */

function insertGeoRegMarkers(query_, scope_) {
    /* *************************************************** */
    /* * Function to directly retrieve data from BaseX *** */
    /* *************************************************** */
    //example: insertGeoRegMarkers('', 'geo_reg');
    //example (rest): sUrl = 'bibl_markers_tei?query=none&scope=geo';
	//http://localhost:8984/vicav/bibl_markers_tei?query=vt:textbook,reg:Egypt&scope=geo_reg
    //for experimenting in BaseX Client: vicav_bibl_markers
    
    if (query_ == '') { query_ = '.*'; }
	//console.log('query_: ' + query_);
	//console.log('scope_: ' + scope_);
    $(".sub-nav-map-items .active").removeClass("active");
    query_ = query_.replace(/&/g, '+');
    query_ = query_.replace(/ \+/g, '+');
    query_ = query_.replace(/\+ /g, '+');
    query_ = query_.replace(/\+/g, '%2b');
    sUrl = 'bibl_markers_tei?query=' + query_ + '&scope=' + scope_;
    /*sQuerySecPart = ',vt:textbook';*/
    var sQuerySecPart = '';
    if (query_ != '') {
        sQuerySecPart = ',' + query_;
    }
    if (query_ == '') { query_ = '.*'; }
    
    console.log('sUrl: ' + sUrl);
    console.log('query_: ' + query_);
    console.log('sQuerySecPart: ' +  sQuerySecPart);
    clearMarkerLayers();
    $.ajax({
        url: sUrl,
        type: 'GET',
        dataType: 'xml',
        contentType: 'application/html; charset=utf-8',
        success: function (result) {
            s = '';
            cnt = 0;
            
            $(result).find('r').each(function (index) {
                cnt = cnt + 1;
                //console.log(cnt);

                loc = $(this).find('geo').text();
                sAlt = $(this).find('alt').text();
                sFreq = $(this).find('freq').text();
                values = loc.split(" ");
                v1 = parseFloat(values[0]);
                v2 = parseFloat(values[1]);
                sTooltip = sAlt + ' (' + sFreq + ')';
                //console.log(sTooltip);
                
                if ($(this).attr('type') == 'geo') {
                    sQuery = 'geo:' + sAlt + sQuerySecPart;
                    var marker = L.marker([v1, v2], { alt: sAlt, locType: 'point', biblQuery: sQuery }).bindTooltip(sTooltip);
                    fgBiblMarkers.addLayer(marker);
                    $(marker._icon).attr('data-testid', 'geo_'+sAlt);
                }

                if ($(this).attr('type') == 'reg') {
                    sQuery = 'reg:' + sAlt + sQuerySecPart;
                    var circle = L.circle([v1, v2], { color: 'rgb(168, 93, 143)', weight: 1, fillColor: 'rgb(168, 93, 143)', radius: 90000, alt: sAlt, biblQuery: sQuery }).bindTooltip(sTooltip);
                    fgBiblMarkers.addLayer(circle);
                    $(circle._path).attr('data-testid', 'reg_'+sAlt);
                }

                if ($(this).attr('type') == 'diaGroup') {
                    sQuery = 'reg:' + sAlt + sQuerySecPart;
                    //var circle = L.circle([v1, v2], { color: 'rgb(22, 93, 143)', weight: 2, fillColor: 'rgb(22, 93, 143)', radius: 190000, alt: sAlt, biblQuery: sQuery }).bindTooltip(sTooltip);

                    var sh = sTooltip.substr(0, sTooltip.indexOf('('));
                    sh = sh.trim();
                    console.log('sTooltip: ' + sTooltip + '   sh: ' + sh);
                    if (sh == 'Maghreb') {
                       var bounds = [[v1 - 4, v2 - 14], [v1 + 4, v2 + 8]];
                       var ico1 = L.divIcon({ className: "labelClass", html: "<div class='labelClassMaghreb1' style='letter-spacing: 0.1em;color:#d5b1c9;font-size:30px'>MAGHREB</div>" });
                       var ico2 = L.divIcon({ className: "labelClass", html: "<div style='letter-spacing: 0.1em;color:#d5b1c9;font-size:30px'>MAGHREB</div>" });
                       var l1 = L.marker([32.5, -5.5], {icon:ico1, alt: sAlt, biblQuery: sQuery}).addTo(layerGroupDialectRegions);
                       var l2 = L.marker([28.5, 8.5], {icon:ico2, alt: sAlt, biblQuery: sQuery}).addTo(layerGroupDialectRegions);
                       l1.bindTooltip(sTooltip);
                       l2.bindTooltip(sTooltip);
                       fgBiblMarkers.addLayer(l1);
                       fgBiblMarkers.addLayer(l2);
                    } else 
                    if (sh == 'Egypt-Sudan') {
                       var bounds = [[v1 - 8, v2 - 5], [v1 + 8, v2 + 5]];
                       var ico = L.divIcon({ className: "labelClass", html: "<div style='color:#8485b5;font-size:30px'>EGYPT-<br/>SUDAN</div>" });
                       var l = L.marker([25.5, 25.5], {icon:ico, alt: sAlt, biblQuery: sQuery}).addTo(layerGroupDialectRegions);
                       l.bindTooltip(sTooltip);
                       fgBiblMarkers.addLayer(l);
                    } else 
                    if (sh == 'Mesopotamia') {
                       var ico = L.divIcon({ className: "labelClass", html: "<div class='labelClass45' style='color:#c5a6c8;font-size:20px'>MESOPOTAMIA</div>" });
                       var l = L.marker([40.5, 39.5], {icon:ico, alt: sAlt, biblQuery: sQuery}).addTo(layerGroupDialectRegions);
                       l.bindTooltip(sTooltip);
                       fgBiblMarkers.addLayer(l);
                    } else
                    if (sh == 'Syro-Palestine') {
                       var ico = L.divIcon({ className: "labelClass", html: "<div class='labelClassLevant' style='color:#98a2ca;font-size:25px'>Levant</div>" }); 
                       var l = L.marker([32.5, 35.5], {icon:ico, alt: sAlt, biblQuery: sQuery}).addTo(layerGroupDialectRegions);
                       l.bindTooltip(sTooltip);
                       fgBiblMarkers.addLayer(l);
                    } else
                    if (sh == 'Gulf') {
                       var ico = L.divIcon({ className: "labelClass", html: "<div class='labelClassGulf' style='color:#c8c7e8;font-size:22px'>Gulf</div>" });
                       var l = L.marker([27.5, 48.5], {icon:ico, alt: sAlt, biblQuery: sQuery}).addTo(layerGroupDialectRegions);
                       l.bindTooltip(sTooltip);
                       fgBiblMarkers.addLayer(l);
                    } 
                    
                    //var rect = L.rectangle(bounds, {color: "#ff7800", weight: 1, alt: sAlt, biblQuery: sQuery}).bindTooltip(sTooltip);
                    
                    //var ico_Maghreb_01 = L.divIcon({ className: "labelClass", html: "<div class='labelClass20' style='letter-spacing: 0.1em;color:red;font-size:30px'>MAGHREB</div>" });
                    //var l = L.marker([32.5, -5.5], {icon:ico, alt: sAlt, biblQuery: sQuery}).addTo(layerGroupDialectRegions);
                    //l.bindTooltip(sTooltip);
                    //console.log('tooltip: ' + sTooltip);
                    /*
                    var ico_Maghreb_02 = L.divIcon({ className: "labelClass", html: "<div style='color:red;font-size:30px'>MAGHREB</div>" });
                    var ico_Egypt = L.divIcon({ className: "labelClass", html: "<div style='color:blue;font-size:30px'>EGYPT-<br/>SUDAN</div>" });
                    var ico_Mesopotamia = L.divIcon({ className: "labelClass", html: "<div class='labelClass45' style='color:green;font-size:20px'>MESOPOTAMIA</div>" });
                    var ico_Levant = L.divIcon({ className: "labelClass", html: "<div  style='color:yellow;font-size:20px'>Levant</div>" });
                    var ico_Arabia = L.divIcon({ className: "labelClass", html: "<div class='labelArabia'  style='color:orange;font-size:20px'>ARABIAN PENINSULA</div>" });
                    var l = L.marker([32.5, -5.5], {icon:ico_Maghreb_01}).addTo(layerGroupDialectRegions);
                    var l = L.marker([30.5, 16.5], {icon:ico_Maghreb_02}).addTo(layerGroupDialectRegions);
                    var l = L.marker([25.5, 25.5], {icon:ico_Egypt}).addTo(layerGroupDialectRegions);
                    var l = L.marker([40.5, 39.5], {icon:ico_Mesopotamia}).addTo(layerGroupDialectRegions);
                    var l = L.marker([33.5, 35.5], {icon:ico_Levant}).addTo(layerGroupDialectRegions);
                    var l = L.marker([29.5, 38.5], {icon:ico_Arabia}).addTo(layerGroupDialectRegions);
                    */

                    //fgBiblMarkers.addLayer(rect);
                    //fgBiblMarkers.addLayer(l);
                    //$(circle._path).attr('data-testid', 'reg_'+sAlt);
                }

            }
            );

        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert('Line 471' + errorThrown);
        }
    });
    
    //console.log('query_(2): ' + query_);
    updateUrl_biblMarker(query_, scope_);
}

/* function insertGeoTextbookMarkers() {
setExplanation('Textbooks');
/* ******************************** */
/* Create with create_geo_reg_textbooks_markers__001.xq */
/* ******************************** */
/*
fgBiblMarkers.addLayer(L.circle([31.46, -6.39], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Morocco', biblQuery:'reg:Morocco,vt:Textbook'}).bindTooltip('Morocco (31)'));
fgBiblMarkers.addLayer(L.circle([27.39, 30.26], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Egypt', biblQuery:'reg:Egypt,vt:Textbook'}).bindTooltip('Egypt (21)'));
fgBiblMarkers.addLayer(L.marker([30.04, 31.23], {alt:'Cairo', locType:'point', biblQuery:'geo:Cairo,vt:Textbook'}).bindTooltip('Cairo (17)'));
fgBiblMarkers.addLayer(L.circle([22.36, 46.81], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Arabian Peninsula', biblQuery:'reg:Arabian Peninsula,vt:Textbook'}).bindTooltip('Arabian Peninsula (7)'));
fgBiblMarkers.addLayer(L.circle([16.31, 47.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Yemen', biblQuery:'reg:Yemen,vt:Textbook'}).bindTooltip('Yemen (4)'));
fgBiblMarkers.addLayer(L.marker([15.36, 44.19], {alt:'Sanaa', locType:'point', biblQuery:'geo:Sanaa,vt:Textbook'}).bindTooltip('Sanaa (2)'));
fgBiblMarkers.addLayer(L.circle([34.54, 3.30], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Algeria', biblQuery:'reg:Algeria,vt:Textbook'}).bindTooltip('Algeria (1)'));
fgBiblMarkers.addLayer(L.circle([31.89, 35.25], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Palestine', biblQuery:'reg:Palestine,vt:Textbook'}).bindTooltip('Palestine (6)'));
fgBiblMarkers.addLayer(L.circle([32.93, 36.53], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syro-Palestine', biblQuery:'reg:Syro-Palestine,vt:Textbook'}).bindTooltip('Syro-Palestine (14)'));
fgBiblMarkers.addLayer(L.circle([34.61, 38.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syria', biblQuery:'reg:Syria,vt:Textbook'}).bindTooltip('Syria (8)'));
fgBiblMarkers.addLayer(L.marker([31.76, 35.21], {alt:'Jerusalem', locType:'point', biblQuery:'geo:Jerusalem,vt:Textbook'}).bindTooltip('Jerusalem (3)'));
fgBiblMarkers.addLayer(L.circle([26.57, 49.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Gulf', biblQuery:'reg:Gulf,vt:Textbook'}).bindTooltip('Gulf (3)'));
fgBiblMarkers.addLayer(L.circle([11.30, 17.86], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Chad', biblQuery:'reg:Chad,vt:Textbook'}).bindTooltip('Chad (1)'));
fgBiblMarkers.addLayer(L.circle([31.64, 45.33], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iraq', biblQuery:'reg:Iraq,vt:Textbook'}).bindTooltip('Iraq (2)'));
fgBiblMarkers.addLayer(L.circle([35.14, 42.48], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mesopotamia', biblQuery:'reg:Mesopotamia,vt:Textbook'}).bindTooltip('Mesopotamia (2)'));
fgBiblMarkers.addLayer(L.marker([33.51, 36.27], {alt:'Damascus', locType:'point', biblQuery:'geo:Damascus,vt:Textbook'}).bindTooltip('Damascus (5)'));
fgBiblMarkers.addLayer(L.circle([22.95, 46.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Saudi Arabia', biblQuery:'reg:Saudi Arabia,vt:Textbook'}).bindTooltip('Saudi Arabia (1)'));
fgBiblMarkers.addLayer(L.circle([31.53, 34.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Israel', biblQuery:'reg:Israel,vt:Textbook'}).bindTooltip('Israel (5)'));
fgBiblMarkers.addLayer(L.marker([12.78, 45.01], {alt:'Aden', locType:'point', biblQuery:'geo:Aden,vt:Textbook'}).bindTooltip('Aden (1)'));
fgBiblMarkers.addLayer(L.circle([16.14, 30.29], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Sudan', biblQuery:'reg:Sudan,vt:Textbook'}).bindTooltip('Sudan (1)'));
fgBiblMarkers.addLayer(L.circle([28.79, 18.04], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Libya', biblQuery:'reg:Libya,vt:Textbook'}).bindTooltip('Libya (1)'));
fgBiblMarkers.addLayer(L.circle([35.87, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Malta', biblQuery:'reg:Malta,vt:Textbook'}).bindTooltip('Malta (1)'));

}
 */

/*
function insertGeoDictMarkers() {

/* *********************************** */
/* create_geo_reg_dict_markers__004.xq */
/* ***********************************
setExplanation('Dictionaries');

/*var myIcon = L.icon({
iconUrl: 'images/marker-circle.png',
iconSize: [41, 41],
iconAnchor: [20, 20],
popupAnchor: [0, 0],
shadowUrl: 'images/marker-circle-shadow.png',
shadowSize: [41, 41],
shadowAnchor: [10, 10]
});
 */
//fgBiblMarkers.addLayer(L.circle([32.04, 34.23], { color: 'red', fillColor: '#f03', fillOpacity: 0.5, radius: 50000})).bindTooltip('Cairo', {permanent:true, direction: "center", className: "labelTooltip", offset: [0, 0]});
//fgBiblMarkers.addLayer(L.rectangle([[32.04, 34.23], [34.04, 37.23]], { color: 'red', fillColor: '#f03', fillOpacity: 0.5}))
//fgBiblMarkers.addLayer(L.rectangle([[32.04, 34.23], [34.04, 37.23]], { color: 'red', fillColor: '#f03', fillOpacity: 0.5}).bindTooltip('Cairo', {permanent:false, direction: "center", className: "labelTooltip1", offset: [0, 0]}));
/*
fgBiblMarkers.addLayer(L.circle([39.92, -3.02], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Andalusia', biblQuery:'reg:Andalusia,vt:Dictionary'}).bindTooltip('Andalusia (3)'));
fgBiblMarkers.addLayer(L.marker([33.82, -4.83], {alt:'Sefrou', locType:'point', biblQuery:'geo:Sefrou,vt:Dictionary'}).bindTooltip('Sefrou (1)'));
fgBiblMarkers.addLayer(L.marker([33.97, -6.84], {alt:'Rabat', locType:'point', biblQuery:'geo:Rabat,vt:Dictionary'}).bindTooltip('Rabat (1)'));
fgBiblMarkers.addLayer(L.circle([27.39, 30.26], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Egypt', biblQuery:'reg:Egypt,vt:Dictionary'}).bindTooltip('Egypt (6)'));
fgBiblMarkers.addLayer(L.marker([35.75, -5.83], {alt:'Tanger', locType:'point', biblQuery:'geo:Tanger,vt:Dictionary'}).bindTooltip('Tanger (1)'));
fgBiblMarkers.addLayer(L.circle([19.45, -13.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mauritania', biblQuery:'reg:Mauritania,vt:Dictionary'}).bindTooltip('Mauritania (1)'));
fgBiblMarkers.addLayer(L.circle([32.93, 36.53], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syro-Palestine', biblQuery:'reg:Syro-Palestine,vt:Dictionary'}).bindTooltip('Syro-Palestine (5)'));
fgBiblMarkers.addLayer(L.marker([33.51, 36.27], {alt:'Damascus', locType:'point', biblQuery:'geo:Damascus,vt:Dictionary'}).bindTooltip('Damascus (4)'));
fgBiblMarkers.addLayer(L.circle([34.61, 38.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syria', biblQuery:'reg:Syria,vt:Dictionary'}).bindTooltip('Syria (4)'));
fgBiblMarkers.addLayer(L.marker([36.20, 37.13], {alt:'Aleppo', locType:'point', biblQuery:'geo:Aleppo,vt:Dictionary'}).bindTooltip('Aleppo (3)'));
fgBiblMarkers.addLayer(L.circle([11.30, 17.86], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Chad', biblQuery:'reg:Chad,vt:Dictionary'}).bindTooltip('Chad (1)'));
fgBiblMarkers.addLayer(L.circle([22.36, 46.81], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Arabian Peninsula', biblQuery:'reg:Arabian Peninsula,vt:Dictionary'}).bindTooltip('Arabian Peninsula (5)'));
fgBiblMarkers.addLayer(L.circle([16.31, 47.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Yemen', biblQuery:'reg:Yemen,vt:Dictionary'}).bindTooltip('Yemen (4)'));
fgBiblMarkers.addLayer(L.circle([26.57, 49.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Gulf', biblQuery:'reg:Gulf,vt:Dictionary'}).bindTooltip('Gulf (1)'));
fgBiblMarkers.addLayer(L.circle([33.59, 9.37], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Tunisia', biblQuery:'reg:Tunisia,vt:Dictionary'}).bindTooltip('Tunisia (2)'));
fgBiblMarkers.addLayer(L.circle([35.87, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Malta', biblQuery:'reg:Malta,vt:Dictionary'}).bindTooltip('Malta (2)'));
fgBiblMarkers.addLayer(L.circle([11.12, 12.24], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Nigeria', biblQuery:'reg:Nigeria,vt:Dictionary'}).bindTooltip('Nigeria (4)'));
fgBiblMarkers.addLayer(L.marker([31.62, -7.98], {alt:'Marrakesh', locType:'point', biblQuery:'geo:Marrakesh,vt:Dictionary'}).bindTooltip('Marrakesh (1)'));
fgBiblMarkers.addLayer(L.circle([31.53, 34.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Israel', biblQuery:'reg:Israel,vt:Dictionary'}).bindTooltip('Israel (2)'));
fgBiblMarkers.addLayer(L.circle([31.89, 35.25], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Palestine', biblQuery:'reg:Palestine,vt:Dictionary'}).bindTooltip('Palestine (3)'));
fgBiblMarkers.addLayer(L.circle([33.71, 35.66], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Lebanon', biblQuery:'reg:Lebanon,vt:Dictionary'}).bindTooltip('Lebanon (2)'));
fgBiblMarkers.addLayer(L.marker([31.76, 35.21], {alt:'Jerusalem', locType:'point', biblQuery:'geo:Jerusalem,vt:Dictionary'}).bindTooltip('Jerusalem (2)'));
fgBiblMarkers.addLayer(L.circle([31.64, 45.33], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iraq', biblQuery:'reg:Iraq,vt:Dictionary'}).bindTooltip('Iraq (3)'));
fgBiblMarkers.addLayer(L.circle([35.14, 42.48], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mesopotamia', biblQuery:'reg:Mesopotamia,vt:Dictionary'}).bindTooltip('Mesopotamia (3)'));
fgBiblMarkers.addLayer(L.marker([33.46, 9.02], {alt:'Douz', locType:'point', biblQuery:'geo:Douz,vt:Dictionary'}).bindTooltip('Douz (1)'));
}
 */
