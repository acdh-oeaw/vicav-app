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

function insertVicavDictMarkers() {
    setExplanation('Dictionaries');   

    fgDictMarkers.addLayer(L.marker([30.05, 31.23], {alt:'Cairo', id:'dict_cairo'}).bindTooltip('Cairo'));
    fgDictMarkers.addLayer(L.marker([33.51, 36.29], {alt:'Damascus', id:'dict_damascus'}).bindTooltip('Damascus'));
    fgDictMarkers.addLayer(L.marker([36.8, 10.18], {alt:'Tunis', id:'dict_tunis'}).bindTooltip('Tunis'));
}

function insertFeatureMarkers() {
    /* ******************************** */
    /* Create with loc_features__001.xq */
    /* ******************************** */

    setExplanation('Features');   
    /* 
    fgFeatureMarkers.addLayer(L.marker([30.05, 31.23], {alt:'Cairo', id:'ling_features_cairo'}));
    fgFeatureMarkers.addLayer(L.marker([33.51, 36.29], {alt:'Damascus', id:'ling_features_damascus'}));
    */
    fgFeatureMarkers.addLayer(L.marker([30.05, 31.23], {alt:'Cairo', id:'ling_features_cairo'}).bindTooltip('Cairo'));
    fgFeatureMarkers.addLayer(L.marker([33.51, 36.29], {alt:'Damascus', id:'ling_features_damascus'}).bindTooltip('Damascus'));
    fgFeatureMarkers.addLayer(L.marker([36.8, 10.18], {alt:'Tunis', id:'ling_features_tunis'}).bindTooltip('Tunis'));
    fgFeatureMarkers.addLayer(L.marker([37.15, 38.79], {alt:'Şanlıurfa', id:'ling_features_urfa'}).bindTooltip('Şanlıurfa'));
    fgFeatureMarkers.addLayer(L.marker([33.45, 9.01], {alt:'Douz', id:'ling_features_douz'}).bindTooltip('Douz'));
    fgFeatureMarkers.addLayer(L.marker([33.33, 44.38], {alt:'Baghdad', id:'ling_features_baghdad'}).bindTooltip('Baghdad'));    
}

function insertSampleMarkers() {
    /* ******************************** */
    /* Create with geo_samples_txt__001.xq */
    /* ******************************** */
/* 
    setExplanation('Samples');   
    fgSampleMarkers.addLayer(L.marker([33.51, 36.29], {alt:'Damascus'}).bindTooltip('Damascus'));
    fgSampleMarkers.addLayer(L.marker([30.05, 31.23], {alt:'Cairo'}).bindTooltip('Cairo'));
    fgSampleMarkers.addLayer(L.marker([33.33, 44.38], {alt:'Baghdad'}).bindTooltip('Baghdad'));
    fgSampleMarkers.addLayer(L.marker([37.15, 38.79], {alt:'Şanlıurfa'}).bindTooltip('Şanlıurfa'));
    fgSampleMarkers.addLayer(L.marker([36.80, 10.18], {alt:'Tunis'}).bindTooltip('Tunis'));
    fgSampleMarkers.addLayer(L.marker([33.45, 9.01], {alt:'Douz'}).bindTooltip('Douz'));
 */
    fgSampleMarkers.addLayer(L.marker([33.51, 36.29], {alt:'Damascus', id:'damascus_sample_01'}).bindTooltip('Damascus'));
    fgSampleMarkers.addLayer(L.marker([30.05, 31.23], {alt:'Cairo', id:'cairo_sample_01'}).bindTooltip('Cairo'));
    fgSampleMarkers.addLayer(L.marker([33.33, 44.38], {alt:'Baghdad', id:'baghdad_sample_01'}).bindTooltip('Baghdad'));
    fgSampleMarkers.addLayer(L.marker([37.15, 38.79], {alt:'Şanlıurfa', id:'urfa_sample_01'}).bindTooltip('Şanlıurfa'));
    fgSampleMarkers.addLayer(L.marker([36.8, 10.18], {alt:'Tunis', id:'tunis_sample_01'}).bindTooltip('Tunis'));
    fgSampleMarkers.addLayer(L.marker([33.45, 9.01], {alt:'Douz', id:'douz_sample_01'}).bindTooltip('Douz'));

}

