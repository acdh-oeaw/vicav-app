/* ************************************************************************* */
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
3=[dictQuery,any=ktb,dc_tunico,open]

5=[biblQueryLauncher,open]
5=[createNewCrossDictQueryPanel,open]

n=[type, ( id | query), label, status]
n=[type, ( id | query), status]
 */
/* ************************************************************************* */

var inpSel = 0;
var ramz = "";
var usr = "";
var containerCount = 0;
var lastTextPanelID = '';
var panelIDs =[];
var globalPreservePanel = -1;

/*
To create a new Version
1. Rename vicav_rest variable
2. Rename vicav_00x.xqm
3. Rename function names in vicav_00x.xqm
4. rename "/vicav_00x/index.html" in index.html
 */
var charTable_tunis = '’,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_cairo = '’,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_damasc = '’,ʕ,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ǝ,ᵊ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_msa = 'ˀ,ˁ,ā,ḍ,ḏ,ē,ġ,ǧ,ḥ,ī,ḷ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ʔ';

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
    query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
    getFeature(e.layer.options.alt, e.layer.options.id, 'features_01.xslt');
}

function onSamplesMapClick(e) {
    getSample('', e.layer.options.id, 'sampletext_01.xslt');
}

function onDictMapClick(e) {
    //execSampleQuery('vicav_samples', e.layer.options.id, 'sampletext_01.xslt');
    if (e.layer.options.id == 'dict_tunis') {
        getText('TUNICO DICTIONARY', 'dictFrontPage_Tunis', 'vicavTexts.xslt');
    }
    if (e.layer.options.id == 'dict_damascus') {
        getText('DAMASCUS DICTIONARY', 'dictFrontPage_Damascus', 'vicavTexts.xslt');
    }
    if (e.layer.options.id == 'dict_cairo') {
        getText('CAIRO DICTIONARY', 'dictFrontPage_Cairo', 'vicavTexts.xslt');
    }
}

var mainMap = L.map('dvMainMap').setView([19.064, 24.544], 4);
L.tileLayer('https://api.mapbox.com/styles/v1/acetin/cjb22mkrf16qf2spyl3u1vee3/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYWNldGluIiwiYSI6ImNqYjIybG5xdTI4OWYyd285dmsydGFkZWQifQ.xG4sN5u8h-BoXaej6OjkXw', {
    maxZoom: 20,
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
    '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
    'Imagery © <a href="http://mapbox.com">Mapbox</a>'
}).addTo(mainMap);

mainMap.scrollWheelZoom.disable();

var fgBiblMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);
var fgProfileMarkers = L.featureGroup().addTo(mainMap).on("click", onProfilesMapClick);
var fgSampleMarkers = L.featureGroup().addTo(mainMap).on("click", onSamplesMapClick);
var fgFeatureMarkers = L.featureGroup().addTo(mainMap).on("click", onFeaturesMapClick);
var fgGeoDictMarkers = L.featureGroup().addTo(mainMap).on("click", onBiblMapClick);
var fgDictMarkers = L.featureGroup().addTo(mainMap).on("click", onDictMapClick);

/* ************************************************************************* */
/* *** General String functions ******************************************** */
/* ************************************************************************* */
function xmlToString(xmlData) {
    var xmlString;
    //IE
    if (window.ActiveXObject) {
        xmlString = xmlData.xml;
    }
    // code for Mozilla, Firefox, Opera, etc.
    else {
        xmlString = (new XMLSerializer()).serializeToString(xmlData);
    }
    return xmlString;
}

function countChar(s_, c_) {
    ilen = s_.length;
    var res = 0;
    for (i = 0; i != ilen; i++) {
        if (s_.charAt(i) == c_)
        res = res + 1;
    }
    return res;
}

function trim(s_) {
    var res = s_;
    while (res.charAt(0) == ' ') {
        res = res.substring(1, res.length);
    }
    
    while (res.charAt(res.length -1) == ' ') {
        res = res.substring(0, res.length -1);
    }
    return res;
}

function insert(str, index, value) {
    return str.substr(0, index) + value + str.substr(index);
}

/* ************************************************************************* */
/* ************************************************************************* */
/* ************************************************************************* */
function createCharTable(idSuffix_, chars_) {
    sarr = chars_.split(',');
    s = '';
    for (var i = 0, len = sarr.length; i < len; i++) {
        s = s + "   <div id='ct" + idSuffix_ + "' class='dvLetter'>" + sarr[i] + "</div>";
    }
    return "   <div class='dvCharTable' id='dvCharTable" + idSuffix_ + "'>" + s + "   </div>";
}

function createMatchString(s_) {
    res = "";
    s_ = trim(s_);
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
    $(obj_).css("cursor", "none");
    $(obj_).find("audio").css("left", "-500px");
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
        //console.log('replaceState changeURLMapParameter');
        //window.history.replaceState( {} , "", baseUrl + "#" + args);
    }
}

