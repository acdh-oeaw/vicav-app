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
 
var inpSel = 0;         
var ramz = "";
var usr = "";
var containerCount = 0;
var lastTextPanelID = '';
var panelIDs = [];
var vicav_rest = 'vicav';
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
  /*Should look like: getProfile__('Baghdad', 'profile_baghdad_01', 'profile_01.xslt'); */
  getProfile__(e.layer.options.alt, e.layer.options.id, 'profile_01.xslt');
}
   
function onFeaturesMapClick(e) {
  query = e.latlng.lat.toFixed(2) + '.*' + e.latlng.lng.toFixed(2);
  getFeature_(e.layer.options.alt, e.layer.options.id, 'features_01.xslt');
  
}  

function onSamplesMapClick(e) {
  getSample_('vicav_samples', e.layer.options.id, 'sampletext_01.xslt');
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
    
//mainMap.scrollWheelZoom.disable();

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
  if (window.ActiveXObject){
    xmlString = xmlData.xml;
  }
  // code for Mozilla, Firefox, Opera, etc.
  else{
    xmlString = (new XMLSerializer()).serializeToString(xmlData);
  }
  return xmlString;
}        

function countChar(s_, c_) {
   ilen = s_.length;
   var res = 0;
   for (i=0; i!=ilen; i++) {
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

  while (res.charAt(res.length-1) == ' ') {
     res = res.substring(0, res.length-1);
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
      (s_.indexOf('+') > -1) 
     ) {
    //next line is necessary for IE
    s_ = encodeURIComponent(s_);
    res = 'matches(., "' + s_ + '")';                          
  } else {
    s_ = encodeURIComponent(s_);
    res = '.="' + s_ + '"';
  }
  return res;
}


function initUser() {
    ramz = $("#pw1").val();
    ramz = $.sha256(ramz).toUpperCase();
    usr = $("#usr1").val();         
}

function panelsBack() {
   for(var i = 0; i < sarray.length; i++) {
   }
}

function addID(id_) {
    panelIDs.push(id_);
    document.getElementById("dvOpenPanels").innerHTML = panelIDs.toString();
}

function changeURLMapParameter(newParameter) {
  var currentURL = window.location.toString();
  if (currentURL.includes('?')) {
    var args = currentURL.split('?');
    var baseUrl = args[0];
    var args = args[1].split('&');
    // Parse the map
    var mapArg = args[0].split('=');
    if (mapArg[0] == 'map') {
      args[0] = 'map='+newParameter;
    }
    args = args.join("&");
    window.history.replaceState( {} , "", baseUrl+"?"+args);
  }
}

function changePanelVisibility(panel, type) {

  var pID = panel.data('pid');
  var currentURL = window.location.toString();
  var args = currentURL.split('?');
  var baseUrl = args[0];
  var args = args[1].split('&');

  if (type == 'minimize' ||	type == 'maximize') {
    if (type == 'minimize') {
      var visState = 'closed';
      panel.removeClass('open-panel');
      panel.addClass('closed-panel');
    } else {
      var visState = 'open';
      panel.removeClass('closed-panel');
      panel.addClass('open-panel');
    }
    for (var i = 1; i < args.length; i++) {
      if (args[i].charAt(0) == pID) {
        var pArgs = args[i].split('=');
        pArgs = pArgs[1].replace(/((\[\s*)|(\s*\]))/g,"");
        pArgs = pArgs.split(',');
        pArgs.pop();
        pArgs.push(visState);
        pArgs = "[" + pArgs.join(",") + "]";
        args[i] = pID+"="+pArgs;
        break;
      }
    }
    args = args.join("&");
    window.history.replaceState( {} , "", baseUrl+"?"+args);
  } else if (type == 'close') {
    for (var i = 1; i < args.length; i++) {
      if (args[i].charAt(0) == pID) {
        args.splice(i, 1);
        break;
      }
    }
    args = args.join("&");
    window.history.replaceState( {} , "", baseUrl+"?"+args);
    panel.remove();
  }

}


function appendToPanel(result_, windowType_, windowVar_, contClass_, query_, teiLink_, locType_, pID_, pVisiblity_, pURL_) {
  var openPans = 0;
  result_ = result_.replace(/{query}/, query_);
  $('.content-panel').each(function(){
    var panelID = $(this).data('pid');
    if ($(this).hasClass("open-panel")) {
      openPans += 1;
    }
  });
  if (openPans > 2 && !pURL_) {
    var firstOpenPan = $(".open-panel").first();
    changePanelVisibility(firstOpenPan, 'minimize')
  }
  
  var teiLink = '';
  if ((result_.indexOf('<pre ') == -1)&&(teiLink_.length > 0)) {
    teiLink = "<a href='javascript:" + teiLink_ + "' class='aTEIButton'>TEI</a>";
  } else { teiLink = ''; }
  result_ = result_.replace(/{teiLink}/, teiLink);

  // Add view to URL
  if (!pID_) {
    var pID = $('.content-panel').last().data('pid') + 1;
    if (!pURL_) {
      var currentURL = window.location.toString();
      var argList = pID+"=["+windowType_+","+windowVar_+",";
      if (locType_) { argList = argList + locType_+","; }
      argList = argList + "open]";
      window.history.replaceState( {} , "", currentURL+"&"+argList);
    }
  } else {
    var pID = pID_;
  }

  if (pURL_) {
    var cssClass = pVisiblity_+"-panel";
  } else {
    var cssClass = "open-panel";
  }

  var resCont = "<div class='" + contClass_ + "'>" + result_ + "</div>";  
  if (windowVar_.length == 0) { var htmlCont = windowType_; } else {var htmlCont = windowType_ +": "+ windowVar_;}   
  $(".initial-closed-panel").clone().removeClass('closed-panel initial-closed-panel').addClass(cssClass).attr("data-pid",pID).appendTo( ".panels-wrap" ).append(resCont).find(".chrome-title").html(htmlCont);

}

function setExplanation(s_) {
    document.getElementById("dvExplanations").innerHTML = s_;    
}

function createBiblExplanationPanel() {
   execTextQuery('vicavExplanationBibliography', 'BIBLIOGRAPHY: Explanation', 'vicavTexts.xslt');    
}

function createNewQueryBiblioPanel() {
   
    var searchContainer = "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>"+
                "   <input class='form-control mr-sm-2' type='text' style='flex: 1;' placeholder='Search in bibliographies ...' aria-label='Search'>" + 
                "   <button class='newBiblQueryBtn'>Query</button>" +
                "'</form><br/>" + 
                "<p>For details as to how to formulate queries <a class='aVicText' href='javascript:createBiblExplanationPanel()'>click here</a>.</p>";
    appendToPanel(searchContainer, "QUERY BIBLIOGRAPHY", "", "grid-wrap", '', '');
}


function createNewDictQueryPanel(dict_, dictName_, idSuffix_, xslt_, chartable_, pID_, pVisiblity_, pURL_) {

  ob = $("#loading-wrapper" + idSuffix_).length;
  if (ob > 0) {
      alert('Dict query panel already exists');
  } else {
    
    var js = 'javascript:execDictQuery_tei("' + idSuffix_ + '")';
    var searchContainer =    
        //"<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>"+
        "   <div class='loading-wrapper' id='loading-wrapper" + idSuffix_ + "'><img class='imgPleaseWait' id='imgPleaseWait" + idSuffix_ + "' src='images/balls_in_circle.gif' alt='Query'></div>"+
        "   <div class='dict-search-wrapper'>"+
        "    <table class='tbHeader'>"+
        "        <tr><td><h2>" + dictName_ + "</h2></td><td class='tdTeiLink'><a href=\'" + js + "\' class='aTEIButton'>TEI</a></td></tr>"+                                                                              
        "    </table>"+    
        /*"   <div class='dict-heading' id='dv_" + dict_ + "'>" + dictName_ + "</div>"+*/
        "   <table class='tbInputFrame'>" + 
        "      <div class='form-inline mt-2 mt-md-0'>"+
        "        <div class='tdInputFrameMiddle' class='mr-sm-2' style='flex: 1;'><input type='text' id='inpDictQuery" + idSuffix_ + "' xslt='" + xslt_ + "' path='tunico' dict='" + dict_ + "' teiQuery='' value='' placeholder='Search in dictionary ...' class='form-control inpDictQuery" + idSuffix_ + "'/></div>"+
        "            <div id='dvFieldSelect" + idSuffix_ + "' class='dvFieldSelect'>"+                  
        "               <select id='slFieldSelect" + idSuffix_ + "' class='slFieldSelect form-control'>"+
        "                   <option value='any'>Any field</option>"+
        "                   <option value='lem'>Arabic lemma</option>"+
        "                   <option value='infl'>Arabic (infl.)</option>"+
        "                   <option value='en'>Trans. (English)</option>"+
        "                   <option value='de'>Trans. (German)</option>"+
        "                   <option value='fr'>Trans. (French)</option>"+
        "                   <option value='pos'>POS</option>"+
        "                   <option value='root'>Roots</option>"+
        "                   <option value='subc'>subc</option>"+
        "                   <option value='etymLang'>Lang. in etymologies</option>"+
        "                   <option value='etymSrc'>Words in etymologies</option>"+
        "               </select>"+
        "            </div>"+  
        "        <div class='tdInputFrameRight my-2 my-sm-0'><span id='newDictQuerybtn" + idSuffix_ + "' class='spTeiLink'><a class='aVicText'>Search</a></span></div>"+
        "      </div>"+
        "    </table>"+
       
        createCharTable(idSuffix_, chartable_) +      
         
        "   <div id='dvWordSelector" + idSuffix_ + "' class='dvWordSelector'>"+
        "      <select class='form-control' size='10' id='slWordSelector" + idSuffix_ + "'>"+
        "         <option></option>"+
        "       </select>"+
        "   </div>"+
        "   </div>"+
        "   <div id='dvDictResults" + idSuffix_ + "' class='dvDictResults'></div>"+
        "";
    
        //"</form>";
     
        appendToPanel(searchContainer, 'DictQueryPanel', dict_, "grid-wrap dict-grid-wrap", '', '', '', pID_, pVisiblity_, pURL_);
   }
}

/* *************************************************************************** */ 
/* ** This func is used by the examples of the explanation texts (vicav_texts) */ 
/* *************************************************************************** */ 
function autoDictQuery(idSuffix_, query_, field_) {
 
    ob = document.getElementById('inpDictQuery' + idSuffix_);
    if (ob==null) {
      createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary', '_tunis', 'tunis_dict_001.xslt', charTable_tunis);           
    }
    
    ob = document.getElementById('inpDictQuery' + idSuffix_);
    if (ob) {
        $('#' + 'inpDictQuery' + idSuffix_).val(query_);        
        $('#slFieldSelect' + idSuffix_).val(field_).change();
        execDictQuery(idSuffix_);
    } 
}

function delElement(id_) {
    $(id_).remove();
}
         
function hideElement(id_) {
    $(id_).hide();
}
         
function execTextQuery(id_, secLabel_, style_, pID_, pVisiblity_, pURL_) {
    qs = '/' + vicav_rest + '/text?id=' + id_ + '&xslt=' + style_;
   
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
          teiLink = 'execTextQuery("' + id_ + '", "' + secLabel_ + '", "tei_2_html__v004__gen.xsl")';
          appendToPanel(result, "Text", secLabel_, "grid-wrap", '', teiLink, '', pID_, pVisiblity_, pURL_);
        }
     },
     error: function (error) { alert('Error: ' + error); }                           
  });
}