function insertProfileMarkers() {
    setExplanation('Profiles');
    /* 
    m1 = L.marker([33.51, 36.29], {alt:"Damascus", id: "damascus_01"});  
    fg5.addLayer(m1);
    
    m2 = L.marker([34.02, -6.83], {alt:'Salé', id: 'sale_01'});
    fg5.addLayer(m2);
     */

    /* ******************************** */
    /* Create with geo_profiles_txt__002.xq */
    /* ******************************** */   
          
    fgProfileMarkers.addLayer(L.marker([33.51, 36.29], {alt:'Damascus', id:'profile_damascus_01'}).bindTooltip('Damascus'));
    fgProfileMarkers.addLayer(L.marker([30.05, 31.23], {alt:'Cairo', id:'profile_cairo_01'}).bindTooltip('Cairo'));
    fgProfileMarkers.addLayer(L.marker([36.80, 10.18], {alt:'Tunis', id:'profile_tunis_01'}).bindTooltip('Tunis'));
    fgProfileMarkers.addLayer(L.marker([34.02, -6.83], {alt:'Salé', id:'profile_sale_01'}).bindTooltip('Salé'));
    fgProfileMarkers.addLayer(L.marker([23.96, 57.09], {alt:'al-Khaburah', id:'profile_khabura_01'}).bindTooltip('al-Khaburah'));
    fgProfileMarkers.addLayer(L.marker([33.45, 9.01], {alt:'Douz', id:'profile_douz_01'}).bindTooltip('Douz'));
    fgProfileMarkers.addLayer(L.marker([35.82, 10.64], {alt:'Sousse', id:'profile_sousse_001'}).bindTooltip('Sousse'));
    fgProfileMarkers.addLayer(L.marker([37.15, 38.79], {alt:'Şanlıurfa', id:'profile_urfa_01'}).bindTooltip('Şanlıurfa'));
    fgProfileMarkers.addLayer(L.marker([33.33, 44.38], {alt:'Baghdad', id:'profile_baghdad_01'}).bindTooltip('Baghdad'));
    
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
    fgBiblMarkers.addLayer(L.marker([29.69, -9.73], {alt:'Tiznit', biblQuery:'geo:Tiznit', locType:'point'}).bindTooltip('Tiznit (1)'));
    fgBiblMarkers.addLayer(L.marker([25.51, 29.16], {alt:'Dakhla', biblQuery:'geo:Dakhla', locType:'point'}).bindTooltip('Dakhla (4)'));
    fgBiblMarkers.addLayer(L.marker([25.55, 29.26], {alt:'Balat', biblQuery:'geo:Balat', locType:'point'}).bindTooltip('Balat (1)'));
    fgBiblMarkers.addLayer(L.marker([30.04, 31.23], {alt:'Cairo', biblQuery:'geo:Cairo', locType:'point'}).bindTooltip('Cairo (92)'));
    fgBiblMarkers.addLayer(L.marker([15.36, 44.19], {alt:'Sanaa', biblQuery:'geo:Sanaa', locType:'point'}).bindTooltip('Sanaa (16)'));
    fgBiblMarkers.addLayer(L.marker([31.20, 29.91], {alt:'Alexandria', biblQuery:'geo:Alexandria', locType:'point'}).bindTooltip('Alexandria (2)'));
    fgBiblMarkers.addLayer(L.marker([35.58, -5.36], {alt:'Tétouan', biblQuery:'geo:Tétouan', locType:'point'}).bindTooltip('Tétouan (9)'));
    fgBiblMarkers.addLayer(L.marker([41.64, -0.88], {alt:'Zaragoza', biblQuery:'geo:Zaragoza', locType:'point'}).bindTooltip('Zaragoza (1)'));
    fgBiblMarkers.addLayer(L.marker([34.78, -5.70], {alt:'Masmouda', biblQuery:'geo:Masmouda', locType:'point'}).bindTooltip('Masmouda (1)'));
    fgBiblMarkers.addLayer(L.marker([35.76, -5.66], {alt:'Anjra', biblQuery:'geo:Anjra', locType:'point'}).bindTooltip('Anjra (7)'));
    fgBiblMarkers.addLayer(L.marker([30.39, -9.60], {alt:'Oued Drâa', biblQuery:'geo:Oued Drâa', locType:'point'}).bindTooltip('Oued Drâa (1)'));
    fgBiblMarkers.addLayer(L.marker([37.17, -3.59], {alt:'Granada', biblQuery:'geo:Granada', locType:'point'}).bindTooltip('Granada (7)'));
    fgBiblMarkers.addLayer(L.marker([14.56, 44.34], {alt:'Yafa', biblQuery:'geo:Yafa', locType:'point'}).bindTooltip('Yafa (9)'));
    fgBiblMarkers.addLayer(L.marker([13.70, 44.73], {alt:'Dhale', biblQuery:'geo:Dhale', locType:'point'}).bindTooltip('Dhale (1)'));
    fgBiblMarkers.addLayer(L.marker([39.76, 64.45], {alt:'Bukhara', biblQuery:'geo:Bukhara', locType:'point'}).bindTooltip('Bukhara (4)'));
    fgBiblMarkers.addLayer(L.marker([36.80, 10.18], {alt:'Tunis', biblQuery:'geo:Tunis', locType:'point'}).bindTooltip('Tunis (27)'));
    fgBiblMarkers.addLayer(L.marker([35.82, 10.60], {alt:'Sousse', biblQuery:'geo:Sousse', locType:'point'}).bindTooltip('Sousse (8)'));
    fgBiblMarkers.addLayer(L.marker([38.68, 41.69], {alt:'Hasköy', biblQuery:'geo:Hasköy', locType:'point'}).bindTooltip('Hasköy (6)'));
    fgBiblMarkers.addLayer(L.marker([32.88, 13.19], {alt:'Tripoli', biblQuery:'geo:Tripoli', locType:'point'}).bindTooltip('Tripoli (9)'));
    fgBiblMarkers.addLayer(L.marker([33.88, 10.09], {alt:'Gabès', biblQuery:'geo:Gabès', locType:'point'}).bindTooltip('Gabès (1)'));
    fgBiblMarkers.addLayer(L.marker([36.19, 36.16], {alt:'Antakya', biblQuery:'geo:Antakya', locType:'point'}).bindTooltip('Antakya (3)'));
    fgBiblMarkers.addLayer(L.marker([33.83, -4.83], {alt:'Sefrou', biblQuery:'geo:Sefrou', locType:'point'}).bindTooltip('Sefrou (3)'));
    fgBiblMarkers.addLayer(L.marker([41.67, 26.55], {alt:'Edirne', biblQuery:'geo:Edirne', locType:'point'}).bindTooltip('Edirne (1)'));
    fgBiblMarkers.addLayer(L.marker([29.20, 25.51], {alt:'Siwa', biblQuery:'geo:Siwa', locType:'point'}).bindTooltip('Siwa (1)'));
    fgBiblMarkers.addLayer(L.marker([36.87, 3.93], {alt:'Dellys', biblQuery:'geo:Dellys', locType:'point'}).bindTooltip('Dellys (2)'));
    fgBiblMarkers.addLayer(L.marker([33.31, 44.36], {alt:'Baghdad', biblQuery:'geo:Baghdad', locType:'point'}).bindTooltip('Baghdad (22)'));
    fgBiblMarkers.addLayer(L.marker([34.01, -5.00], {alt:'Fez', biblQuery:'geo:Fez', locType:'point'}).bindTooltip('Fez (25)'));
    fgBiblMarkers.addLayer(L.marker([36.36, 6.64], {alt:'Constantine', biblQuery:'geo:Constantine', locType:'point'}).bindTooltip('Constantine (1)'));
    fgBiblMarkers.addLayer(L.marker([32.92, 10.45], {alt:'Tataouine', biblQuery:'geo:Tataouine', locType:'point'}).bindTooltip('Tataouine (1)'));
    fgBiblMarkers.addLayer(L.marker([39.46, -0.37], {alt:'Valencia', biblQuery:'geo:Valencia', locType:'point'}).bindTooltip('Valencia (4)'));
    fgBiblMarkers.addLayer(L.marker([32.95, 35.15], {alt:'Kafr Yasif', biblQuery:'geo:Kafr Yasif', locType:'point'}).bindTooltip('Kafr Yasif (1)'));
    fgBiblMarkers.addLayer(L.marker([31.53, 35.09], {alt:'Hebron', biblQuery:'geo:Hebron', locType:'point'}).bindTooltip('Hebron (1)'));
    fgBiblMarkers.addLayer(L.marker([33.51, 36.27], {alt:'Damascus', biblQuery:'geo:Damascus', locType:'point'}).bindTooltip('Damascus (38)'));
    fgBiblMarkers.addLayer(L.marker([31.62, -7.98], {alt:'Marrakesh', biblQuery:'geo:Marrakesh', locType:'point'}).bindTooltip('Marrakesh (7)'));
    fgBiblMarkers.addLayer(L.marker([33.91, 8.12], {alt:'Tozeur', biblQuery:'geo:Tozeur', locType:'point'}).bindTooltip('Tozeur (3)'));
    fgBiblMarkers.addLayer(L.marker([33.97, -6.84], {alt:'Rabat', biblQuery:'geo:Rabat', locType:'point'}).bindTooltip('Rabat (32)'));
    fgBiblMarkers.addLayer(L.marker([35.34, 33.00], {alt:'Kormakitis', biblQuery:'geo:Kormakitis', locType:'point'}).bindTooltip('Kormakitis (13)'));
    fgBiblMarkers.addLayer(L.marker([13.83, 20.84], {alt:'Abéché', biblQuery:'geo:Abéché', locType:'point'}).bindTooltip('Abéché (3)'));
    fgBiblMarkers.addLayer(L.marker([31.52, 53.86], {alt:'Turan', biblQuery:'geo:Turan', locType:'point'}).bindTooltip('Turan (1)'));
    fgBiblMarkers.addLayer(L.marker([33.44, 8.92], {alt:'Zaafrane', biblQuery:'geo:Zaafrane', locType:'point'}).bindTooltip('Zaafrane (1)'));
    fgBiblMarkers.addLayer(L.marker([33.46, 9.02], {alt:'Douz', biblQuery:'geo:Douz', locType:'point'}).bindTooltip('Douz (18)'));
    fgBiblMarkers.addLayer(L.marker([36.35, 43.16], {alt:'Mosul', biblQuery:'geo:Mosul', locType:'point'}).bindTooltip('Mosul (3)'));
    fgBiblMarkers.addLayer(L.marker([14.20, 43.32], {alt:'Zabid', biblQuery:'geo:Zabid', locType:'point'}).bindTooltip('Zabid (2)'));
    fgBiblMarkers.addLayer(L.marker([13.57, 44.01], {alt:'Taiz', biblQuery:'geo:Taiz', locType:'point'}).bindTooltip('Taiz (2)'));
    fgBiblMarkers.addLayer(L.marker([26.57, 49.99], {alt:'Al-Qatif', biblQuery:'geo:Al-Qatif', locType:'point'}).bindTooltip('Al-Qatif (1)'));
    fgBiblMarkers.addLayer(L.marker([23.44, 57.43], {alt:'Al-Ristaq', biblQuery:'geo:Al-Ristaq', locType:'point'}).bindTooltip('Al-Ristaq (1)'));
    fgBiblMarkers.addLayer(L.marker([26.26, 50.62], {alt:'Muharraq', biblQuery:'geo:Muharraq', locType:'point'}).bindTooltip('Muharraq (1)'));
    fgBiblMarkers.addLayer(L.marker([36.86, 39.02], {alt:'Harran', biblQuery:'geo:Harran', locType:'point'}).bindTooltip('Harran (4)'));
    fgBiblMarkers.addLayer(L.marker([37.16, 38.79], {alt:'Şanlıurfa', biblQuery:'geo:Şanlıurfa', locType:'point'}).bindTooltip('Şanlıurfa (5)'));
    fgBiblMarkers.addLayer(L.marker([36.99, 35.33], {alt:'Adana', biblQuery:'geo:Adana', locType:'point'}).bindTooltip('Adana (4)'));
    fgBiblMarkers.addLayer(L.marker([31.76, 35.21], {alt:'Jerusalem', biblQuery:'geo:Jerusalem', locType:'point'}).bindTooltip('Jerusalem (10)'));
    fgBiblMarkers.addLayer(L.marker([34.06, -3.05], {alt:'Debdou', biblQuery:'geo:Debdou', locType:'point'}).bindTooltip('Debdou (1)'));
    fgBiblMarkers.addLayer(L.marker([32.09, 20.18], {alt:'Benghazi', biblQuery:'geo:Benghazi', locType:'point'}).bindTooltip('Benghazi (7)'));
    fgBiblMarkers.addLayer(L.marker([32.03, 35.72], {alt:'Al-Salt', biblQuery:'geo:Al-Salt', locType:'point'}).bindTooltip('Al-Salt (3)'));
    fgBiblMarkers.addLayer(L.marker([31.18, 35.70], {alt:'Al-Karak', biblQuery:'geo:Al-Karak', locType:'point'}).bindTooltip('Al-Karak (1)'));
    fgBiblMarkers.addLayer(L.marker([32.03, 35.82], {alt:'Safut', biblQuery:'geo:Safut', locType:'point'}).bindTooltip('Safut (1)'));
    fgBiblMarkers.addLayer(L.marker([31.71, 35.79], {alt:'Madaba', biblQuery:'geo:Madaba', locType:'point'}).bindTooltip('Madaba (2)'));
    fgBiblMarkers.addLayer(L.marker([25.99, 32.81], {alt:'Qift', biblQuery:'geo:Qift', locType:'point'}).bindTooltip('Qift (2)'));
    fgBiblMarkers.addLayer(L.marker([33.57, -7.58], {alt:'Casablanca', biblQuery:'geo:Casablanca', locType:'point'}).bindTooltip('Casablanca (19)'));
    fgBiblMarkers.addLayer(L.marker([35.16, -5.26], {alt:'Chefchaouen', biblQuery:'geo:Chefchaouen', locType:'point'}).bindTooltip('Chefchaouen (7)'));
    fgBiblMarkers.addLayer(L.marker([33.89, 35.50], {alt:'Beirut', biblQuery:'geo:Beirut', locType:'point'}).bindTooltip('Beirut (6)'));
    fgBiblMarkers.addLayer(L.marker([20.27, 41.44], {alt:'Bilad Ghamid', biblQuery:'geo:Bilad Ghamid', locType:'point'}).bindTooltip('Bilad Ghamid (1)'));
    fgBiblMarkers.addLayer(L.marker([26.23, 50.03], {alt:'Dhahran', biblQuery:'geo:Dhahran', locType:'point'}).bindTooltip('Dhahran (1)'));
    fgBiblMarkers.addLayer(L.marker([35.88, -5.32], {alt:'Ceuta', biblQuery:'geo:Ceuta', locType:'point'}).bindTooltip('Ceuta (3)'));
    fgBiblMarkers.addLayer(L.marker([31.50, -9.75], {alt:'Essaouira', biblQuery:'geo:Essaouira', locType:'point'}).bindTooltip('Essaouira (1)'));
    fgBiblMarkers.addLayer(L.marker([26.23, 32.00], {alt:'El Balyana', biblQuery:'geo:El Balyana', locType:'point'}).bindTooltip('El Balyana (1)'));
    fgBiblMarkers.addLayer(L.marker([15.50, 32.55], {alt:'Khartoum', biblQuery:'geo:Khartoum', locType:'point'}).bindTooltip('Khartoum (5)'));
    fgBiblMarkers.addLayer(L.marker([4.85, 31.57], {alt:'Juba', biblQuery:'geo:Juba', locType:'point'}).bindTooltip('Juba (3)'));
    fgBiblMarkers.addLayer(L.marker([32.83, -7.16], {alt:'Jbala', biblQuery:'geo:Jbala', locType:'point'}).bindTooltip('Jbala (8)'));
    fgBiblMarkers.addLayer(L.marker([33.971590, -6.84], {alt:'Rabat', biblQuery:'geo:Rabat', locType:'point'}).bindTooltip('Rabat (3)'));
    fgBiblMarkers.addLayer(L.marker([33.87, 9.74], {alt:'El-Hamma', biblQuery:'geo:El-Hamma', locType:'point'}).bindTooltip('El-Hamma (3)'));
    fgBiblMarkers.addLayer(L.marker([34.84, 0.14], {alt:'Saïda', biblQuery:'geo:Saïda', locType:'point'}).bindTooltip('Saïda (1)'));
    fgBiblMarkers.addLayer(L.marker([35.21, 4.17], {alt:'Bou Saada', biblQuery:'geo:Bou Saada', locType:'point'}).bindTooltip('Bou Saada (2)'));
    fgBiblMarkers.addLayer(L.marker([35.20, -0.62], {alt:'Sidi Bel Abbès', biblQuery:'geo:Sidi Bel Abbès', locType:'point'}).bindTooltip('Sidi Bel Abbès (4)'));
    fgBiblMarkers.addLayer(L.marker([30.42, -9.59], {alt:'Agadir', biblQuery:'geo:Agadir', locType:'point'}).bindTooltip('Agadir (4)'));
    fgBiblMarkers.addLayer(L.marker([36.45, 6.25], {alt:'Mila', biblQuery:'geo:Mila', locType:'point'}).bindTooltip('Mila (1)'));
    fgBiblMarkers.addLayer(L.marker([37.94, 42.01], {alt:'Tillo', biblQuery:'geo:Tillo', locType:'point'}).bindTooltip('Tillo (3)'));
    fgBiblMarkers.addLayer(L.marker([37.054943, 41.22], {alt:'Qamishli', biblQuery:'geo:Qamishli', locType:'point'}).bindTooltip('Qamishli (2)'));
    fgBiblMarkers.addLayer(L.marker([35.81, 3.70], {alt:'Sidi Aïssa', biblQuery:'geo:Sidi Aïssa', locType:'point'}).bindTooltip('Sidi Aïssa (1)'));
    fgBiblMarkers.addLayer(L.marker([35.17, -6.14], {alt:'Larache', biblQuery:'geo:Larache', locType:'point'}).bindTooltip('Larache (4)'));
    fgBiblMarkers.addLayer(L.marker([33.87, -5.54], {alt:'Meknes', biblQuery:'geo:Meknes', locType:'point'}).bindTooltip('Meknes (7)'));
    fgBiblMarkers.addLayer(L.marker([29.30, 30.84], {alt:'Faiyum', biblQuery:'geo:Faiyum', locType:'point'}).bindTooltip('Faiyum (1)'));
    fgBiblMarkers.addLayer(L.marker([34.61, 43.65], {alt:'Tikrit', biblQuery:'geo:Tikrit', locType:'point'}).bindTooltip('Tikrit (3)'));
    fgBiblMarkers.addLayer(L.marker([36.20, 37.13], {alt:'Aleppo', biblQuery:'geo:Aleppo', locType:'point'}).bindTooltip('Aleppo (8)'));
    fgBiblMarkers.addLayer(L.marker([37.31, 40.73], {alt:'Mardin', biblQuery:'geo:Mardin', locType:'point'}).bindTooltip('Mardin (13)'));
    fgBiblMarkers.addLayer(L.marker([37.29, 41.51], {alt:'Kartmin', biblQuery:'geo:Kartmin', locType:'point'}).bindTooltip('Kartmin (1)'));
    fgBiblMarkers.addLayer(L.marker([35.46, 44.38], {alt:'Kirkuk', biblQuery:'geo:Kirkuk', locType:'point'}).bindTooltip('Kirkuk (1)'));
    fgBiblMarkers.addLayer(L.marker([36.20, 44.00], {alt:'Erbil', biblQuery:'geo:Erbil', locType:'point'}).bindTooltip('Erbil (2)'));
    fgBiblMarkers.addLayer(L.marker([13.92, 44.14], {alt:'Jibla', biblQuery:'geo:Jibla', locType:'point'}).bindTooltip('Jibla (2)'));
    fgBiblMarkers.addLayer(L.marker([36.45, 43.33], {alt:'Bahzani', biblQuery:'geo:Bahzani', locType:'point'}).bindTooltip('Bahzani (1)'));
    fgBiblMarkers.addLayer(L.marker([37.10, 40.93], {alt:'Amude', biblQuery:'geo:Amude', locType:'point'}).bindTooltip('Amude (1)'));
    fgBiblMarkers.addLayer(L.marker([21.38, 39.85], {alt:'Mecca', biblQuery:'geo:Mecca', locType:'point'}).bindTooltip('Mecca (2)'));
    fgBiblMarkers.addLayer(L.marker([28.43, -11.09], {alt:'Tan-Tan', biblQuery:'geo:Tan-Tan', locType:'point'}).bindTooltip('Tan-Tan (1)'));
    fgBiblMarkers.addLayer(L.marker([35.32, 40.13], {alt:'Deir ez-Zor', biblQuery:'geo:Deir ez-Zor', locType:'point'}).bindTooltip('Deir ez-Zor (1)'));
    fgBiblMarkers.addLayer(L.marker([31.39, 34.75], {alt:'Rahat', biblQuery:'geo:Rahat', locType:'point'}).bindTooltip('Rahat (2)'));
    fgBiblMarkers.addLayer(L.marker([34.254, -6.58], {alt:'Kenitra', biblQuery:'geo:Kenitra', locType:'point'}).bindTooltip('Kenitra (1)'));
    fgBiblMarkers.addLayer(L.marker([34.25, -6.67], {alt:'Mehdia', biblQuery:'geo:Mehdia', locType:'point'}).bindTooltip('Mehdia (2)'));
    fgBiblMarkers.addLayer(L.marker([15.22, 32.52], {alt:'Gebel Aulia', biblQuery:'geo:Gebel Aulia', locType:'point'}).bindTooltip('Gebel Aulia (2)'));
    fgBiblMarkers.addLayer(L.marker([36.50, 1.31], {alt:'Ténès', biblQuery:'geo:Ténès', locType:'point'}).bindTooltip('Ténès (2)'));
    fgBiblMarkers.addLayer(L.marker([34.01, 36.73], {alt:'Al-Nabek', biblQuery:'geo:Al-Nabek', locType:'point'}).bindTooltip('Al-Nabek (1)'));
    fgBiblMarkers.addLayer(L.marker([32.79, 35.53], {alt:'Tiberias', biblQuery:'geo:Tiberias', locType:'point'}).bindTooltip('Tiberias (2)'));
    fgBiblMarkers.addLayer(L.marker([32.93, 35.08], {alt:'Akko', biblQuery:'geo:Akko', locType:'point'}).bindTooltip('Akko (1)'));
    fgBiblMarkers.addLayer(L.marker([32.96, 35.49], {alt:'Safed', biblQuery:'geo:Safed', locType:'point'}).bindTooltip('Safed (1)'));
    fgBiblMarkers.addLayer(L.marker([31.55, 48.18], {alt:'Dascht-e-Azadegan', biblQuery:'geo:Dascht-e-Azadegan', locType:'point'}).bindTooltip('Dascht-e-Azadegan (1)'));
    fgBiblMarkers.addLayer(L.marker([31.08, -9.75], {alt:'El Haouz', biblQuery:'geo:El Haouz', locType:'point'}).bindTooltip('El Haouz (1)'));
    fgBiblMarkers.addLayer(L.marker([33.23, 35.42], {alt:'Khirbet Selm', biblQuery:'geo:Khirbet Selm', locType:'point'}).bindTooltip('Khirbet Selm (1)'));
    fgBiblMarkers.addLayer(L.marker([34.39, 35.89], {alt:'Zgharta', biblQuery:'geo:Zgharta', locType:'point'}).bindTooltip('Zgharta (1)'));
    fgBiblMarkers.addLayer(L.marker([39.86, -4.02], {alt:'Toledo', biblQuery:'geo:Toledo', locType:'point'}).bindTooltip('Toledo (3)'));
    fgBiblMarkers.addLayer(L.marker([35.00, -5.91], {alt:'Ksar el-Kebir', biblQuery:'geo:Ksar el-Kebir', locType:'point'}).bindTooltip('Ksar el-Kebir (4)'));
    fgBiblMarkers.addLayer(L.marker([31.06, -6.55], {alt:'Skoura', biblQuery:'geo:Skoura', locType:'point'}).bindTooltip('Skoura (8)'));
    fgBiblMarkers.addLayer(L.marker([36.11, 0.87], {alt:'Mazouna', biblQuery:'geo:Mazouna', locType:'point'}).bindTooltip('Mazouna (2)'));
    fgBiblMarkers.addLayer(L.marker([34.68, -1.90], {alt:'Oujda', biblQuery:'geo:Oujda', locType:'point'}).bindTooltip('Oujda (6)'));
    fgBiblMarkers.addLayer(L.marker([35.69, -0.63], {alt:'Oran', biblQuery:'geo:Oran', locType:'point'}).bindTooltip('Oran (3)'));
    fgBiblMarkers.addLayer(L.marker([32.30, -9.22], {alt:'Safi', biblQuery:'geo:Safi', locType:'point'}).bindTooltip('Safi (1)'));
    fgBiblMarkers.addLayer(L.marker([32.06, 45.23], {alt:'Afak', biblQuery:'geo:Afak', locType:'point'}).bindTooltip('Afak (1)'));
    fgBiblMarkers.addLayer(L.marker([30.50, 47.78], {alt:'Basra', biblQuery:'geo:Basra', locType:'point'}).bindTooltip('Basra (1)'));
    fgBiblMarkers.addLayer(L.marker([32.47, 44.42], {alt:'Hillah', biblQuery:'geo:Hillah', locType:'point'}).bindTooltip('Hillah (1)'));
    fgBiblMarkers.addLayer(L.marker([36.23, 38.01], {alt:'Al-Khafsah', biblQuery:'geo:Al-Khafsah', locType:'point'}).bindTooltip('Al-Khafsah (1)'));
    fgBiblMarkers.addLayer(L.marker([27.81, 30.90], {alt:'Abada', biblQuery:'geo:Abada', locType:'point'}).bindTooltip('Abada (2)'));
    fgBiblMarkers.addLayer(L.marker([40.64, 22.94], {alt:'Thessaloniki', biblQuery:'geo:Thessaloniki', locType:'point'}).bindTooltip('Thessaloniki (1)'));
    fgBiblMarkers.addLayer(L.marker([33.82, 36.50], {alt:'Jubb´adin', biblQuery:'geo:Jubb´adin', locType:'point'}).bindTooltip('Jubb´adin (1)'));
    fgBiblMarkers.addLayer(L.marker([34.21, -3.99], {alt:'Taza', biblQuery:'geo:Taza', locType:'point'}).bindTooltip('Taza (3)'));
    fgBiblMarkers.addLayer(L.marker([33.87, -5.54], {alt:'Granada', biblQuery:'geo:Granada', locType:'point'}).bindTooltip('Granada (2)'));
    fgBiblMarkers.addLayer(L.marker([34.23, 37.23], {alt:'Al-Qaryatayn', biblQuery:'geo:Al-Qaryatayn', locType:'point'}).bindTooltip('Al-Qaryatayn (1)'));
    fgBiblMarkers.addLayer(L.marker([34.25, 38.31], {alt:'Palmyra', biblQuery:'geo:Palmyra', locType:'point'}).bindTooltip('Palmyra (2)'));
    fgBiblMarkers.addLayer(L.marker([34.88, 38.87], {alt:'Al-Sukhna', biblQuery:'geo:Al-Sukhna', locType:'point'}).bindTooltip('Al-Sukhna (3)'));
    fgBiblMarkers.addLayer(L.marker([33.82, -4.83], {alt:'Sefrou', biblQuery:'geo:Sefrou', locType:'point'}).bindTooltip('Sefrou (3)'));
    fgBiblMarkers.addLayer(L.marker([33.41, 36.51], {alt:'Rif', biblQuery:'geo:Rif', locType:'point'}).bindTooltip('Rif (1)'));
    fgBiblMarkers.addLayer(L.marker([14.72, 44.58], {alt:'Al Baraddun', biblQuery:'geo:Al Baraddun', locType:'point'}).bindTooltip('Al Baraddun (2)'));
    fgBiblMarkers.addLayer(L.marker([53.29, -6.19], {alt:'El Jadida', biblQuery:'geo:El Jadida', locType:'point'}).bindTooltip('El Jadida (1)'));
    fgBiblMarkers.addLayer(L.marker([33.23, -8.50], {alt:'El Jadida', biblQuery:'geo:El Jadida', locType:'point'}).bindTooltip('El Jadida (1)'));
    fgBiblMarkers.addLayer(L.marker([33.99, -4.30], {alt:'Taza', biblQuery:'geo:Taza', locType:'point'}).bindTooltip('Taza (2)'));
    fgBiblMarkers.addLayer(L.marker([36.19, 35.95], {alt:'Samandağ', biblQuery:'geo:Samandağ', locType:'point'}).bindTooltip('Samandağ (1)'));
    fgBiblMarkers.addLayer(L.marker([36.58, 36.17], {alt:'Iskenderun', biblQuery:'geo:Iskenderun', locType:'point'}).bindTooltip('Iskenderun (1)'));
    fgBiblMarkers.addLayer(L.marker([32.08, 34.78], {alt:'Tel Aviv', biblQuery:'geo:Tel Aviv', locType:'point'}).bindTooltip('Tel Aviv (1)'));
    fgBiblMarkers.addLayer(L.marker([31.93, 34.87], {alt:'Ramla', biblQuery:'geo:Ramla', locType:'point'}).bindTooltip('Ramla (1)'));
    fgBiblMarkers.addLayer(L.marker([36.20, 36.16], {alt:'Antakya', biblQuery:'geo:Antakya', locType:'point'}).bindTooltip('Antakya (2)'));
    fgBiblMarkers.addLayer(L.marker([32.04, 34.75], {alt:'Jaffa', biblQuery:'geo:Jaffa', locType:'point'}).bindTooltip('Jaffa (3)'));
    fgBiblMarkers.addLayer(L.marker([31.70, 35.20], {alt:'Bethlehem', biblQuery:'geo:Bethlehem', locType:'point'}).bindTooltip('Bethlehem (2)'));
    fgBiblMarkers.addLayer(L.marker([29.82, -5.72], {alt:'M´hamid', biblQuery:'geo:M´hamid', locType:'point'}).bindTooltip('M´hamid (2)'));
    fgBiblMarkers.addLayer(L.marker([33.30, 44.38], {alt:'Baghdad', biblQuery:'geo:Baghdad', locType:'point'}).bindTooltip('Baghdad (5)'));
    fgBiblMarkers.addLayer(L.marker([36.80, 42.09], {alt:'Rabia', biblQuery:'geo:Rabia', locType:'point'}).bindTooltip('Rabia (1)'));
    fgBiblMarkers.addLayer(L.marker([35.89, -5.28], {alt:'Sebta', biblQuery:'geo:Sebta', locType:'point'}).bindTooltip('Sebta (1)'));
    fgBiblMarkers.addLayer(L.marker([36.62, -4.50], {alt:'Andalusia, Sevilla', biblQuery:'geo:Andalusia, Sevilla', locType:'point'}).bindTooltip('Andalusia, Sevilla (1)'));
    fgBiblMarkers.addLayer(L.marker([34.03, -6.77], {alt:'Sale', biblQuery:'geo:Sale', locType:'point'}).bindTooltip('Sale (3)'));
    fgBiblMarkers.addLayer(L.marker([32.18, -6.70], {alt:'Tadla', biblQuery:'geo:Tadla', locType:'point'}).bindTooltip('Tadla (1)'));
    fgBiblMarkers.addLayer(L.marker([34.79, -5.56], {alt:'Ouazzane', biblQuery:'geo:Ouazzane', locType:'point'}).bindTooltip('Ouazzane (3)'));
    fgBiblMarkers.addLayer(L.marker([34.63, -3.93], {alt:'Gzenaya', biblQuery:'geo:Gzenaya', locType:'point'}).bindTooltip('Gzenaya (1)'));
    fgBiblMarkers.addLayer(L.marker([34.13, -2.05], {alt:'Beni Snassene', biblQuery:'geo:Beni Snassene', locType:'point'}).bindTooltip('Beni Snassene (1)'));
    fgBiblMarkers.addLayer(L.marker([51.20, 4.39], {alt:'Brussels', biblQuery:'geo:Brussels', locType:'point'}).bindTooltip('Brussels (1)'));
    fgBiblMarkers.addLayer(L.marker([31.79, 35.24], {alt:'Isawiya', biblQuery:'geo:Isawiya', locType:'point'}).bindTooltip('Isawiya (1)'));
    fgBiblMarkers.addLayer(L.marker([35.50, 11.04], {alt:'Mahdia', biblQuery:'geo:Mahdia', locType:'point'}).bindTooltip('Mahdia (1)'));
    fgBiblMarkers.addLayer(L.marker([25.52, 29.05], {alt:'Ismant', biblQuery:'geo:Ismant', locType:'point'}).bindTooltip('Ismant (1)'));
    fgBiblMarkers.addLayer(L.marker([25.42, 29.00], {alt:'ilBashandi', biblQuery:'geo:ilBashandi', locType:'point'}).bindTooltip('ilBashandi (2)'));
    fgBiblMarkers.addLayer(L.marker([33.13, 35.33], {alt:'Bayt Lif', biblQuery:'geo:Bayt Lif', locType:'point'}).bindTooltip('Bayt Lif (1)'));
    fgBiblMarkers.addLayer(L.marker([37.92, 41.94], {alt:'Siirt', biblQuery:'geo:Siirt', locType:'point'}).bindTooltip('Siirt (3)'));
    fgBiblMarkers.addLayer(L.marker([31.62, -7.98], {alt:'Marrakech', biblQuery:'geo:Marrakech', locType:'point'}).bindTooltip('Marrakech (1)'));
    fgBiblMarkers.addLayer(L.marker([36.81, 34.64], {alt:'Mersin', biblQuery:'geo:Mersin', locType:'point'}).bindTooltip('Mersin (1)'));
    fgBiblMarkers.addLayer(L.marker([25.28, 51.53], {alt:'Doha', biblQuery:'geo:Doha', locType:'point'}).bindTooltip('Doha (1)'));
    fgBiblMarkers.addLayer(L.marker([36.75, 3.05], {alt:'Algier', biblQuery:'geo:Algier', locType:'point'}).bindTooltip('Algier (3)'));
    fgBiblMarkers.addLayer(L.marker([32.22, -4.46], {alt:'Er Rachidia', biblQuery:'geo:Er Rachidia', locType:'point'}).bindTooltip('Er Rachidia (1)'));
    fgBiblMarkers.addLayer(L.marker([29.36, -7.69], {alt:'Oued Drâa', biblQuery:'geo:Oued Drâa', locType:'point'}).bindTooltip('Oued Drâa (1)'));
    fgBiblMarkers.addLayer(L.marker([33.64, 42.82], {alt:'Hit', biblQuery:'geo:Hit', locType:'point'}).bindTooltip('Hit (1)'));
    fgBiblMarkers.addLayer(L.marker([22.95, 57.29], {alt:'Bahla', biblQuery:'geo:Bahla', locType:'point'}).bindTooltip('Bahla (1)'));
    fgBiblMarkers.addLayer(L.marker([38.33, 41.42], {alt:'Sason', biblQuery:'geo:Sason', locType:'point'}).bindTooltip('Sason (1)'));
    fgBiblMarkers.addLayer(L.marker([37.10, 40.93], {alt:'Amuda', biblQuery:'geo:Amuda', locType:'point'}).bindTooltip('Amuda (1)'));
    fgBiblMarkers.addLayer(L.marker([34.25, -6.58], {alt:'Kenitra', biblQuery:'geo:Kenitra', locType:'point'}).bindTooltip('Kenitra (1)'));
    fgBiblMarkers.addLayer(L.marker([34.01, 36.73], {alt:'Nabk', biblQuery:'geo:Nabk', locType:'point'}).bindTooltip('Nabk (2)'));
    fgBiblMarkers.addLayer(L.marker([34.88, -1.31], {alt:'Tlemcen', biblQuery:'geo:Tlemcen', locType:'point'}).bindTooltip('Tlemcen (3)'));
    fgBiblMarkers.addLayer(L.marker([36.45, 10.71], {alt:'Nabeul', biblQuery:'geo:Nabeul', locType:'point'}).bindTooltip('Nabeul (1)'));
    fgBiblMarkers.addLayer(L.marker([35.24, -3.93], {alt:'Al Hoceima', biblQuery:'geo:Al Hoceima', locType:'point'}).bindTooltip('Al Hoceima (1)'));
    fgBiblMarkers.addLayer(L.marker([35.12, -4.32], {alt:'Jnanate', biblQuery:'geo:Jnanate', locType:'point'}).bindTooltip('Jnanate (1)'));
    fgBiblMarkers.addLayer(L.marker([31.95, 34.88], {alt:'Lod', biblQuery:'geo:Lod', locType:'point'}).bindTooltip('Lod (1)'));
    fgBiblMarkers.addLayer(L.marker([32.01, 34.78], {alt:'Holon', biblQuery:'geo:Holon', locType:'point'}).bindTooltip('Holon (1)'));
    fgBiblMarkers.addLayer(L.marker([21.28, 39.23], {alt:'Jeddah', biblQuery:'geo:Jeddah', locType:'point'}).bindTooltip('Jeddah (1)'));
    fgBiblMarkers.addLayer(L.marker([29.83, -5.72], {alt:'Zair', biblQuery:'geo:Zair', locType:'point'}).bindTooltip('Zair (1)'));
    fgBiblMarkers.addLayer(L.marker([15.07, 43.74], {alt:'Manakhah', biblQuery:'geo:Manakhah', locType:'point'}).bindTooltip('Manakhah (1)'));
    fgBiblMarkers.addLayer(L.marker([35.88, -5.33], {alt:'Ceuta', biblQuery:'geo:Ceuta', locType:'point'}).bindTooltip('Ceuta (1)'));
    fgBiblMarkers.addLayer(L.marker([34.74, 10.76], {alt:'Sfax', biblQuery:'geo:Sfax', locType:'point'}).bindTooltip('Sfax (1)'));
    fgBiblMarkers.addLayer(L.marker([31.86, 35.25], {alt:'Abu Shusha', biblQuery:'geo:Abu Shusha', locType:'point'}).bindTooltip('Abu Shusha (1)'));
    fgBiblMarkers.addLayer(L.marker([35.49, 43.23], {alt:'Al-Shirqat', biblQuery:'geo:Al-Shirqat', locType:'point'}).bindTooltip('Al-Shirqat (1)'));
    fgBiblMarkers.addLayer(L.marker([31.35, 34.30], {alt:'Gaza', biblQuery:'geo:Gaza', locType:'point'}).bindTooltip('Gaza (2)'));
    fgBiblMarkers.addLayer(L.marker([36.70, 8.75], {alt:'Beni M´tir', biblQuery:'geo:Beni M´tir', locType:'point'}).bindTooltip('Beni M´tir (1)'));
    fgBiblMarkers.addLayer(L.marker([36.15, 10.34], {alt:'Takrouna', biblQuery:'geo:Takrouna', locType:'point'}).bindTooltip('Takrouna (1)'));
    fgBiblMarkers.addLayer(L.marker([36.81, 5.74], {alt:'Jijel', biblQuery:'geo:Jijel', locType:'point'}).bindTooltip('Jijel (1)'));
    fgBiblMarkers.addLayer(L.marker([15.50, 32.55], {alt:'Khartum', biblQuery:'geo:Khartum', locType:'point'}).bindTooltip('Khartum (1)'));
    fgBiblMarkers.addLayer(L.marker([15.64, 32.48], {alt:'Omdurman', biblQuery:'geo:Omdurman', locType:'point'}).bindTooltip('Omdurman (1)'));
    fgBiblMarkers.addLayer(L.marker([31.26, 32.30], {alt:'Port Said', biblQuery:'geo:Port Said', locType:'point'}).bindTooltip('Port Said (1)'));
    fgBiblMarkers.addLayer(L.marker([36.74, 43.88], {alt:'Aqrah', biblQuery:'geo:Aqrah', locType:'point'}).bindTooltip('Aqrah (1)'));
    fgBiblMarkers.addLayer(L.marker([-1.31, 36.78], {alt:'Kibera', biblQuery:'geo:Kibera', locType:'point'}).bindTooltip('Kibera (1)'));
    fgBiblMarkers.addLayer(L.marker([36.56, 2.20], {alt:'Cherchell', biblQuery:'geo:Cherchell', locType:'point'}).bindTooltip('Cherchell (1)'));
    fgBiblMarkers.addLayer(L.marker([12.78, 45.01], {alt:'Aden', biblQuery:'geo:Aden', locType:'point'}).bindTooltip('Aden (1)'));
    fgBiblMarkers.addLayer(L.marker([32.79, 34.98], {alt:'Haifa', biblQuery:'geo:Haifa', locType:'point'}).bindTooltip('Haifa (1)'));
    fgBiblMarkers.addLayer(L.marker([34.43, 35.83], {alt:'Tripoli', biblQuery:'geo:Tripoli', locType:'point'}).bindTooltip('Tripoli (1)'));
    fgBiblMarkers.addLayer(L.marker([43.99, 0.06], {alt:'France', biblQuery:'geo:France', locType:'point'}).bindTooltip('France (1)'));
    fgBiblMarkers.addLayer(L.marker([29.36, 47.79], {alt:'Kuwait', biblQuery:'geo:Kuwait', locType:'point'}).bindTooltip('Kuwait (1)'));
    fgBiblMarkers.addLayer(L.marker([23.96, 57.09], {alt:'Al-Khaburah', biblQuery:'geo:Al-Khaburah', locType:'point'}).bindTooltip('Al-Khaburah (1)'));
    fgBiblMarkers.addLayer(L.marker([16.95, 43.74], {alt:'Sa´dah', biblQuery:'geo:Sa´dah', locType:'point'}).bindTooltip('Sa´dah (2)'));

}
*/