function changePanelVisibility(panel, type)   {
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
            var visState = 'open';
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
        //console.log('replaceState (changePanelVisibility 2)');
        window.history.replaceState({
        },
        "", baseUrl + "#" + args);
    } else if (type == 'close') {
        for (var i = 1; i < args.length; i++) {
            if (args[i].charAt(0) == pID) {
                args.splice(i, 1);
                break;
            }
        }
        args = args.join("&");
        //console.log('replaceState (changePanelVisibility 2)');
        //console.log('baseUrl + args: ' + baseUrl+"#"+args);
        window.history.replaceState({
        },
        "", baseUrl + "#" + args);
        panel.remove();
    }
}

function appendPanel(contents_, panelType_, secLabel_, contClass_, query_, teiLink_, locType_, snippetID_, pID_, pVisiblity_, pURL_) {
    var openPans = 0;
    var toBeClosed = -1;
    secLabel_ = secLabel_.replace(/%20/, ' ');
    contents_ = contents_.replace(/{query}/, query_);
    $('.content-panel').each(function () {
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
    if (teiLink_ == 'hasTeiLink') {
        switch (panelType_) {
            case 'profileQuery': teiLink_ = 'getProfile("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xsl")';
            break;
            case 'featureQuery': teiLink_ = 'getFeature("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xsl")';
            break;
            case 'sampleQuery': teiLink_ = 'getSample("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xsl")';
            break;
            case 'textQuery': teiLink_ = 'getText("' + secLabel_ + '", "' + snippetID_ + '", "tei_2_html__v004__gen.xsl")';
            break;
        }
    } else {
        teiLink_ = '';
    }
    
    if ((contents_.indexOf('<pre ') == -1) &&(teiLink_.length > 0)) {
        teiLink = "<a href='javascript:" + teiLink_ + "' class='aTEIButton'>TEI</a>";
    } else {
        teiLink = '';
    }
    contents_ = contents_.replace(/{teiLink}/, teiLink);
    
    /* ******************************************************/
    /* ********* Add panel definition to URL ****************/
    /* ******************************************************/
    if (! pID_) {
        var pID = $('.content-panel').last().data('pid') + 1;
        if (! pURL_) {
            var currentURL = window.location.toString();
            
            switch (panelType_) {
                case 'biblQuery':
                qry = query_.replace(",", "_");
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
            window.history.replaceState({
            },
            "", currentURL + "&" + argList);
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
        var htmlCont = panelType_ + ": " + secLabel_;
    }
    $(".initial-closed-panel").clone().removeClass('closed-panel initial-closed-panel').addClass(cssClass).attr("data-pid", pID).addClass(cssClass).attr("data-snippetID", snippetID_).appendTo(".panels-wrap").append(resCont).find(".chrome-title").html(htmlCont);
}

function setExplanation(s_) {
    document.getElementById("dvExplanations").innerHTML = s_;
}

function createBiblExplanationPanel() {
    getText('BIBLIOGRAPHY: Explanation', 'vicavExplanationBibliography', 'vicavTexts.xslt');
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

function createNewCrossDictQueryPanel(pID_, pVisiblity_, pURL_) {
    var jsText = "getText(&#39;TUNICO DICTIONARY&#39;, &#39;dictFrontPage_Tunis&#39;, &#39;vicavTexts.xslt&#39;)";
    
    var searchContainer =
    "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>" +
    "    <input class='form-control mr-sm-2' type='text' style='flex: 1;' placeholder='Search in dictionaries ...' aria-label='Search'>" +
    "    <button class='crossDictQueryBtn'>Query</button><br/>" +
    "</form>" +
    "<div class='selQueryType'>" +
    "   <input type='checkbox' id='cbCairo' class='checkbox' value='Cairo'><label class='checkboxLabel' for='cbCairo'>Cairo</label>" +
    "   <input type='checkbox' id='cbDamascus' class='checkbox' value='Damascus'><label class='checkboxLabel' for='cbDamascus'>Damascus</label>" +
    "   <input type='checkbox' id='cbTunis' class='checkbox' value='Tunis' checked='checked'><label class='checkboxLabel' for='cbTunis'>Tunis</label>" +
    "   <input type='checkbox' id='cbMSA' class='checkbox' value='MSA'><label class='checkboxLabel' for='cbMSA'>MSA</label>" +
    "</div>" +
    "<p>For details as to how to formulate meaningful dictionary " +
    "consult the <a class='aVicText' href='javascript:" + jsText + "'>examples of the TUNICO dictionary</a>.</p>";
    appendPanel(searchContainer, "crossDictQueryLauncher", "", "grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
}

function createNewDictQueryPanel(dict_, dictName_, idSuffix_, xslt_, chartable_, pID_, pVisiblity_, pURL_) {
    
    ob = $("#loading-wrapper" + idSuffix_).length;
    if (ob > 0) {
        alert('Dict query panel already exists');
    } else {
        
        var js = 'javascript:execDictQuery_tei("' + idSuffix_ + '")';
        var searchContainer =
        "   <div class='loading-wrapper' id='loading-wrapper" + idSuffix_ + "'><img class='imgPleaseWait' id='imgPleaseWait" + idSuffix_ + "' src='images/balls_in_circle.gif' alt='Query'></div>" +
        "   <div class='dict-search-wrapper'>" +
        "    <table class='tbHeader'>" +
        "        <tr><td><h2>" + dictName_ + "</h2></td><td class='tdTeiLink'><a href=\'" + js + "\' class='aTEIButton'>TEI</a></td></tr>" +
        "    </table>" +
        "   <table class='tbInputFrame'>" +
        "      <div class='form-inline mt-2 mt-md-0'>" +
        "        <div class='tdInputFrameMiddle' class='mr-sm-2' style='flex: 1;'><input type='text' id='inpDictQuery" + idSuffix_ + "' xslt='" + xslt_ + "' path='tunico' dict='" + dict_ + "' teiQuery='' value='' placeholder='Search in dictionary ...' class='form-control inpDictQuery" + idSuffix_ + "'/></div>" +
        "            <div id='dvFieldSelect" + idSuffix_ + "' class='dvFieldSelect'>" +
        "               <select id='slFieldSelect" + idSuffix_ + "' class='slFieldSelect form-control'>" +
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
        "                   <option value='etymSrc'>Words in etymologies</option>" +
        "               </select>" +
        "            </div>" +
        "        <div class='tdInputFrameRight my-2 my-sm-0'><span id='dictQuerybtn" + idSuffix_ + "' class='spTeiLink'><a class='aVicText'>Search</a></span></div>" +
        "      </div>" +
        "    </table>" +
        
        createCharTable(idSuffix_, chartable_) +
        
        "   <div id='dvWordSelector" + idSuffix_ + "' class='dvWordSelector'>" +
        "      <select class='form-control' size='10' id='slWordSelector" + idSuffix_ + "'>" +
        "         <option></option>" +
        "       </select>" +
        "   </div>" +
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
    //console.log(suffixes.length);
    for (var i = 0; i < suffixes.length; i++) {
        ob = document.getElementById('inpDictQuery' + suffixes[i]);
        if (ob == null) {
            switch (suffixes[i]) {
                case '_tunis':
                createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary', '_tunis', 'tunis_dict_001.xslt', charTable_tunis);
                break;
                
                case '_cairo':
                createNewDictQueryPanel('dc_arz_eng_007', 'Cairo Dictionary Query', '_cairo', 'cairo_dict_001.xslt', charTable_cairo);
                break;
                
                case '_damascus':
                createNewDictQueryPanel('dc_apc_eng_03', 'Damascus Dictionary Query', '_damascus', 'damascus_dict_001.xslt', charTable_damasc);
                break;
                
                case '_MSA':
                createNewDictQueryPanel('dc_ar_en', 'MSA Dictionary Query', '_MSA', 'fusha_dict_001.xslt', charTable_msa);
                break;
            }
            dealWithFieldSelectVisibility(query_, suffixes_[i]);
        }
        
        ob = document.getElementById('inpDictQuery' + suffixes[i]);
        if (ob) {
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
    //console.log('getText: ' + secLabel_ + " : " + snippetID_ + " : " + style_ + " : " + pID_ + " : " + pVisibility_ + " : " + pURL_);
    
    qs = './text?id=' + snippetID_ + '&xslt=' + style_;
    //console.log(qs);
    
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
                appendPanel(result, "textQuery", secLabel_, "grid-wrap", "", "hasTeiLink", "", snippetID_, pID_, pVisibility_, pURL_);
            }
        },
        error: function (error) {
            alert('Error: ' + error);
        }
    });
}

function getDBSnippet(s_, obj_) {
    splitPoint = s_.indexOf(":");
    //s = s_.split(':');
    
    //sHead = s[1];
    //sTail = s_.substring(s_.indexOf(":") + 1);
    sHead = s_.substr(0, splitPoint);
    sTail = s_.substring(splitPoint + 1);
    //console.log('head + tail: ' + sHead + ' : ' + sTail);
    s2 = sTail.split('/');
    snippetID = s2[0];
    secLabel = s2[1];
    
    switch (sHead) {
        case 'bibl':
        execBiblQuery(sTail);
        break;
        
        case 'mapMarkers':
        clearMarkerLayers();
        insertGeoRegMarkers(sTail, 'geo_reg');
        break;
        
        case 'sound':
        break;
        
        case 'flashcards':
        dict = s2[0];
        lesson = s2[1];
        type = s2[2];
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
        getFeature(secLabel, snippetID, 'features_01.xslt', '', '', '');
        break;
        
        case 'profile':
        getProfile(secLabel, snippetID, 'profile_01.xslt', '', '', '');
        break;
        
        case 'text':
        getText(secLabel, snippetID, 'vicavTexts.xslt', '', '', '');
        break;
    }
}

function execBiblQuery(query_, pID_, pVisiblity_, pURL_) {
    restQuery_ = query_.replace(/&/, ',');
    qs = './biblio?query=' + restQuery_ + '&xslt=biblio_01.xslt'
    
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
                appendPanel(result, "biblQuery", "", "grid-wrap", query_, "noTeiLink", "", "", pID_, pVisiblity_, pURL_);
            }
        },
        error: function (error) {
            alert('Error: ' + error);
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
        error: function (error) {
            alert('Error: ' + error);
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
        error: function (error) {
            alert('Error: ' + error);
        }
    });
}

function getFeature(caption_, snippetID_, style_, pID_, pVisiblity_, pURL_) {
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
        error: function (error) {
            alert('Error: ' + error);
        }
    });
}

function getProfile(caption_, snippetID_, style_, pID_, pVisiblity_, pURL_) {
    qs = './profile?coll=vicav_profiles&id=' + snippetID_ + '&xslt=' + style_;
    caption_ = caption_.replace("%20", " ");
    //console.log('getProfile: ' + caption_ + " : " + snippetID_ + " : " + style_ + " : " + pID_ + " : " + pVisiblity_ + " : " + pURL_);
    
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
        error: function (error) {
            alert('Error: ' + error);
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
        //console.log("query: " + query_);
        //console.log("idSuffix: " + idSuffix_);
        
        
        $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');
        $("#loading-wrapper" + idSuffix_).css('visibility', 'visible');
        
        xslt = $("#inpDictQuery" + idSuffix_).attr('xslt');
        teiQuery = query_.replace(xslt, "tei_2_html__v004__gen.xsl");
        $("#inpDictQuery" + idSuffix_).attr('teiQuery', teiQuery);
        
        $.ajax({
            url: query_,
            type: 'GET',
            dataType: 'html',
            cache: false,
            crossDomain: true,
            headers: {
                'autho': usr + ':' + ramz
            },
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
            error: function (error) {
                alert('Error: ' + error);
            }
        });
    }
}

function fillWordSelector(q_, dictInd_, idSuffix_) {
    $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');
    
    if (q_.length == 0) {
        q_ = '*';
    }
    sInd = $("#slFieldSelect" + idSuffix_).val();
    sUrl1 = './dict_index?dict=' + dictInd_ + '&ind=' + sInd + '&str=' + q_;
    $.ajax({
        url: sUrl1,
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
        error: function (error) {
            alert('Error: ' + error);
        }
    });
}

function getSuffixID(id_) {
    sid = id_;
    sids = sid.split('_');
    return sids[1];
}

function updateUrl_biblMarker(query_, scope_) {
    //console.log('query: ' + query_ + ' scope_: ' + scope_);
    currentURL = window.location.toString();
    if (currentURL.includes('#')) {
        var args_01 = currentURL.split('#');
        var args_02 = args_01[1].split('&');
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
        window.history.replaceState({
        },
        "", newUrl);
    }
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
        console.log('parts[0]: "' + parts[0] + '"');
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
    //console.log('replaceState (updateUrl_dictQuery)');
    window.history.replaceState({
    },
    "", args[0] + '#' + sout);
}

function execDictQuery(idSuffix_) {
    XSLTName = $("#inpDictQuery" + idSuffix_).attr('xslt');
    pathName = $("#inpDictQuery" + idSuffix_).attr('path');
    collName = $("#inpDictQuery" + idSuffix_).attr('dict');
    
    $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');
    $("#dvDictResults" + idSuffix_).html('');
    
    var sq = $("#inpDictQuery" + idSuffix_).val();
    var field = $("#slFieldSelect" + idSuffix_).val();
    if (sq.length > 0) {
        if (sq.indexOf("=") == -1) {
            sq = field + '="' + sq + '"';
        }
        sq = sq.replace(/&/g, ',');
        sQuery = './dict_api?query=' + sq + '&dict=' + collName + '&xslt=' + XSLTName;
        
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
        if (sq.length > 1) {
            if (sq.indexOf('=') == -1) {
                //console.log('fillWordSelector');
                
                fillWordSelector(sq, collName + '__ind', idSuffix_);
            }
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

function openDict_Damascus() {
    createNewDictQueryPanel('dc_apc_eng_03', 'Damascus Dictionary Query', '_damascus', 'damascus_dict_001.xslt', charTable_damasc);
}

function openDict_Tunis() {
    createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary Query', '_tunis', 'tunis_dict_001.xslt', charTable_tunis);
}

function openDict_Cairo() {
    createNewDictQueryPanel('dc_arz_eng_007', 'Cairo Dictionary Query', '_cairo', 'cairo_dict_001.xslt', charTable_cairo);
}

function openDict_MSA() {
    createNewDictQueryPanel('dc_ar_en', 'MSA Dictionary Query', '_MSA', 'fusha_dict_001.xslt', charTable_msa);
}

$(document).ready(
function () {
    $("#dvMainMapCont").show();
    //insertGeoRegMarkers('', 'geo');
    
    // Parse the given url parameters for views
    var currentURL = decodeURI(window.location.toString());
    //console.log(currentURL);
    
    if (currentURL.includes('#')) {
        var args = currentURL.split('#');
        
        var args = args[1].split('&');
        // Parse the map
        var mapArg = args[0].split('=');
        if (mapArg[0] == 'map') {
            //console.log('mapArg: ' + mapArg);
            
            //window["insert" + mapArg[1]]();
            $(".sub-nav-map-items .active").removeClass("active");
            
            pArgs = mapArg[1].replace(/((\[\s*)|(\s*\]))/g, "");
            pArgs = pArgs.split(',');
            console.log('pArgs[0]: ' + pArgs[0]);
            console.log('pArgs[1]: ' + pArgs[1]);
            switch (pArgs[1]) {
                case '_vicavDicts_':
                insertVicavDictMarkers();
                break;
                
                case '_features_':
                insertFeatureMarkers();
                break;
                
                case '_profiles_':
                insertProfileMarkers();
                break;
                
                case '_samples_':
                insertSampleMarkers();
                break;
                
                default:
                //console.log('pArgs[2]: ' + pArgs[2]);
                
                insertGeoRegMarkers(pArgs[1], pArgs[2]);
            }
            //$("#" + mapArg[1]).addClass("active");
        }
        
        // Parse the panels
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
                
                if (queryFunc == 'biblQuery') {
                    var query = pArgs[1];
                    var pVisiblity = pArgs[2];
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
                    getFeature(caption, snippetID, 'features_01.xslt', pID_, pVisiblity, true);
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
                        createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary Query', '_tunis', 'tunis_dict_001.xslt', charTable_tunis, pID_, pVisiblity, true);
                        query = './dict_api?query=' + query + '&dict=dc_tunico&xslt=tunis_dict_001.xslt';
                        execDictQuery_ajax(query, '_tunis');
                    }
                }
            },
            200 * i, i);
        }
    } else {
        //console.log('aaa');
        insertGeoRegMarkers('', 'geo');
        window.history.replaceState({
        },
        "", currentURL + "#map=[biblMarkers,,geo]&1=[textQuery,vicavMission,MISSION,open]");
        getText('MISSION', 'vicavMission', 'vicavTexts.xslt', 1, 'open', true);
    }
    
    /* *************************** */
    /* ****  Paratexts     ******* */
    /* *************************** */
    $("#liVicavMission").mousedown (function (event) {
        getText('MISSION', 'vicavMission', 'vicavTexts.xslt');
    });
    $("#liVicavContributors").mousedown (function (event) {
        getText('CONTRIBUTORS', 'vicavContributors', 'vicavTexts.xslt');
    });
    $("#liVicavLinguistics").mousedown (function (event) {
        getText('LINGUISTICS', 'vicavLinguistics', 'vicavTexts.xslt');
    });
    $("#liVicavDictionaries").mousedown (function (event) {
        getText('DICTIONARIES', 'vicavDictionaries', 'vicavTexts.xslt');
    });
    $("#liVicavTypesOfText").mousedown (function (event) {
        getText('TYPES OF TEXT/DATA', 'vicavTypesOfText', 'vicavTexts.xslt');
    });
    $("#liVicavDictionaryEncoding").mousedown (function (event) {
        getText('DICTIONARY ENCODING', 'vicavDictionaryEncoding', 'vicavTexts.xslt');
    });
    $("#liVicavVLE").mousedown (function (event) {
        getText('DICTIONARY ENCODING', 'vicavVLE', 'vicavTexts.xslt');
    });
    $("#liVicavLearningTextbookDamascus").mousedown (function (event) {
        getText('LEHRBUCH des SYRISCH-Arabischen', 'vicavLearning_tb_damascus', 'vicavTexts.xslt');
    });
    
    $("#liVicavLearning").mousedown (function (event) {
        getText('LEARNING MATERIALS', 'vicavLearning', 'vicavTexts.xslt');
    });
    $("#liVicavLearningSmartphone").mousedown (function (event) {
        getText('SMARTPHONE VOCABULARIES', 'vicavLearningSmartphone', 'vicavTexts.xslt');
    });
    $("#liVicavLearningPrograms").mousedown (function (event) {
        getText('PROGRAMS', 'vicavLearningPrograms', 'vicavTexts.xslt');
    });
    $("#liVicavLearningData").mousedown (function (event) {
        getText('VOCABULARIES (DATA)', 'vicavLearningData', 'vicavTexts.xslt');
    });
    $("#liVicavKeyboards").mousedown (function (event) {
        getText('KEYBOARD LAYOUTS', 'vicavKeyboards', 'vicavTexts.xslt');
    });
    
    
    $("#liVicavArabicTools").mousedown (function (event) {
        getText('ARABIC TOOLS', 'vicavArabicTools', 'vicavTexts.xslt');
    });
    $("#liVicavOverview_corpora_spoken").mousedown (function (event) {
        getText('ARABIC TOOLS (Corpora - Spoken Varieties)', 'vicavOverview_corpora_spoken', 'vicavTexts.xslt');
    });
    $("#liVicavOverview_corpora_msa").mousedown (function (event) {
        getText('ARABIC TOOLS (Corpora - MSA)', 'vicavOverview_corpora_msa', 'vicavTexts.xslt');
    });
    $("#liVicavOverview_special_corpora").mousedown (function (event) {
        getText('ARABIC TOOLS (Special Corpora)', 'vicavOverview_special_corpora', 'vicavTexts.xslt');
    });
    $("#liVicavOverview_corpora_historical_varieties").mousedown (function (event) {
        getText('ARABIC TOOLS (Corpora - Historical Varieties)', 'vicavOverview_corpora_historical_varieties', 'vicavTexts.xslt');
    });
    $("#liVicavOverview_dictionaries").mousedown (function (event) {
        getText('ARABIC TOOLS (Dictionaries)', 'vicavOverview_dictionaries', 'vicavTexts.xslt');
    });
    $("#liVicavOverview_nlp").mousedown (function (event) {
        getText('ARABIC TOOLS (Language Processing)', 'vicavOverview_nlp', 'vicavTexts.xslt');
    });
    $("#liVicavOverview_otherStuff").mousedown (function (event) {
        getText('Other Websites &amp; Projects', 'vicavOverview_otherStuff', 'vicavTexts.xslt');
    });
    
    
    /* *************************** */
    /* ****  Explanations  ******* */
    /* *************************** */
    $("#liProfilesExplanation").mousedown (function (event) {
        getText('BIBLIOGRAPHY: Explanation', 'vicavExplanationProfiles', 'vicavTexts.xslt');
    });
    $("#liBibliographyExplanation").mousedown (function (event) {
        createBiblExplanationPanel();
    });
    $("#liFeaturesExplanation").mousedown (function (event) {
        getText('LING. FEATURES: Explanation', 'vicavExplanationFeatures', 'vicavTexts.xslt');
    });
    $("#liSamplesExplanation").mousedown (function (event) {
        getText('SAMPLE TEXTS: Explanation', 'vicavExplanationSampleTexts', 'vicavTexts.xslt');
    });
    $("#liCorpusTextsExplanation").mousedown (function (event) {
        getText('TEXTS: Explanation', 'vicavExplanationCorpusTexts', 'vicavTexts.xslt');
    });
    
    /* *************************** */
    /* ****  CONTRIBUTIONS ******* */
    /* *************************** */
    $("#liVicavContributeBibliography").mousedown (function (event) {
        getText('BIBLIOGRAPHY: Contributing', 'vicavContributionBibliography', 'vicavTexts.xslt');
    });
    $("#liVicavContributeProfile").mousedown (function (event) {
        getText('PROFILES: Contributing', 'vicavContributeProfile', 'vicavTexts.xslt');
    });
    $("#liVicavContributeFeature").mousedown (function (event) {
        getText('FEATURES: Contributing', 'vicavContributeFeature', 'vicavTexts.xslt');
    });
    $("#liVicavContributeSampleText").mousedown (function (event) {
        getText('SAMPLE TEXTS: Contributing', 'vicavContributeSampleText', 'vicavTexts.xslt');
    });
    $("#liVicavContributeDictionary").mousedown (function (event) {
        getText('DICTIONARY/GLOSSARY: Contributing', 'vicavContributeDictionary', 'vicavTexts.xslt');
    });
    
    
    /* This is needed to collapse the menu after click in small screens */
    $('.navbar-nav li a').on('click', function () {
        if (! $(this).hasClass('dropdown-toggle')) {
            $('.navbar-collapse').collapse('hide');
        }
    });
    
    $("#liBiblNewQuery").mousedown (function (event) {
        createNewQueryBiblioPanel();
    });
    $("#liVicavCrossDictQuery").mousedown (function (event) {
        createNewCrossDictQueryPanel();
    });
    
    
    /* ********************************** */
    /* ****  DICTIONARY FRONTPAGE ******* */
    /* ********************************** */
    $("#liVicavDict_Tunis").mousedown (function (event) {
        getText('TUNICO DICTIONARY', 'dictFrontPage_Tunis', 'vicavTexts.xslt');
    });
    $("#liVicavDict_Damascus").mousedown (function (event) {
        getText('DAMASCUS DICTIONARY', 'dictFrontPage_Damascus', 'vicavTexts.xslt');
    });
    $("#liVicavDict_Cairo").mousedown (function (event) {
        getText('CAIRO DICTIONARY', 'dictFrontPage_Cairo', 'vicavTexts.xslt');
    });
    $("#liVicavDict_MSA").mousedown (function (event) {
        getText('MSA DICTIONARY', 'dictFrontPage_MSA', 'vicavTexts.xslt');
    });
    
    /* ******************************** */
    /* ****  DICTIONARY QUERIES ******* */
    /* ******************************** */
    $(document).on("click", '#liVicavDictQuery_Tunis', function () {
        openDict_Tunis();
    });
    $(document).on("click", '#liVicavDictQuery_Damascus', function () {
        openDict_Damascus();
    });
    $(document).on("click", '#liVicavDictQuery_Cairo', function () {
        openDict_Cairo();
    });
    $(document).on("click", '#liVicavDictQuery_MSA', function () {
        openDict_MSA();
    });
    
    /* ********************************************* */
    /* ****  DICTIONARY Auto Complete Events ******* */
    /* ********************************************* */
    $(document).on("keyup", '.inpDictQuery_tunis', function (event) {
        dealWithDictQueryKeyInput(event, '_tunis');
    });
    $(document).on("keyup", '.inpDictQuery_damascus', function (event) {
        dealWithDictQueryKeyInput(event, '_damascus');
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
    $("#liProfileAbudhabi").mousedown (function (event) {
        getProfile('Abu Dhabi', 'profile_abu_dhabi_01', 'profile_01.xslt');
    });
    $("#liProfileAhwaz").mousedown (function (event) {
        getProfile('Ahwaz', 'profile_ahwaz_01', 'profile_01.xslt');
    });
    $("#liProfileBaghdad").mousedown (function (event) {
        getProfile('Baghdad', 'profile_baghdad_01', 'profile_01.xslt');
    });
    $("#liProfileBenghazi").mousedown (function (event) {
        getProfile('Benghazi', 'profile_benghazi_01', 'profile_01.xslt');
    });
    $("#liProfileCairo").mousedown (function (event) {
        getProfile('Cairo', 'profile_cairo_01', 'profile_01.xslt');
    });
    $("#liProfileDamascus").mousedown (function (event) {
        getProfile('Damascus', 'profile_damascus_01', 'profile_01.xslt');
    });
    $("#liProfileDouz").mousedown (function (event) {
        getProfile('Douz', 'profile_douz_01', 'profile_01.xslt');
    });
    $("#liProfileKhabura").mousedown (function (event) {
        getProfile('al-Khabura', 'profile_khabura_01', 'profile_01.xslt');
    });
    $("#liProfileQamishli").mousedown (function (event) {
        getProfile('Qamishli', 'profile_qameshli_01', 'profile_01.xslt');
    });
    $("#liProfileRabat").mousedown (function (event) {
        getProfile('Rabat (Salé)', 'profile_sale_01', 'profile_01.xslt');
    });
    $("#liProfileSousse").mousedown (function (event) {
        getProfile('Sousse', 'profile_sousse_001', 'profile_01.xslt');
    });
    $("#liProfileSoukhne").mousedown (function (event) {
        getProfile('Soukhne', 'profile_soukhne_01', 'profile_01.xslt');
    });
    $("#liProfileTaizz").mousedown (function (event) {
        getProfile('Taizz', 'profile_taizz_01', 'profile_01.xslt');
    });
    $("#liProfileTiberias").mousedown (function (event) {
        getProfile('Tiberias', 'profile_tiberias_01', 'profile_01.xslt');
    });
    $("#liProfileTozeur").mousedown (function (event) {
        getProfile('Tozeur', 'profile_tozeur_01', 'profile_01.xslt');
    });
    $("#liProfileTunis").mousedown (function (event) {
        getProfile('Tunis', 'profile_tunis_01', 'profile_01.xslt');
    });
    $("#liProfileUrfa").mousedown (function (event) {
        getProfile('Şanlıurfa', 'profile_urfa_01', 'profile_01.xslt');
    });
    
    /* **************************************** */
    /* ****  Show map with locators *********** */
    /* **************************************** */
    $("#navBiblGeoMarkers,#subNavBiblGeoMarkers").mousedown (
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('', 'geo');
        adjustNav(this.id, "#subNavBiblGeoMarkers");
    });
    
    $("#navBiblRegMarkers,#subNavBiblRegMarkers").mousedown (
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('', 'reg');
        adjustNav(this.id, "#subNavBiblRegMarkers");
    });
    
    $("#navDictGeoRegMarkers,#subNavDictGeoRegMarkers,#navDictGeoRegMarkers1").mousedown (
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('vt:dictionary', 'geo_reg');
        adjustNav(this.id, "#subNavDictGeoRegMarkers");
    });
    
    $("#navTextbookGeoRegMarkers,#subNavTextbookGeoRegMarkers").mousedown (
    function (event) {
        clearMarkerLayers();
        insertGeoRegMarkers('vt:textbook', 'geo_reg');
        adjustNav(this.id, "#subNavTextbookGeoRegMarkers");
    });
    
    $("#navProfilesGeoRegMarkers,#subNavProfilesGeoRegMarkers").mousedown (function (event) {
        clearMarkerLayers();
        insertProfileMarkers();
        adjustNav(this.id, "#subNavProfilesGeoRegMarkers");
    });
    
    $("#navFeaturesGeoRegMarkers,#subNavFeaturesGeoRegMarkers").mousedown (function (event) {
        clearMarkerLayers();
        insertFeatureMarkers();
        adjustNav(this.id, "#subNavFeaturesGeoRegMarkers");
    });
    
    $("#navSamplesGeoRegMarkers,#subNavSamplesGeoRegMarkers").mousedown (function (event) {
        clearMarkerLayers();
        insertSampleMarkers();
        adjustNav(this.id, "#subNavSamplesGeoRegMarkers");
    });
    
    $("#navVicavDictMarkers,#subNavVicavDictMarkers").mousedown (function (event) {
        clearMarkerLayers();
        insertVicavDictMarkers();
        adjustNav(this.id, "#subNavVicavDictMarkers");
    });
    
    /* *********************** */
    /* ****  FEATURES ******** */
    /* *********************** */
    $("#liFeatureBaghdad").mousedown (function (event) {
        getFeature('Baghdad', 'ling_features_baghdad', 'features_01.xslt');
    });
    $("#liFeatureCairo").mousedown (function (event) {
        getFeature('Cairo', 'ling_features_cairo', 'features_01.xslt');
    });
    $("#liFeatureDamascus").mousedown (function (event) {
        getFeature('Damascus', 'ling_features_damascus', 'features_01.xslt');
    });
    $("#liFeatureDouz").mousedown (function (event) {
        getFeature('Douz', 'ling_features_douz', 'features_01.xslt');
    });
    $("#liFeatureTunis").mousedown (function (event) {
        getFeature('Tunis', 'ling_features_tunis', 'features_01.xslt');
    });
    $("#liFeatureUrfa").mousedown (function (event) {
        getFeature('Urfa', 'ling_features_urfa', 'features_01.xslt');
    });
    
    /* ********************** */
    /* ****  SAMPLES ******** */
    /* ********************** */
    $("#liSampleCairo").mousedown (function (event) {
        getSample('Cairo', 'cairo_sample_01', 'sampletext_01.xslt');
    });
    $("#liSampleBaghdad").mousedown (function (event) {
        getSample('Baghdad', 'baghdad_sample_01', 'sampletext_01.xslt');
    });
    $("#liSampleDamascus").mousedown (function (event) {
        getSample('Damascus', 'damascus_sample_01', 'sampletext_01.xslt');
    });
    $("#liSampleUrfa").mousedown (function (event) {
        getSample('Urfa', 'urfa_sample_01', 'sampletext_01.xslt');
    });
    $("#liSampleTunis").mousedown (function (event) {
        getSample('Tunis', 'tunis_sample_01', 'sampletext_01.xslt');
    });
    $("#liSampleDouz").mousedown (function (event) {
        getSample('Souz', 'douz_sample_01', 'sampletext_01.xslt');
    });
    $("#liSampleMSA").mousedown (function (event) {
        getSample('Modern Standard Arabic', 'msa_sample_01', 'sampletext_01.xslt');
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
    
    /* *******************************************************/
    /* ********* WORD SELECTOR *******************************/
    /* *******************************************************/
    
    $("[id^=id_opt]").click (
    function (event) {
    });
    
    $(document).on("keyup", '[id^=slWordSelect]',
    function (event) {
        suf = getSuffixID($(this).attr('id'));
        
        inpID = '#inpDictQuery_' + suf;
        $(inpID).val($("#slWordSelector_" + suf + " option:selected").text());
    });
    
    $(document).on("keydown", '[id^=slWordSelect]',
    function (event) {
        suf = getSuffixID($(this).attr('id'));
        inpID = 'inpDictQuery_' + suf;
        
        if (event.which == 13) {
            $('#' + inpID).val($("#slWordSelector_" + suf + " option:selected").text());
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
        var s1 = $('#' + inpID).val();
        var s2 = $(this).text();
        var s = insert(s1, inpSel, s2);
        $('#' + inpID).val(s);
        inpSel += 1;
        document.getElementById(inpID).selectionStart = inpSel + 1;
        var sq = $("#" + inpID).val();
        collName = $("#" + inpID).attr('dict');
        fillWordSelector(sq, collName + '__ind', '_' + suf);
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
            },
            2000);
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
            
            if (document.getElementById("cbDamascus").checked == true) {
                autoDictQuery('_damascus', query, sField);
            }
            
            if (document.getElementById("cbTunis").checked == true) {
                autoDictQuery('_tunis', query, sField);
            }
            
            if (document.getElementById("cbCairo").checked == true) {
                autoDictQuery('_cairo', query, sField);
            }
            
            if (document.getElementById("cbMSA").checked == true) {
                autoDictQuery('_MSA', query, sField);
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
    uri = 'https://cs.acdh.oeaw.ac.at/modules/fcs-aggregator/switch.php?version=1.2&operation=searchRetrieve&query=unit=' +
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