function execBiblQuery(query_, locType_, pID_, pVisiblity_, pURL_) {
   restQuery_ = query_.replace(/&/, ',');
   qs = '/' + vicav_rest + '/biblio?query=' + restQuery_ + '&xslt=biblio_01.xslt'
   
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
          appendToPanel(result, "Bibl. Query", '', "grid-wrap", query_, '', '', pID_, pVisiblity_, pURL_);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });             
}

 
function getSample_(coll_, id_, style_, pID_, pVisiblity_, pURL_) {
  id_ = id_.replace(/sampleText:/, '');
  qs = '/' + vicav_rest + '/sample?coll=' + coll_ + '&id=' + id_ + '&xslt=' + style_;
   
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
          /*console.log(result);*/ 
          teiLink = 'getSample_("' + coll_ + '", "' + id_ + '", "tei_2_html__v004__gen.xsl")';
          appendToPanel(result, "Sample", id_, "grid-wrap", '', teiLink, '',  pID_, pVisiblity_, pURL_);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });
}

function getFeature_(caption_, id_, style_, pID_, pVisiblity_, pURL_) {         
  qs = '/' + vicav_rest + '/profile?coll=vicav_lingfeatures&id=' + id_ + '&xslt=' + style_;
  
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
            teiLink = 'getFeature_("' + caption_ + '", "' + id_ + '", "tei_2_html__v004__gen.xsl")';
            appendToPanel(result, "getFeature", id_, "grid-wrap", '', teiLink, '',  pID_, pVisiblity_, pURL_);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });             
}