function insertGeoRegMarkers(query_, scope_) {
    /* *************************************************** */
    /* * Function to directly retrieve data from BaseX *** */
    /* *************************************************** */
    //example: insertGeoRegMarkers('', 'geo_reg');
    //example (rest): sUrl = 'bibl_markers?query=none&scope=geo';
    
     
    if (query_ == '') { query_ = 'none'; } 
    sUrl = 'bibl_markers?query=' + query_ + '&scope=' + scope_;
    /*sQuerySecPart = ',vt:textbook';*/
    var sQuerySecPart = '';
    if (query_ != 'none') {
       sQuerySecPart = ',' + query_;
    }
    
    console.log('sUrl: ' + sUrl);
    $.ajax({
    url: sUrl,
            type: 'GET',
            dataType: 'xml',
               contentType: 'application/html; charset=utf-8',
               success: function(result) { 
                  s = '';
                  cnt = 0;
                  $(result).find('r').each(function(index){
                     cnt = cnt + 1;
                     console.log(sUrl);
                     loc = $(this).find('loc').text();
                     sAlt = $(this).find('alt').text();
                     sFreq = $(this).find('freq').text();
                     values = loc.split(",");
                     v1 = parseFloat(values[0]);
                     v2 = parseFloat(values[1]);
                     sTooltip = sAlt + ' (' + sFreq + ')'; 
                     
                     if ($(this).attr('type') == 'geo') { 
                        sQuery = 'geo:' + sAlt + sQuerySecPart;
                        fgBiblMarkers.addLayer(L.marker([v1, v2], {alt:sAlt, locType:'point', biblQuery:sQuery}).bindTooltip(sTooltip));
                     }
                     if ($(this).attr('type') == 'reg') {
                        sQuery = 'reg:' + sAlt + sQuerySecPart;
                        fgBiblMarkers.addLayer(L.circle([v1, v2], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, 
                            alt:sAlt, biblQuery:sQuery}).bindTooltip(sTooltip));
                     }
                   }
                  
                  );                           
               },
               error: function (error) {
                  alert('Error: ' + error);
               }                           
    });
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