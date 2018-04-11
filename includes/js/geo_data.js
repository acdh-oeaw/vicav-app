/* ******************************************** */
 /* Create geodata with http://www.latlong.net/ */
/* ******************************************** */

function insertDictMarkers() {
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

function insertBiblRegMarkers() {
    setExplanation('Identified Regions');
    /* ******************************** */
    /* Create with reg_bibl__001.xq */
    /* ******************************** */

fgBiblMarkers.addLayer(L.circle([32.93, 36.53], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syro-Palestine', locType:'region', biblType:'', biblid:''}).bindTooltip('Syro-Palestine (330)'));
fgBiblMarkers.addLayer(L.circle([33.71, 35.66], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Lebanon', locType:'region', biblType:'', biblid:''}).bindTooltip('Lebanon (50)'));
fgBiblMarkers.addLayer(L.circle([31.26, 36.15], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Jordan', locType:'region', biblType:'', biblid:''}).bindTooltip('Jordan (55)'));
fgBiblMarkers.addLayer(L.circle([31.46, -6.39], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Morocco', locType:'region', biblType:'', biblid:''}).bindTooltip('Morocco (330)'));
fgBiblMarkers.addLayer(L.circle([31.89, 35.25], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Palestine', locType:'region', biblType:'', biblid:''}).bindTooltip('Palestine (89)'));
fgBiblMarkers.addLayer(L.circle([27.39, 30.26], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Egypt', locType:'region', biblType:'', biblid:''}).bindTooltip('Egypt (269)'));
fgBiblMarkers.addLayer(L.circle([22.36, 46.81], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Arabian Peninsula', locType:'region', biblType:'', biblid:''}).bindTooltip('Arabian Peninsula (203)'));
fgBiblMarkers.addLayer(L.circle([26.57, 49.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Gulf', locType:'region', biblType:'', biblid:''}).bindTooltip('Gulf (20)'));
fgBiblMarkers.addLayer(L.circle([21.40, 57.76], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Oman', locType:'region', biblType:'', biblid:''}).bindTooltip('Oman (1)'));
fgBiblMarkers.addLayer(L.circle([38.08, 41.10], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Turkey', locType:'region', biblType:'', biblid:''}).bindTooltip('Turkey (81)'));
fgBiblMarkers.addLayer(L.circle([31.64, 45.33], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iraq', locType:'region', biblType:'', biblid:''}).bindTooltip('Iraq (96)'));
fgBiblMarkers.addLayer(L.circle([35.14, 42.48], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mesopotamia', locType:'region', biblType:'', biblid:''}).bindTooltip('Mesopotamia (174)'));
fgBiblMarkers.addLayer(L.circle([31.53, 34.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Israel', locType:'region', biblType:'', biblid:''}).bindTooltip('Israel (112)'));
fgBiblMarkers.addLayer(L.circle([33.59, 9.37], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Tunisia', locType:'region', biblType:'', biblid:''}).bindTooltip('Tunisia (125)'));
fgBiblMarkers.addLayer(L.circle([35.87, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Malta', locType:'region', biblType:'', biblid:''}).bindTooltip('Malta (23)'));
fgBiblMarkers.addLayer(L.circle([28.79, 18.04], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Libya', locType:'region', biblType:'', biblid:''}).bindTooltip('Libya (34)'));
fgBiblMarkers.addLayer(L.circle([39.92, -3.02], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Andalusia', locType:'region', biblType:'', biblid:''}).bindTooltip('Andalusia (81)'));
fgBiblMarkers.addLayer(L.circle([16.31, 47.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Yemen', locType:'region', biblType:'', biblid:''}).bindTooltip('Yemen (95)'));
fgBiblMarkers.addLayer(L.circle([11.12, 12.24], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Nigeria', locType:'region', biblType:'', biblid:''}).bindTooltip('Nigeria (10)'));
fgBiblMarkers.addLayer(L.circle([34.61, 38.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syria', locType:'region', biblType:'', biblid:''}).bindTooltip('Syria (110)'));
fgBiblMarkers.addLayer(L.circle([19.45, -13.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mauritania', locType:'region', biblType:'', biblid:''}).bindTooltip('Mauritania (32)'));
fgBiblMarkers.addLayer(L.circle([25.25, 51.18], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Qatar', locType:'region', biblType:'', biblid:''}).bindTooltip('Qatar (6)'));
fgBiblMarkers.addLayer(L.circle([11.30, 17.86], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Chad', locType:'region', biblType:'', biblid:''}).bindTooltip('Chad (15)'));
fgBiblMarkers.addLayer(L.circle([16.14, 30.29], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Sudan', locType:'region', biblType:'', biblid:''}).bindTooltip('Sudan (37)'));
fgBiblMarkers.addLayer(L.circle([34.54, 3.30], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Algeria', locType:'region', biblType:'', biblid:''}).bindTooltip('Algeria (80)'));
fgBiblMarkers.addLayer(L.circle([30.40, 50.60], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iran', locType:'region', biblType:'', biblid:''}).bindTooltip('Iran (6)'));
fgBiblMarkers.addLayer(L.circle([26.00, 50.57], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Bahrain', locType:'region', biblType:'', biblid:''}).bindTooltip('Bahrain (5)'));
fgBiblMarkers.addLayer(L.circle([40.26, 65.35], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Uzbekistan', locType:'region', biblType:'', biblid:''}).bindTooltip('Uzbekistan (10)'));
fgBiblMarkers.addLayer(L.circle([22.95, 46.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Saudi Arabia', locType:'region', biblType:'', biblid:''}).bindTooltip('Saudi Arabia (36)'));
fgBiblMarkers.addLayer(L.circle([29.25, 47.88], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Kuweit', locType:'region', biblType:'', biblid:''}).bindTooltip('Kuweit (8)'));
fgBiblMarkers.addLayer(L.circle([21.40, 57.76], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Oman', locType:'region', biblType:'', biblid:''}).bindTooltip('Oman (16)'));
fgBiblMarkers.addLayer(L.circle([39.92, -3.02], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Spain', locType:'region', biblType:'', biblid:''}).bindTooltip('Spain (2)'));
fgBiblMarkers.addLayer(L.circle([37.62, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Sicily', locType:'region', biblType:'', biblid:''}).bindTooltip('Sicily (14)'));
fgBiblMarkers.addLayer(L.circle([33.66, 66.14], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Afghanistan', locType:'region', biblType:'', biblid:''}).bindTooltip('Afghanistan (4)'));

} 

function insertBiblGeoMarkers() {
    setExplanation('Identified Locations');
    /* ******************************** */
    /* Create with loc_bibl__001.xq */
    /* ******************************** */
 
fgBiblMarkers.addLayer(L.marker([30.04, 31.23], {alt:'Cairo', locType:'point'}).bindTooltip('Cairo (95)'));
fgBiblMarkers.addLayer(L.marker([35.75, -5.83], {alt:'Tanger', locType:'point'}).bindTooltip('Tanger (7)'));
fgBiblMarkers.addLayer(L.marker([12.78, 45.01], {alt:'Aden', locType:'point'}).bindTooltip('Aden (1)'));
fgBiblMarkers.addLayer(L.marker([31.26, 32.30], {alt:'Port Said', locType:'point'}).bindTooltip('Port Said (1)'));
fgBiblMarkers.addLayer(L.marker([33.51, 36.27], {alt:'Damascus', locType:'point'}).bindTooltip('Damascus (37)'));
fgBiblMarkers.addLayer(L.marker([36.20, 37.13], {alt:'Aleppo', locType:'point'}).bindTooltip('Aleppo (8)'));
fgBiblMarkers.addLayer(L.marker([36.35, 43.16], {alt:'Mosul', locType:'point'}).bindTooltip('Mosul (3)'));
fgBiblMarkers.addLayer(L.marker([33.46, 9.02], {alt:'Douz', locType:'point'}).bindTooltip('Douz (18)'));
fgBiblMarkers.addLayer(L.marker([39.86, -4.02], {alt:'Toledo', locType:'point'}).bindTooltip('Toledo (4)'));
fgBiblMarkers.addLayer(L.marker([25.28, 51.53], {alt:'Doha', locType:'point'}).bindTooltip('Doha (1)'));
fgBiblMarkers.addLayer(L.marker([13.92, 44.14], {alt:'Jibla', locType:'point'}).bindTooltip('Jibla (2)'));
fgBiblMarkers.addLayer(L.marker([36.80, 10.18], {alt:'Tunis', locType:'point'}).bindTooltip('Tunis (28)'));
fgBiblMarkers.addLayer(L.marker([35.82, 10.60], {alt:'Sousse', locType:'point'}).bindTooltip('Sousse (6)'));
fgBiblMarkers.addLayer(L.marker([34.74, 10.76], {alt:'Sfax', locType:'point'}).bindTooltip('Sfax (1)'));
fgBiblMarkers.addLayer(L.marker([30.42, -9.59], {alt:'Agadir', locType:'point'}).bindTooltip('Agadir (3)'));
fgBiblMarkers.addLayer(L.marker([37.054943, 41.22], {alt:'Qamishli', locType:'point'}).bindTooltip('Qamishli (2)'));
fgBiblMarkers.addLayer(L.marker([14.72, 44.58], {alt:'Al Baraddun', locType:'point'}).bindTooltip('Al Baraddun (2)'));
fgBiblMarkers.addLayer(L.marker([32.88, 13.19], {alt:'Tripoli', locType:'point'}).bindTooltip('Tripoli (11)'));
fgBiblMarkers.addLayer(L.marker([35.69, -0.63], {alt:'Oran', locType:'point'}).bindTooltip('Oran (2)'));
fgBiblMarkers.addLayer(L.marker([33.31, 44.36], {alt:'Baghdad', locType:'point'}).bindTooltip('Baghdad (23)'));
fgBiblMarkers.addLayer(L.marker([31.79, 35.24], {alt:'Isawiya', locType:'point'}).bindTooltip('Isawiya (1)'));
fgBiblMarkers.addLayer(L.marker([35.21, 4.17], {alt:'Bou Saada', locType:'point'}).bindTooltip('Bou Saada (2)'));
fgBiblMarkers.addLayer(L.marker([31.06, -6.55], {alt:'Skoura', locType:'point'}).bindTooltip('Skoura (6)'));
fgBiblMarkers.addLayer(L.marker([35.20, -0.62], {alt:'Sidi Bel Abbès', locType:'point'}).bindTooltip('Sidi Bel Abbès (4)'));
fgBiblMarkers.addLayer(L.marker([13.83, 20.84], {alt:'Abéché', locType:'point'}).bindTooltip('Abéché (3)'));
fgBiblMarkers.addLayer(L.marker([14.56, 44.34], {alt:'Yafa', locType:'point'}).bindTooltip('Yafa (9)'));
fgBiblMarkers.addLayer(L.marker([33.97, -6.84], {alt:'Rabat', locType:'point'}).bindTooltip('Rabat (11)'));
fgBiblMarkers.addLayer(L.marker([32.03, 35.72], {alt:'Al-Salt', locType:'point'}).bindTooltip('Al-Salt (4)'));
fgBiblMarkers.addLayer(L.marker([32.08, 34.78], {alt:'Tel Aviv', locType:'point'}).bindTooltip('Tel Aviv (1)'));
fgBiblMarkers.addLayer(L.marker([31.53, 35.09], {alt:'Hebron', locType:'point'}).bindTooltip('Hebron (1)'));
fgBiblMarkers.addLayer(L.marker([41.67, 26.55], {alt:'Edirne', locType:'point'}).bindTooltip('Edirne (1)'));
fgBiblMarkers.addLayer(L.marker([40.64, 22.94], {alt:'Thessaloniki', locType:'point'}).bindTooltip('Thessaloniki (1)'));
fgBiblMarkers.addLayer(L.marker([33.30, 44.38], {alt:'Baghdad', locType:'point'}).bindTooltip('Baghdad (6)'));
fgBiblMarkers.addLayer(L.marker([14.20, 43.32], {alt:'Zabid', locType:'point'}).bindTooltip('Zabid (2)'));
fgBiblMarkers.addLayer(L.marker([31.62, -7.98], {alt:'Marrakesh', locType:'point'}).bindTooltip('Marrakesh (1)'));
fgBiblMarkers.addLayer(L.marker([36.11, 0.87], {alt:'Mazouna', locType:'point'}).bindTooltip('Mazouna (2)'));
fgBiblMarkers.addLayer(L.marker([15.36, 44.19], {alt:'Sanaa', locType:'point'}).bindTooltip('Sanaa (18)'));
fgBiblMarkers.addLayer(L.marker([32.93, 35.08], {alt:'Akko', locType:'point'}).bindTooltip('Akko (1)'));
fgBiblMarkers.addLayer(L.marker([31.76, 35.21], {alt:'Jerusalem', locType:'point'}).bindTooltip('Jerusalem (10)'));
fgBiblMarkers.addLayer(L.marker([25.55, 29.26], {alt:'Balat', locType:'point'}).bindTooltip('Balat (1)'));
fgBiblMarkers.addLayer(L.marker([25.51, 29.16], {alt:'Dakhla', locType:'point'}).bindTooltip('Dakhla (4)'));
fgBiblMarkers.addLayer(L.marker([25.42, 29.00], {alt:'ilBashandi', locType:'point'}).bindTooltip('ilBashandi (2)'));
fgBiblMarkers.addLayer(L.marker([31.71, 35.79], {alt:'Madaba', locType:'point'}).bindTooltip('Madaba (2)'));
fgBiblMarkers.addLayer(L.marker([32.03, 35.82], {alt:'Safut', locType:'point'}).bindTooltip('Safut (1)'));
fgBiblMarkers.addLayer(L.marker([33.57, -7.58], {alt:'Casablanca', locType:'point'}).bindTooltip('Casablanca (11)'));
fgBiblMarkers.addLayer(L.marker([36.99, 35.33], {alt:'Adana', locType:'point'}).bindTooltip('Adana (5)'));
fgBiblMarkers.addLayer(L.marker([32.95, 35.15], {alt:'Kafr Yasif', locType:'point'}).bindTooltip('Kafr Yasif (1)'));
fgBiblMarkers.addLayer(L.marker([36.87, 3.93], {alt:'Dellys', locType:'point'}).bindTooltip('Dellys (2)'));
fgBiblMarkers.addLayer(L.marker([39.76, 64.45], {alt:'Bukhara', locType:'point'}).bindTooltip('Bukhara (4)'));
fgBiblMarkers.addLayer(L.marker([36.75, 3.05], {alt:'Algier', locType:'point'}).bindTooltip('Algier (4)'));
fgBiblMarkers.addLayer(L.marker([25.99, 32.81], {alt:'Qift', locType:'point'}).bindTooltip('Qift (2)'));
fgBiblMarkers.addLayer(L.marker([31.39, 34.75], {alt:'Rahat', locType:'point'}).bindTooltip('Rahat (2)'));
fgBiblMarkers.addLayer(L.marker([36.20, 36.16], {alt:'Antakya', locType:'point'}).bindTooltip('Antakya (2)'));
fgBiblMarkers.addLayer(L.marker([36.19, 36.16], {alt:'Antakya', locType:'point'}).bindTooltip('Antakya (4)'));
fgBiblMarkers.addLayer(L.marker([33.13, 35.33], {alt:'Bayt Lif', locType:'point'}).bindTooltip('Bayt Lif (1)'));
fgBiblMarkers.addLayer(L.marker([37.31, 40.73], {alt:'Mardin', locType:'point'}).bindTooltip('Mardin (13)'));
fgBiblMarkers.addLayer(L.marker([33.89, 35.50], {alt:'Beirut', locType:'point'}).bindTooltip('Beirut (6)'));
fgBiblMarkers.addLayer(L.marker([36.81, 34.64], {alt:'Mersin', locType:'point'}).bindTooltip('Mersin (2)'));
fgBiblMarkers.addLayer(L.marker([35.34, 33.00], {alt:'Kormakitis', locType:'point'}).bindTooltip('Kormakitis (14)'));
fgBiblMarkers.addLayer(L.marker([37.29, 41.51], {alt:'Kartmin', locType:'point'}).bindTooltip('Kartmin (1)'));
fgBiblMarkers.addLayer(L.marker([4.85, 31.57], {alt:'Juba', locType:'point'}).bindTooltip('Juba (3)'));
fgBiblMarkers.addLayer(L.marker([39.46, -0.37], {alt:'Valencia', locType:'point'}).bindTooltip('Valencia (4)'));
fgBiblMarkers.addLayer(L.marker([36.20, 44.00], {alt:'Erbil', locType:'point'}).bindTooltip('Erbil (3)'));
fgBiblMarkers.addLayer(L.marker([36.74, 43.88], {alt:'Aqrah', locType:'point'}).bindTooltip('Aqrah (2)'));
fgBiblMarkers.addLayer(L.marker([35.46, 44.38], {alt:'Kirkuk', locType:'point'}).bindTooltip('Kirkuk (1)'));
fgBiblMarkers.addLayer(L.marker([38.68, 41.69], {alt:'Hasköy', locType:'point'}).bindTooltip('Hasköy (7)'));
fgBiblMarkers.addLayer(L.marker([21.38, 39.85], {alt:'Mecca', locType:'point'}).bindTooltip('Mecca (2)'));
fgBiblMarkers.addLayer(L.marker([34.01, 36.73], {alt:'Nabk', locType:'point'}).bindTooltip('Nabk (2)'));
fgBiblMarkers.addLayer(L.marker([34.88, 38.87], {alt:'Al-Sukhnah', locType:'point'}).bindTooltip('Al-Sukhnah (1)'));
fgBiblMarkers.addLayer(L.marker([32.09, 20.18], {alt:'Benghazi', locType:'point'}).bindTooltip('Benghazi (3)'));
fgBiblMarkers.addLayer(L.marker([32.04, 34.75], {alt:'Jaffa', locType:'point'}).bindTooltip('Jaffa (3)'));
fgBiblMarkers.addLayer(L.marker([32.79, 34.98], {alt:'Haifa', locType:'point'}).bindTooltip('Haifa (2)'));
fgBiblMarkers.addLayer(L.marker([16.95, 43.74], {alt:'Sa´dah', locType:'point'}).bindTooltip('Sa´dah (2)'));
fgBiblMarkers.addLayer(L.marker([36.86, 39.02], {alt:'Harran', locType:'point'}).bindTooltip('Harran (6)'));
fgBiblMarkers.addLayer(L.marker([37.16, 38.79], {alt:'Şanlıurfa', locType:'point'}).bindTooltip('Şanlıurfa (7)'));
fgBiblMarkers.addLayer(L.marker([36.36, 6.64], {alt:'Constantine', locType:'point'}).bindTooltip('Constantine (1)'));
fgBiblMarkers.addLayer(L.marker([34.01, -5.00], {alt:'Fez', locType:'point'}).bindTooltip('Fez (5)'));
fgBiblMarkers.addLayer(L.marker([32.30, -9.22], {alt:'Safi', locType:'point'}).bindTooltip('Safi (1)'));
fgBiblMarkers.addLayer(L.marker([32.92, 10.45], {alt:'Tataouine', locType:'point'}).bindTooltip('Tataouine (1)'));
fgBiblMarkers.addLayer(L.marker([41.64, -0.88], {alt:'Zaragoza', locType:'point'}).bindTooltip('Zaragoza (1)'));
fgBiblMarkers.addLayer(L.marker([35.76, -5.66], {alt:'Anjra', locType:'point'}).bindTooltip('Anjra (5)'));
fgBiblMarkers.addLayer(L.marker([35.88, -5.32], {alt:'Ceuta', locType:'point'}).bindTooltip('Ceuta (3)'));
fgBiblMarkers.addLayer(L.marker([35.16, -5.26], {alt:'Chefchaouen', locType:'point'}).bindTooltip('Chefchaouen (4)'));
fgBiblMarkers.addLayer(L.marker([31.50, -9.75], {alt:'Essaouira', locType:'point'}).bindTooltip('Essaouira (1)'));
fgBiblMarkers.addLayer(L.marker([34.78, -5.70], {alt:'Masmouda', locType:'point'}).bindTooltip('Masmouda (1)'));
fgBiblMarkers.addLayer(L.marker([37.17, -3.59], {alt:'Granada', locType:'point'}).bindTooltip('Granada (7)'));
fgBiblMarkers.addLayer(L.marker([35.00, -5.91], {alt:'Ksar el-Kebir', locType:'point'}).bindTooltip('Ksar el-Kebir (3)'));
fgBiblMarkers.addLayer(L.marker([35.17, -6.14], {alt:'Larache', locType:'point'}).bindTooltip('Larache (3)'));
fgBiblMarkers.addLayer(L.marker([32.83, -7.16], {alt:'Jbala', locType:'point'}).bindTooltip('Jbala (3)'));
fgBiblMarkers.addLayer(L.marker([33.91, 8.12], {alt:'Tozeur', locType:'point'}).bindTooltip('Tozeur (2)'));
fgBiblMarkers.addLayer(L.marker([33.87, -5.54], {alt:'Meknes', locType:'point'}).bindTooltip('Meknes (3)'));
fgBiblMarkers.addLayer(L.marker([31.94, 35.92], {alt:'Amman', locType:'point'}).bindTooltip('Amman (4)'));
fgBiblMarkers.addLayer(L.marker([36.45, 10.71], {alt:'Nabeul', locType:'point'}).bindTooltip('Nabeul (1)'));
fgBiblMarkers.addLayer(L.marker([31.95, 34.88], {alt:'Lod', locType:'point'}).bindTooltip('Lod (1)'));
fgBiblMarkers.addLayer(L.marker([15.22, 32.52], {alt:'Gebel Aulia', locType:'point'}).bindTooltip('Gebel Aulia (2)'));
fgBiblMarkers.addLayer(L.marker([15.50, 32.55], {alt:'Khartoum', locType:'point'}).bindTooltip('Khartoum (5)'));
fgBiblMarkers.addLayer(L.marker([32.06, 45.23], {alt:'Afak', locType:'point'}).bindTooltip('Afak (1)'));
fgBiblMarkers.addLayer(L.marker([30.50, 47.78], {alt:'Basra', locType:'point'}).bindTooltip('Basra (1)'));
fgBiblMarkers.addLayer(L.marker([32.47, 44.42], {alt:'Hillah', locType:'point'}).bindTooltip('Hillah (1)'));
fgBiblMarkers.addLayer(L.marker([35.58, -5.36], {alt:'Tétouan', locType:'point'}).bindTooltip('Tétouan (3)'));
fgBiblMarkers.addLayer(L.marker([33.23, 35.42], {alt:'Khirbet Selm', locType:'point'}).bindTooltip('Khirbet Selm (1)'));
fgBiblMarkers.addLayer(L.marker([29.69, -9.73], {alt:'Tiznit', locType:'point'}).bindTooltip('Tiznit (1)'));
fgBiblMarkers.addLayer(L.marker([28.43, -11.09], {alt:'Tan-Tan', locType:'point'}).bindTooltip('Tan-Tan (1)'));
fgBiblMarkers.addLayer(L.marker([31.70, 35.20], {alt:'Bethlehem', locType:'point'}).bindTooltip('Bethlehem (2)'));
fgBiblMarkers.addLayer(L.marker([34.68, -1.90], {alt:'Oujda', locType:'point'}).bindTooltip('Oujda (3)'));
fgBiblMarkers.addLayer(L.marker([26.23, 32.00], {alt:'El Balyana', locType:'point'}).bindTooltip('El Balyana (1)'));
fgBiblMarkers.addLayer(L.marker([15.07, 43.74], {alt:'Manakhah', locType:'point'}).bindTooltip('Manakhah (2)'));
fgBiblMarkers.addLayer(L.marker([34.25, 38.31], {alt:'Palmyra', locType:'point'}).bindTooltip('Palmyra (2)'));
fgBiblMarkers.addLayer(L.marker([34.84, 0.14], {alt:'Saïda', locType:'point'}).bindTooltip('Saïda (1)'));
fgBiblMarkers.addLayer(L.marker([34.88, -1.31], {alt:'Tlemcen', locType:'point'}).bindTooltip('Tlemcen (3)'));
fgBiblMarkers.addLayer(L.marker([36.56, 2.20], {alt:'Cherchell', locType:'point'}).bindTooltip('Cherchell (1)'));
fgBiblMarkers.addLayer(L.marker([35.32, 40.13], {alt:'Deir ez-Zor', locType:'point'}).bindTooltip('Deir ez-Zor (1)'));
fgBiblMarkers.addLayer(L.marker([36.81, 5.74], {alt:'Jijel', locType:'point'}).bindTooltip('Jijel (1)'));
fgBiblMarkers.addLayer(L.marker([34.43, 35.83], {alt:'Tripoli', locType:'point'}).bindTooltip('Tripoli (1)'));
fgBiblMarkers.addLayer(L.marker([34.254, -6.58], {alt:'Kenitra', locType:'point'}).bindTooltip('Kenitra (1)'));
fgBiblMarkers.addLayer(L.marker([34.25, -6.67], {alt:'Mehdia', locType:'point'}).bindTooltip('Mehdia (2)'));
fgBiblMarkers.addLayer(L.marker([34.25, -6.58], {alt:'Kenitra', locType:'point'}).bindTooltip('Kenitra (1)'));
fgBiblMarkers.addLayer(L.marker([35.81, 3.70], {alt:'Sidi Aïssa', locType:'point'}).bindTooltip('Sidi Aïssa (1)'));
fgBiblMarkers.addLayer(L.marker([33.87, -5.54], {alt:'Granada', locType:'point'}).bindTooltip('Granada (2)'));
fgBiblMarkers.addLayer(L.marker([34.01, 36.73], {alt:'Al-Nabek', locType:'point'}).bindTooltip('Al-Nabek (1)'));
fgBiblMarkers.addLayer(L.marker([37.92, 41.94], {alt:'Siirt', locType:'point'}).bindTooltip('Siirt (3)'));
fgBiblMarkers.addLayer(L.marker([33.971590, -6.84], {alt:'Rabat', locType:'point'}).bindTooltip('Rabat (1)'));
fgBiblMarkers.addLayer(L.marker([36.45, 43.33], {alt:'Bahzani', locType:'point'}).bindTooltip('Bahzani (1)'));
fgBiblMarkers.addLayer(L.marker([31.93, 34.87], {alt:'Ramla', locType:'point'}).bindTooltip('Ramla (1)'));
fgBiblMarkers.addLayer(L.marker([31.18, 35.70], {alt:'Al-Karak', locType:'point'}).bindTooltip('Al-Karak (1)'));
fgBiblMarkers.addLayer(L.marker([31.20, 29.91], {alt:'Alexandria', locType:'point'}).bindTooltip('Alexandria (2)'));
fgBiblMarkers.addLayer(L.marker([32.96, 35.49], {alt:'Safed', locType:'point'}).bindTooltip('Safed (1)'));
fgBiblMarkers.addLayer(L.marker([33.44, 8.92], {alt:'Zaafrane', locType:'point'}).bindTooltip('Zaafrane (1)'));
fgBiblMarkers.addLayer(L.marker([29.30, 30.84], {alt:'Faiyum', locType:'point'}).bindTooltip('Faiyum (1)'));
fgBiblMarkers.addLayer(L.marker([25.52, 29.05], {alt:'Ismant', locType:'point'}).bindTooltip('Ismant (1)'));
fgBiblMarkers.addLayer(L.marker([32.68, 35.32], {alt:'Iksal', locType:'point'}).bindTooltip('Iksal (1)'));
fgBiblMarkers.addLayer(L.marker([20.27, 41.44], {alt:'Bilad Ghamid', locType:'point'}).bindTooltip('Bilad Ghamid (1)'));
fgBiblMarkers.addLayer(L.marker([26.23, 50.03], {alt:'Dhahran', locType:'point'}).bindTooltip('Dhahran (1)'));
fgBiblMarkers.addLayer(L.marker([27.81, 30.90], {alt:'Abada', locType:'point'}).bindTooltip('Abada (2)'));
fgBiblMarkers.addLayer(L.marker([34.21, -3.99], {alt:'Taza', locType:'point'}).bindTooltip('Taza (1)'));
fgBiblMarkers.addLayer(L.marker([34.79, -5.56], {alt:'Ouazzane', locType:'point'}).bindTooltip('Ouazzane (1)'));
fgBiblMarkers.addLayer(L.marker([34.23, 37.23], {alt:'Al-Qaryatayn', locType:'point'}).bindTooltip('Al-Qaryatayn (1)'));
fgBiblMarkers.addLayer(L.marker([34.88, 38.87], {alt:'Al-Soukhna', locType:'point'}).bindTooltip('Al-Soukhna (1)'));
fgBiblMarkers.addLayer(L.marker([13.70, 44.73], {alt:'Dhale', locType:'point'}).bindTooltip('Dhale (1)'));
fgBiblMarkers.addLayer(L.marker([36.50, 1.31], {alt:'Ténès', locType:'point'}).bindTooltip('Ténès (1)'));
fgBiblMarkers.addLayer(L.marker([35.49, 43.23], {alt:'Al-Shirqat', locType:'point'}).bindTooltip('Al-Shirqat (1)'));
fgBiblMarkers.addLayer(L.marker([35.50, 11.04], {alt:'Mahdia', locType:'point'}).bindTooltip('Mahdia (1)'));
fgBiblMarkers.addLayer(L.marker([33.23, -8.50], {alt:'El Jadida', locType:'point'}).bindTooltip('El Jadida (1)'));
fgBiblMarkers.addLayer(L.marker([15.50, 32.55], {alt:'Khartum', locType:'point'}).bindTooltip('Khartum (1)'));
fgBiblMarkers.addLayer(L.marker([15.64, 32.48], {alt:'Omdurman', locType:'point'}).bindTooltip('Omdurman (1)'));
fgBiblMarkers.addLayer(L.marker([35.12, -4.32], {alt:'Jnanate', locType:'point'}).bindTooltip('Jnanate (1)'));
fgBiblMarkers.addLayer(L.marker([31.62, -7.98], {alt:'Marrakech', locType:'point'}).bindTooltip('Marrakech (1)'));
fgBiblMarkers.addLayer(L.marker([36.23, 38.01], {alt:'Al-Khafsah', locType:'point'}).bindTooltip('Al-Khafsah (1)'));
fgBiblMarkers.addLayer(L.marker([29.82, -5.72], {alt:'M´hamid', locType:'point'}).bindTooltip('M´hamid (1)'));
fgBiblMarkers.addLayer(L.marker([22.95, 57.29], {alt:'Bahla', locType:'point'}).bindTooltip('Bahla (1)'));
fgBiblMarkers.addLayer(L.marker([37.10, 40.93], {alt:'Amuda', locType:'point'}).bindTooltip('Amuda (1)'));
fgBiblMarkers.addLayer(L.marker([37.10, 40.93], {alt:'Amude', locType:'point'}).bindTooltip('Amude (1)'));
fgBiblMarkers.addLayer(L.marker([31.86, 35.25], {alt:'Abu Shusha', locType:'point'}).bindTooltip('Abu Shusha (1)'));
fgBiblMarkers.addLayer(L.marker([38.33, 41.42], {alt:'Sason', locType:'point'}).bindTooltip('Sason (1)'));
fgBiblMarkers.addLayer(L.marker([31.55, 48.18], {alt:'Dascht-e-Azadegan', locType:'point'}).bindTooltip('Dascht-e-Azadegan (1)'));
fgBiblMarkers.addLayer(L.marker([33.88, 10.09], {alt:'Gabès', locType:'point'}).bindTooltip('Gabès (1)'));
fgBiblMarkers.addLayer(L.marker([29.20, 25.51], {alt:'Siwa', locType:'point'}).bindTooltip('Siwa (1)'));
fgBiblMarkers.addLayer(L.marker([33.83, -4.83], {alt:'Sefrou', locType:'point'}).bindTooltip('Sefrou (1)'));
fgBiblMarkers.addLayer(L.marker([36.45, 6.25], {alt:'Mila', locType:'point'}).bindTooltip('Mila (1)'));
fgBiblMarkers.addLayer(L.marker([36.15, 10.34], {alt:'Takrouna', locType:'point'}).bindTooltip('Takrouna (1)'));
fgBiblMarkers.addLayer(L.marker([33.82, 36.50], {alt:'Jubb´adin', locType:'point'}).bindTooltip('Jubb´adin (1)'));
fgBiblMarkers.addLayer(L.marker([37.94, 42.01], {alt:'Tillo', locType:'point'}).bindTooltip('Tillo (4)'));
fgBiblMarkers.addLayer(L.marker([36.58, 36.17], {alt:'Iskenderun', locType:'point'}).bindTooltip('Iskenderun (1)'));
fgBiblMarkers.addLayer(L.marker([33.64, 42.82], {alt:'Hit', locType:'point'}).bindTooltip('Hit (1)'));
fgBiblMarkers.addLayer(L.marker([32.01, 34.78], {alt:'Holon', locType:'point'}).bindTooltip('Holon (1)'));
fgBiblMarkers.addLayer(L.marker([36.80, 42.09], {alt:'Rabia', locType:'point'}).bindTooltip('Rabia (1)'));
fgBiblMarkers.addLayer(L.marker([35.24, -3.93], {alt:'Al Hoceima', locType:'point'}).bindTooltip('Al Hoceima (1)'));
fgBiblMarkers.addLayer(L.marker([-1.31, 36.78], {alt:'Kibera', locType:'point'}).bindTooltip('Kibera (1)'));
fgBiblMarkers.addLayer(L.marker([13.57, 44.01], {alt:'Taiz', locType:'point'}).bindTooltip('Taiz (1)'));
fgBiblMarkers.addLayer(L.marker([23.44, 57.43], {alt:'Al-Ristaq', locType:'point'}).bindTooltip('Al-Ristaq (1)'));
fgBiblMarkers.addLayer(L.marker([26.26, 50.62], {alt:'Muharraq', locType:'point'}).bindTooltip('Muharraq (1)'));
fgBiblMarkers.addLayer(L.marker([26.57, 49.99], {alt:'Al-Qatif', locType:'point'}).bindTooltip('Al-Qatif (1)'));
fgBiblMarkers.addLayer(L.marker([23.96, 57.09], {alt:'Al-Khaburah', locType:'point'}).bindTooltip('Al-Khaburah (1)'));
fgBiblMarkers.addLayer(L.marker([34.61, 43.65], {alt:'Tikrit', locType:'point'}).bindTooltip('Tikrit (3)'));
fgBiblMarkers.addLayer(L.marker([33.87, 9.74], {alt:'El-Hamma', locType:'point'}).bindTooltip('El-Hamma (3)'));
fgBiblMarkers.addLayer(L.marker([34.39, 35.89], {alt:'Zgharta', locType:'point'}).bindTooltip('Zgharta (1)'));
fgBiblMarkers.addLayer(L.marker([21.28, 39.23], {alt:'Jeddah', locType:'point'}).bindTooltip('Jeddah (1)'));
fgBiblMarkers.addLayer(L.marker([34.03, -6.77], {alt:'Sale', locType:'point'}).bindTooltip('Sale (1)'));
fgBiblMarkers.addLayer(L.marker([31.35, 34.30], {alt:'Gaza', locType:'point'}).bindTooltip('Gaza (2)'));
fgBiblMarkers.addLayer(L.marker([36.19, 35.95], {alt:'Samandağ', locType:'point'}).bindTooltip('Samandağ (1)'));
}

function insertGeoTextbookMarkers() {
    setExplanation('Textbooks');
    /* ******************************** */
    /* Create with loc_reg_textbooks_001.xq */
    /* ******************************** */
    
fgBiblMarkers.addLayer(L.circle([22.36, 46.81], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Arabian Peninsula', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Arabian Peninsula (7)'));
fgBiblMarkers.addLayer(L.circle([26.57, 49.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Gulf', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Gulf (3)'));
fgBiblMarkers.addLayer(L.circle([31.46, -6.39], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Morocco', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Morocco (8)'));
fgBiblMarkers.addLayer(L.circle([28.79, 18.04], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Libya', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Libya (1)'));
fgBiblMarkers.addLayer(L.circle([16.31, 47.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Yemen', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Yemen (4)'));
fgBiblMarkers.addLayer(L.marker([12.78, 45.01], {alt:'Aden', locType:'point', biblType:'vt:Textbook', biblid:''}).bindTooltip('Aden (1)'));
fgBiblMarkers.addLayer(L.circle([27.39, 30.26], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Egypt', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Egypt (21)'));
fgBiblMarkers.addLayer(L.marker([30.04, 31.23], {alt:'Cairo', locType:'point', biblType:'vt:Textbook', biblid:''}).bindTooltip('Cairo (17)'));
fgBiblMarkers.addLayer(L.circle([32.93, 36.53], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syro-Palestine', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Syro-Palestine (14)'));
fgBiblMarkers.addLayer(L.circle([31.64, 45.33], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iraq', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Iraq (2)'));
fgBiblMarkers.addLayer(L.circle([35.14, 42.48], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mesopotamia', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Mesopotamia (2)'));
fgBiblMarkers.addLayer(L.circle([35.87, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Malta', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Malta (1)'));
fgBiblMarkers.addLayer(L.circle([31.53, 34.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Israel', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Israel (5)'));
fgBiblMarkers.addLayer(L.circle([31.89, 35.25], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Palestine', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Palestine (6)'));
fgBiblMarkers.addLayer(L.marker([31.76, 35.21], {alt:'Jerusalem', locType:'point', biblType:'vt:Textbook', biblid:''}).bindTooltip('Jerusalem (3)'));
fgBiblMarkers.addLayer(L.marker([33.51, 36.27], {alt:'Damascus', locType:'point', biblType:'vt:Textbook', biblid:''}).bindTooltip('Damascus (5)'));
fgBiblMarkers.addLayer(L.circle([34.61, 38.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syria', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Syria (8)'));
fgBiblMarkers.addLayer(L.circle([11.30, 17.86], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Chad', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Chad (1)'));
fgBiblMarkers.addLayer(L.circle([34.54, 3.30], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Algeria', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Algeria (1)'));
fgBiblMarkers.addLayer(L.marker([15.36, 44.19], {alt:'Sanaa', locType:'point', biblType:'vt:Textbook', biblid:''}).bindTooltip('Sanaa (2)'));
fgBiblMarkers.addLayer(L.circle([22.95, 46.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Saudi Arabia', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Saudi Arabia (1)'));
fgBiblMarkers.addLayer(L.circle([16.14, 30.29], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Sudan', locType:'region', biblType:'vt:Textbook', biblid:''}).bindTooltip('Sudan (1)'));

}

function insertGeoDictMarkers() {

    /* ********************************* */
    /* Create with loc_reg_dicts__002.xq */
    /* ********************************* */
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


    //fgBiblMarkers.addLayer(L.marker([30.04, 31.23], {alt:'Cairo', biblid:'watson_1992_0000'}).bindTooltip('Cairo'));
    //fgBiblMarkers.addLayer(L.marker([33.51, 36.27], { icon: myIcon, className: "leafIco", alt:'Damascus', biblid:'barthelemy_1935_1954_0000'}).bindTooltip('Damascus'));
    //fgBiblMarkers.addLayer(L.circle([34.03, 9.31], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Douz', biblid:'boris_1958_0000'}).bindTooltip('Douz'));
    
fgBiblMarkers.addLayer(L.circle([39.92, -3.02], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Andalusia', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Andalusia (3)'));
fgBiblMarkers.addLayer(L.circle([27.39, 30.26], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Egypt', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Egypt (7)'));
fgBiblMarkers.addLayer(L.marker([30.04, 31.23], {alt:'Cairo', locType:'point', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Cairo (9)'));
fgBiblMarkers.addLayer(L.circle([31.64, 45.33], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Iraq', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Iraq (3)'));
fgBiblMarkers.addLayer(L.circle([35.14, 42.48], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mesopotamia', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Mesopotamia (3)'));
fgBiblMarkers.addLayer(L.circle([31.46, -6.39], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Morocco', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Morocco (13)'));
fgBiblMarkers.addLayer(L.circle([11.12, 12.24], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Nigeria', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Nigeria (4)'));
fgBiblMarkers.addLayer(L.circle([32.93, 36.53], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syro-Palestine', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Syro-Palestine (5)'));
fgBiblMarkers.addLayer(L.marker([33.51, 36.27], {alt:'Damascus', locType:'point', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Damascus (4)'));
fgBiblMarkers.addLayer(L.circle([34.61, 38.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Syria', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Syria (4)'));
fgBiblMarkers.addLayer(L.marker([36.20, 37.13], {alt:'Aleppo', locType:'point', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Aleppo (3)'));
fgBiblMarkers.addLayer(L.circle([11.30, 17.86], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Chad', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Chad (1)'));
fgBiblMarkers.addLayer(L.circle([31.53, 34.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Israel', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Israel (2)'));
fgBiblMarkers.addLayer(L.circle([31.89, 35.25], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Palestine', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Palestine (3)'));
fgBiblMarkers.addLayer(L.circle([22.36, 46.81], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Arabian Peninsula', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Arabian Peninsula (6)'));
fgBiblMarkers.addLayer(L.circle([16.31, 47.34], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Yemen', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Yemen (5)'));
fgBiblMarkers.addLayer(L.circle([33.71, 35.66], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Lebanon', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Lebanon (2)'));
fgBiblMarkers.addLayer(L.marker([31.76, 35.21], {alt:'Jerusalem', locType:'point', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Jerusalem (2)'));
fgBiblMarkers.addLayer(L.circle([33.59, 9.37], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Tunisia', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Tunisia (2)'));
fgBiblMarkers.addLayer(L.circle([19.45, -13.83], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Mauritania', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Mauritania (2)'));
fgBiblMarkers.addLayer(L.marker([33.46, 9.02], {alt:'Douz', locType:'point', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Douz (1)'));
fgBiblMarkers.addLayer(L.circle([35.87, 14.44], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Malta', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Malta (2)'));
fgBiblMarkers.addLayer(L.circle([26.57, 49.55], {color: 'grey', weight:1, fillColor: 'grey', radius:90000, alt:'Gulf', locType:'region', biblType:'vt:Dictionary', biblid:''}).bindTooltip('Gulf (1)'));
}