function getProfile__(caption_, id_, style_,  pID_, pVisiblity_, pURL_) {
  qs = '/' + vicav_rest + '/profile?coll=vicav_profiles&id=' + id_ + '&xslt=' + style_;
            
  $.ajax({
     url: qs,
     type: 'GET',
     dataType: 'html',
     cache: false,
     crossDomain: true,
     contentType: 'application/html; ',
     success: function (result) {
        //console.log(result);
        if (result.includes('error type="user authentication"')) {
            alert('Error: authentication did not work');                  
        } else {
          teiLink = 'getProfile__("' + caption_ + '", "' + id_ + '", "tei_2_html__v004__gen.xsl")';
          appendToPanel(result, "getProfile", id_, "grid-wrap", '', teiLink, '',  pID_, pVisiblity_, pURL_);
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
           headers: {'autho': usr + ':' + ramz},
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

    if (q_.length == 0) { q_ = '*'; }
    sInd = $("#slFieldSelect" + idSuffix_).val();
    sUrl1 = '/' + vicav_rest + '/dict_index/?dict=' + dictInd_ + '&ind=' + sInd + '&str=' + q_;
    $.ajax({
    url: sUrl1,
            type: 'GET',
            dataType: 'html',
               contentType: 'application/html; charset=utf-8',
               success: function(result) {
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

function getSufixID(id_) {
    sid = id_;
    sids = sid.split('_');
    return sids[1];
}


function execDictQuery(idSuffix_) {
    XSLTName = $("#inpDictQuery" + idSuffix_).attr('xslt'); 
    pathName = $("#inpDictQuery" + idSuffix_).attr('path');
    collName = $("#inpDictQuery" + idSuffix_).attr('dict');

    //$("#dvCharTable" + idSuffix_).hide();
    $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');
    $("#dvDictResults" + idSuffix_).html('');
         
    var sq = $("#inpDictQuery" + idSuffix_).val();
    var field = $("#slFieldSelect" + idSuffix_).val();
    if (sq.length > 0) {
        if (sq.indexOf("=") == -1) {
           sq = field + '="' + sq + '"';
        }
        sq = sq.replace(/&/g, ',');
        sQuery = '/' + vicav_rest +  '/dict_api?query=' + sq + '&dict=' + collName + '&xslt=' + XSLTName;
                 
        if (sQuery.length > 0) {        
           execDictQuery_ajax(sQuery, idSuffix_);    
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

function dealWithDictQueryKeyInput(event_, idSuffix_) {
   collName = $("#inpDictQuery" + idSuffix_).attr('dict');
             
   if ( event_.which == 13 ) {
      execDictQuery(idSuffix_);
      
    } else if ( event_.which == 40 )
      /* Arrow Down */
    { 
       $("#slWordSelector" + idSuffix_).focus();
       $("#slWordSelector" + idSuffix_ + " option:first").attr('selected','selected');                                                      
    } else {
       $("#dvCharTable" + idSuffix_).show();
       var sq = $("#inpDictQuery" + idSuffix_).val();

       if (sq.indexOf('=') > -1) {
         $('#dvFieldSelect' + idSuffix_).hide();
      } else {
        $('#dvFieldSelect' + idSuffix_).show();
      }
                
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
  if (activateID_.indexOf('sub') !== -1) { $(activateID_).addClass("active"); }
  changeURLMapParameter(id_);    
}

$(document).ready(
    
   function() {      
       $("#dvMainMapCont").show();      
       insertGeoRegMarkers('', 'geo');

       // Parse the given url parameters for views
       var currentURL = window.location.toString();
       if (currentURL.includes('?')) {
         var args = currentURL.split('?');
         var args = args[1].split('&');
         // Parse the map
         var mapArg = args[0].split('=');
         if (mapArg[0] == 'map') {
           clearMarkerLayers();
           //window["insert" + mapArg[1]]();           
           $(".sub-nav-map-items .active").removeClass("active");
           $("#" + mapArg[1]).addClass("active");
         }
         // Parse the panels
         for (var i = 1; i < args.length; i++) {
              setTimeout(function(y) {
                  var pArgs = args[y].split('=');
                  var pID_ = pArgs[0];
                  pArgs = pArgs[1].replace(/((\[\s*)|(\s*\]))/g,"");
                  pArgs = pArgs.split(',');
                  var queryFunc = pArgs[0];
                  if (queryFunc == 'BiblQuery') {
                    var loc_ = pArgs[1];
                    var locType_ = pArgs[2];
                    var pVisiblity_ = pArgs[3];
                    execBiblQuery('', loc_, '', locType_, pID_, pVisiblity_, true);
                  } else if (queryFunc == 'TextQuery') {
                    var id_ = pArgs[1];
                    var pVisiblity_ = pArgs[2];
                    execTextQuery(id_, 'HEADING', 'vicavTexts.xslt', pID_, pVisiblity_, true);
                  } else if (queryFunc == 'getProfile') {
                    var id_ = pArgs[1];
                    var pVisiblity_ = pArgs[2];
                    getProfile__('', id_, 'profile_01.xslt', pID_, pVisiblity_, true);
                  } else if (queryFunc == 'getFeature') {
                    var id_ = pArgs[1];
                    var pVisiblity_ = pArgs[2];
                    getFeature_('', id_, 'features_01.xslt', pID_, pVisiblity_, true);
                  } else if (queryFunc == 'SampleQuery') {
                    var id_ = pArgs[1];
                    var pVisiblity_ = pArgs[2];
                    getSample_('vicav_samples', id_, 'sampletext_01.xslt', pID_, pVisiblity_, true);
                  } else if (queryFunc == 'DictQueryPanel') {
                    var id_ = pArgs[1];
                    var pVisiblity_ = pArgs[2];
                    if (id_ == 'dc_tunico') {
                      createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary Query', '_tunis', 'tunis_dict_001.xslt', charTable_tunis, pID_, pVisiblity_, true);
                    } else if (id_ == 'dc_apc_eng_03') {
                      createNewDictQueryPanel('dc_apc_eng_03', 'Damascus Dictionary Query', '_damascus', 'damascus_dict_001.xslt', charTable_damasc, pID_, pVisiblity_, true);
                    } else if (id_ == 'dc_arz_eng_007') {
                      createNewDictQueryPanel('dc_arz_eng_007', 'Cairo Dictionary Query', '_cairo', 'cairo_dict_001.xslt', charTable_cairo, pID_, pVisiblity_, true);
                    } else if (id_ == 'dc_ar_en') {
                      createNewDictQueryPanel('dc_ar_en', 'MSA Dictionary Query', '_MSA', 'fusha_dict_001.xslt', charTable_msa, pID_, pVisiblity_, true);
                    }
                  }
              }, 200 * i, i);
         }
       } else {
         window.history.replaceState( {} , "", currentURL+"?map=BiblGeoMarkers&1=[TextQuery,vicavMission,open]");
         execTextQuery('vicavMission', 'MISSION', 'vicavTexts.xslt', 1, 'open', true);
       }

       /* *************************** */
       /* ****  Paratexts     ******* */
       /* *************************** */       
       $("#liVicavMission").mousedown ( function(event) { execTextQuery('vicavMission', 'MISSION', 'vicavTexts.xslt'); } );              
       $("#liVicavContributors").mousedown ( function(event) { execTextQuery('vicavContributors', 'CONTRIBUTORS', 'vicavTexts.xslt'); } );              
       $("#liVicavLinguistics").mousedown ( function(event) { execTextQuery('vicavLinguistics', 'LINGUISTICS', 'vicavTexts.xslt'); } );              
       $("#liVicavDictionaries").mousedown ( function(event) { execTextQuery('vicavDictionaries', 'DICTIONARIES', 'vicavTexts.xslt'); } );
       $("#liVicavTypesOfText").mousedown ( function(event) { execTextQuery('vicavTypesOfText', 'TYPES OF TEXT/DATA', 'vicavTexts.xslt'); } );
       $("#liVicavDictionaryEncoding").mousedown ( function(event) { execTextQuery('vicavDictionaryEncoding', 'DICTIONARY ENCODING', 'vicavTexts.xslt'); } );       
       $("#liVicavVLE").mousedown ( function(event) { execTextQuery('vicavVLE', 'DICTIONARY ENCODING', 'vicavTexts.xslt'); } );       
       $("#liVicavLearning").mousedown ( function(event) { execTextQuery('vicavLearning', 'LEARNING MATERIALS', 'vicavTexts.xslt'); } );
       $("#liVicavLearningSmartphone").mousedown ( function(event) { execTextQuery('vicavLearningSmartphone', 'SMARTPHONE VOCABULARIES', 'vicavTexts.xslt'); } );
       $("#liVicavLearningPrograms").mousedown ( function(event) { execTextQuery('vicavLearningPrograms', 'PROGRAMS', 'vicavTexts.xslt'); } );
       $("#liVicavLearningData").mousedown ( function(event) { execTextQuery('vicavLearningData', 'VOCABULARIES (DATA)', 'vicavTexts.xslt'); } );
       $("#liVicavKeyboards").mousedown ( function(event) { execTextQuery('vicavKeyboards', 'KEYBOARD LAYOUTS', 'vicavTexts.xslt'); } );
       
       
       $("#liVicavArabicTools").mousedown ( function(event) { execTextQuery('vicavArabicTools', 'ARABIC TOOLS', 'vicavTexts.xslt'); } );
       $("#liVicavOverview_corpora_spoken").mousedown ( function(event) { execTextQuery('vicavOverview_corpora_spoken', 'ARABIC TOOLS (Corpora - Spoken Varieties)', 'vicavTexts.xslt'); } );
       $("#liVicavOverview_corpora_msa").mousedown ( function(event) { execTextQuery('vicavOverview_corpora_msa', 'ARABIC TOOLS (Corpora - MSA)', 'vicavTexts.xslt'); } );
       $("#liVicavOverview_special_corpora").mousedown ( function(event) { execTextQuery('vicavOverview_special_corpora', 'ARABIC TOOLS (Special Corpora)', 'vicavTexts.xslt'); } );
       $("#liVicavOverview_corpora_historical_varieties").mousedown ( function(event) { execTextQuery('vicavOverview_corpora_historical_varieties', 'ARABIC TOOLS (Corpora - Historical Varieties)', 'vicavTexts.xslt'); } );
       $("#liVicavOverview_dictionaries").mousedown ( function(event) { execTextQuery('vicavOverview_dictionaries', 'ARABIC TOOLS (Dictionaries)', 'vicavTexts.xslt'); } );
       $("#liVicavOverview_nlp").mousedown ( function(event) { execTextQuery('vicavOverview_nlp', 'ARABIC TOOLS (Language Processing)', 'vicavTexts.xslt'); } );
       $("#liVicavOverview_otherStuff").mousedown ( function(event) { execTextQuery('vicavOverview_otherStuff', 'Other Websites &amp; Projects', 'vicavTexts.xslt'); } );
       
       
       /* *************************** */
       /* ****  Explanations  ******* */
       /* *************************** */       
       $("#liProfilesExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationProfiles', 'BIBLIOGRAPHY: Explanation', 'vicavTexts.xslt'); } );          
       $("#liBibliographyExplanation").mousedown ( function(event) { createBiblExplanationPanel(); });          
       $("#liFeaturesExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationFeatures', 'LING. FEATURES: Explanation', 'vicavTexts.xslt'); } );
       $("#liSamplesExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationSampleTexts', 'SAMPLE TEXTS: Explanation', 'vicavTexts.xslt'); } );
       $("#liCorpusTextsExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationCorpusTexts', 'TEXTS: Explanation', 'vicavTexts.xslt'); } );

       /* *************************** */
       /* ****  CONTRIBUTIONS ******* */
       /* *************************** */
       $("#liVicavContributeBibliography").mousedown ( function(event) { execTextQuery('vicavContributionBibliography', 'BIBLIOGRAPHY: Contributing', 'vicavTexts.xslt'); } );
       $("#liVicavContributeProfile").mousedown ( function(event) { execTextQuery('vicavContributeProfile', 'PROFILES: Contributing', 'vicavTexts.xslt'); } );
       $("#liVicavContributeFeature").mousedown ( function(event) { execTextQuery('vicavContributeFeature', 'FEATURES: Contributing', 'vicavTexts.xslt'); } );
       $("#liVicavContributeSampleText").mousedown ( function(event) { execTextQuery('vicavContributeSampleText', 'SAMPLE TEXTS: Contributing', 'vicavTexts.xslt'); } );
       $("#liVicavContributeDictionary").mousedown ( function(event) { execTextQuery('vicavContributeDictionary', 'DICTIONARY/GLOSSARY: Contributing', 'vicavTexts.xslt'); } );
       
             

       /* This is needed to collapse the menu after click in small screens */
       $('.navbar-nav li a').on('click', function(){
          if(!$( this ).hasClass('dropdown-toggle')){
            $('.navbar-collapse').collapse('hide');
          }
       });

       $("#liBiblNewQuery").mousedown ( function(event) { createNewQueryBiblioPanel(); } );

       /* ********************************** */
       /* ****  DICTIONARY FRONTPAGE ******* */
       /* ********************************** */
       $("#liVicavDict_Tunis").mousedown ( function(event) { execTextQuery('dictFrontPage_Tunis', 'TUNICO DICTIONARY', 'vicavTexts.xslt'); } );       
       $("#liVicavDict_Damascus").mousedown ( function(event) { execTextQuery('dictFrontPage_Damascus', 'DAMASCUS DICTIONARY', 'vicavTexts.xslt'); } );       
       $("#liVicavDict_Cairo").mousedown ( function(event) { execTextQuery('dictFrontPage_Cairo', 'CAIRO DICTIONARY', 'vicavTexts.xslt'); } );       
       $("#liVicavDict_MSA").mousedown ( function(event) { execTextQuery('dictFrontPage_MSA', 'MSA DICTIONARY', 'vicavTexts.xslt'); } );       
       
       /* ******************************** */
       /* ****  DICTIONARY QUERIES ******* */
       /* ******************************** */
       $(document).on("click", '#liVicavDictQuery_Tunis', function(){ createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary Query', '_tunis', 'tunis_dict_001.xslt', charTable_tunis); });
       /*$(document).on("click", '#liVicavDictQuery_Tunis', function(){ createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary Query', '_tunis', 'tei_2_html__v004__gen.xsl', charTable_tunis); });*/
       $(document).on("click", '#liVicavDictQuery_Damascus', function(){ createNewDictQueryPanel('dc_apc_eng_03', 'Damascus Dictionary Query', '_damascus', 'damascus_dict_001.xslt', charTable_damasc); } );
       $(document).on("click", '#liVicavDictQuery_Cairo', function(){ createNewDictQueryPanel('dc_arz_eng_007', 'Cairo Dictionary Query', '_cairo', 'cairo_dict_001.xslt', charTable_cairo); } );
       $(document).on("click", '#liVicavDictQuery_MSA', function(){ createNewDictQueryPanel('dc_ar_en', 'MSA Dictionary Query', '_MSA', 'fusha_dict_001.xslt', charTable_msa); } );
       
       /* ******************************** */
       /* ****  DICTIONARY Auto Complete ******* */
       /* ******************************** */
       $(document).on("keyup", '.inpDictQuery_tunis', function(event){ dealWithDictQueryKeyInput(event, '_tunis'); } );
       $(document).on("keyup", '.inpDictQuery_damascus', function(event){ dealWithDictQueryKeyInput(event, '_damascus'); } );
       $(document).on("keyup", '.inpDictQuery_cairo', function(event){ dealWithDictQueryKeyInput(event, '_cairo'); } );
       $(document).on("keyup", '.inpDictQuery_MSA', function(event){ dealWithDictQueryKeyInput(event, '_MSA'); } );  

       /* ******************************** */
       /* ****  PROFILES ***************** */
       /* ******************************** */
       $("#liProfileAbudhabi").mousedown ( function(event) { getProfile__('Abu Dhabi', 'profile_abu_dhabi_01', 'profile_01.xslt'); } );      
       $("#liProfileAhwaz").mousedown ( function(event) { getProfile__('Ahwaz', 'profile_ahwaz_01', 'profile_01.xslt'); } );      
       $("#liProfileBaghdad").mousedown ( function(event) { getProfile__('Baghdad', 'profile_baghdad_01', 'profile_01.xslt'); } );
       $("#liProfileBenghazi").mousedown ( function(event) { getProfile__('Benghazi', 'profile_benghazi_01', 'profile_01.xslt'); } );       
       $("#liProfileCairo").mousedown ( function(event) { getProfile__('Cairo', 'profile_cairo_01', 'profile_01.xslt'); } );
       $("#liProfileDamascus").mousedown ( function(event) { getProfile__('Damascus', 'profile_damascus_01', 'profile_01.xslt'); } );      
       $("#liProfileDouz").mousedown ( function(event) { getProfile__('Douz', 'profile_douz_01', 'profile_01.xslt'); });
       $("#liProfileKhabura").mousedown ( function(event) { getProfile__('al-Khabura', 'profile_khabura_01', 'profile_01.xslt'); });      
       $("#liProfileRabat").mousedown ( function(event) { getProfile__('Rabat (Salé)', 'profile_sale_01', 'profile_01.xslt'); } );
       $("#liProfileSousse").mousedown ( function(event) { getProfile__('Sousse', 'profile_sousse_001', 'profile_01.xslt'); } );
       $("#liProfileSoukhne").mousedown ( function(event) { getProfile__('Soukhne', 'profile_soukhne_01', 'profile_01.xslt'); } );
       $("#liProfileTaizz").mousedown ( function(event) { getProfile__('Taizz', 'profile_taizz_01', 'profile_01.xslt'); } );
       $("#liProfileTiberias").mousedown ( function(event) { getProfile__('Tiberias', 'profile_tiberias_01', 'profile_01.xslt'); } );       
       $("#liProfileTozeur").mousedown ( function(event) { getProfile__('Tozeur', 'profile_tozeur_01', 'profile_01.xslt'); } );       
       $("#liProfileTunis").mousedown ( function(event) { getProfile__('Tunis', 'profile_tunis_01', 'profile_01.xslt'); } );
       $("#liProfileUrfa").mousedown ( function(event) { getProfile__('Şanlıurfa', 'profile_urfa_01', 'profile_01.xslt'); });
       
       /* **************************************** */
       /* ****  Show map with locators *********** */
       /* **************************************** */
       $("#navBiblGeoMarkers,#subNavBiblGeoMarkers").mousedown (
          function(event) {
             clearMarkerLayers();
             insertGeoRegMarkers('', 'geo');
             adjustNav(this.id, "#subNavBiblGeoMarkers");
          }
       );

       $("#navBiblRegMarkers,#subNavBiblRegMarkers").mousedown (
          function(event) {
             clearMarkerLayers();
             insertGeoRegMarkers('', 'reg');
             adjustNav(this.id, "#subNavBiblRegMarkers");
          }
       );       
 
       $("#navDictGeoRegMarkers,#subNavDictGeoRegMarkers,#navDictGeoRegMarkers1").mousedown (
          function(event) {
            clearMarkerLayers();            
            insertGeoRegMarkers('vt:dictionary', 'geo_reg');
            adjustNav(this.id, "#subNavDictGeoRegMarkers");
          }
       );
       
       $("#navTextbookGeoRegMarkers,#subNavTextbookGeoRegMarkers").mousedown (
          function(event) {
            clearMarkerLayers();
            insertGeoRegMarkers('vt:textbook', 'geo_reg');
            adjustNav(this.id, "#subNavTextbookGeoRegMarkers");
          }
       );

       $("#navProfilesGeoRegMarkers,#subNavProfilesGeoRegMarkers").mousedown ( function(event) {
            clearMarkerLayers();
            insertProfileMarkers();
            adjustNav(this.id, "#subNavProfilesGeoRegMarkers");
       });

       $("#navFeaturesGeoRegMarkers,#subNavFeaturesGeoRegMarkers").mousedown ( function(event) { 
             clearMarkerLayers(); 
             insertFeatureMarkers();
             adjustNav(this.id, "#subNavFeaturesGeoRegMarkers");
        } );

       $("#navSamplesGeoRegMarkers,#subNavSamplesGeoRegMarkers").mousedown ( function(event) {
            clearMarkerLayers();
            insertSampleMarkers();
            adjustNav(this.id, "#subNavSamplesGeoRegMarkers");
          }
       );     

       $("#navVicavDictMarkers,#subNavVicavDictMarkers").mousedown ( function(event) {
            clearMarkerLayers();
            insertVicavDictMarkers();
            adjustNav(this.id, "#subNavVicavDictMarkers");
          }
       );     

       /* ********************** */
       /* ****  FEATURES ******** */
       /* ********************** */
       $("#liFeatureBaghdad").mousedown ( function(event) { getFeature_('Baghdad', 'ling_features_baghdad', 'features_01.xslt'); } );      
       $("#liFeatureCairo").mousedown ( function(event) { getFeature_('Cairo', 'ling_features_cairo', 'features_01.xslt'); } );      
       $("#liFeatureDamascus").mousedown ( function(event) { getFeature_('Damascus', 'ling_features_damascus', 'features_01.xslt'); } );
       $("#liFeatureDouz").mousedown ( function(event) { getFeature_('Douz', 'ling_features_douz', 'features_01.xslt'); } );
       $("#liFeatureTunis").mousedown ( function(event) { getFeature_('Tunis', 'ling_features_tunis', 'features_01.xslt'); } );
       $("#liFeatureUrfa").mousedown ( function(event) { getFeature_('Urfa', 'ling_features_urfa', 'features_01.xslt'); } );
            
       /* ********************** */
       /* ****  SAMPLES ******** */
       /* ********************** */
       $("#liSampleCairo").mousedown ( function(event) { getSample_('vicav_samples', 'cairo_sample_01', 'sampletext_01.xslt'); });       
       $("#liSampleBaghdad").mousedown ( function(event) { getSample_('vicav_samples', 'baghdad_sample_01', 'sampletext_01.xslt'); });              
       $("#liSampleDamascus").mousedown ( function(event) { getSample_('vicav_samples', 'damascus_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleUrfa").mousedown ( function(event) { getSample_('vicav_samples', 'urfa_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleTunis").mousedown ( function(event) { getSample_('vicav_samples', 'tunis_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleDouz").mousedown ( function(event) { getSample_('vicav_samples', 'douz_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleMSA").mousedown ( function(event) { getSample_('vicav_samples', 'msa_sample_01', 'sampletext_01.xslt');  });             
       
       
       /* ******************************** */
       /* ****  CORPUS ******************* */
       /* ******************************** */
       $(document).on("click", '#liTextCukurova_001', function(){ getSample_('vicav_corpus', 'cukurova_001', 'sampletext_01.xslt'); });
       $(document).on("click", '#liTextJakal_001', function(){ getSample_('vicav_corpus', 'killing_jackal', 'sampletext_01.xslt'); });     
       

       /* *******************************************************/
       /* ***********PANEL BEHAVIOR *****************************/
       /* *******************************************************/
       $(document).on("click", '.chrome-minimize', function(){
          if($(this).parents(':eq(1)').hasClass('open-panel')){
            var panel = $(this).parents(':eq(1)');
            changePanelVisibility(panel, 'minimize');
          } else if($(this).parents(':eq(1)').hasClass('closed-panel')){
             var panel = $(this).parents(':eq(1)');
             changePanelVisibility(panel, 'maximize');
          }
       });

       /* *******************************************************/
       /* ********* WORD SELECTOR *******************************/
       /* *******************************************************/

       $("[id^=id_opt]").click (
         function(event) {
         }
       );
               
       $(document).on("keyup", '[id^=slWordSelect]',
          function(event) {
             suf = getSufixID($(this).attr('id'));

             inpID = '#inpDictQuery_' + suf;
             $(inpID).val($("#slWordSelector_" + suf + " option:selected").text());
          }
       );
               
       $(document).on("keydown", '[id^=slWordSelect]', 
         function(event) {
            suf = getSufixID($(this).attr('id'));
            inpID = 'inpDictQuery_' + suf;           
            
            if ( event.which == 13 ) {
                $('#' + inpID).val($("#slWordSelector_" + suf +" option:selected").text());
                $('#' + inpID).focus();
                $('#dvWordSelector_' + suf).hide();
            }  else if ( event.which == 27 ) {  /* Key: ESCAPE */
                $("#dvWordSelector_" + suf).hide();
                $('#' + inpID).focus();                     
            } else if ( event.which == 38 ) {  /* Key: Up */                     
                if (document.getElementById("slWordSelector_" + sids[1]).selectedIndex == 0) {
                    $("#slWordSelector_" + suf + " option:first").removeAttr('selected');
                    $('#' + inpID).focus();
                }
            }
       });

       $(document).on("click", '[id^=slWordSelect]', function(){
          var selectedVal = $(this).val();
          var idSuffix = $(this).attr('id').split('_');
          var idSuffix = idSuffix[1];
          $('#inpDictQuery_'+idSuffix).val(selectedVal);
          }
       );

       /* *******************************************************/
       /* ********* CHAR-TABLE **********************************/
       /* *******************************************************/
               
       $(document).on("mousedown", '[id^=ct]',
          function(event) {
             suf = getSufixID($(this).attr('id'));
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
          }
        );
               
        $(document).on("mouseover", '[id^=ct]',
           function(event) {
             $(this).css( 'cursor', 'pointer' );
           }
        );
           
        $(document).on("mouseout", '[id^=ct]',
            function(event) {
               $(this).css( 'cursor', 'auto' );
            }
        );
               

       /* *******************************************************/               
       $(document).on("click", '.chrome-close', function(){
         var panel = $(this).parents(':eq(1)');
         changePanelVisibility(panel, 'close');
       });

       $(document).on("click", '.grid-wrap', function(){
         $(this).find('.dvWordSelector').hide();
       });


       /* *******************************************************/               
       /* ****Query Bibliography Button Action  *****************/               
       /* *******************************************************/               
       $(document).on("click", '.newBiblQueryBtn', function(){
         query = $(this).prev().val()
         execBiblQuery(query);
       });
      
       /* *******************************************************/               
       /* ****Query Dictionary Button Action  *******************/               
       /* *******************************************************/               
       $(document).on("click", '[id^=newDictQuerybtn]', function(){
          suf = getSufixID($(this).attr('id'));
          execDictQuery('_' + suf);         
       });

       $('#sub-nav-expand').on('click', function(){
          if(!$( this ).hasClass('panels-expanded')){
            $('.panels-wrap').addClass('panels-wrap-expanded');
            $(this).addClass('panels-expanded');
            $(this).html('<i class="fa fa-compress" aria-hidden="true"></i> Minimize Panels Below Map');
          } else {
            $(this).removeClass('panels-expanded');
            $('.panels-wrap').removeClass('panels-wrap-expanded');
            $(this).html('<i class="fa fa-expand" aria-hidden="true"></i> Expand Panels Over Map');
          }
       });

       $('#sub-nav-close').on('click', function(){
          $('.content-panel:not(.initial-closed-panel)').each(function(i, obj) {
              changePanelVisibility($(this), 'close');
          });
       });

       $("body").tooltip({
           selector: '[data-toggle="tooltip"]',
           trigger: 'hover focus'
       });

     }
 );
  

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

/* ***************************/
/* Query Bibliography Button */
/* ***************************/
// When clicked on search icon show the overlay
$('.search-button').on( 'click', function() {
    createNewQueryBiblioPanel();
}); 


//Copy cite content
$("#sub-nav-share").on('click', function(){
    var URLtoCopy = window.location.toString();
    var result = copyToClipboard(URLtoCopy);
    if (result) {
       $('#sub-nav-share-confirmation').fadeIn(100);
       setTimeout(function() { $('#sub-nav-share-confirmation').fadeOut(200); }, 2000);
    }
});

function copyToClipboard(text) {
    if (window.clipboardData && window.clipboardData.setData) {
        // IE specific code path to prevent textarea being shown while dialog is visible.
        return clipboardData.setData("Text", text); 

    } else if (document.queryCommandSupported && document.queryCommandSupported("copy")) {
        var textarea = document.createElement("textarea");
        textarea.textContent = text;
        textarea.style.position = "fixed";  // Prevent scrolling to bottom of page in MS Edge.
        document.body.appendChild(textarea);
        textarea.select();
        try {
            return document.execCommand("copy");  // Security exception may be thrown by some browsers.
        } catch (ex) {
            console.warn("Copy to clipboard failed.", ex);
            return false;
        } finally {
            document.body.removeChild(textarea);
        }
    }
}
