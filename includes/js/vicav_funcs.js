var inpSel = 0;         
var ramz = "";
var usr = "";
var containerCount = 0;
var lastTextPanelID = '';
var panelIDs = [];

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
      //console.log(s_.charAt(i));
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
    console.log(id_);
    panelIDs.push(id_);
    document.getElementById("dvOpenPanels").innerHTML = panelIDs.toString();
}

function createNewPanel() {
    sContainerID = 'dvDragContainer' + containerCount;
    lastTextPanelID = 'dvTextPanel' + containerCount;
    containerCount = containerCount + 1;
    addID(sContainerID);
    
    $("#body").append('<div id="' + sContainerID + '" class="ui-widget-content">' + 
    '<button class="btClosePanel" type="button" id="delButton0" onmousedown="delElement(\'#' + sContainerID + '\')">X</button>' + 
    '<div id="dvCaption_' + lastTextPanelID + '" class="dvCaption">CAPTION</div>' +
    '<p id="' + lastTextPanelID + '" class="dvCont">' + 
    lastTextPanelID + '</p></div>' +
    '');
    $('#' + sContainerID).draggable({cancel : 'p', stack: ".ui-widget-content"});
    
}

function setExplanation(s_) {
    document.getElementById("dvExplanations").innerHTML = s_;    
}

function createDictPanel() {
    sContainerID = 'dvDragContainer' + containerCount;
    lastTextPanelID = 'dvTextPanel' + containerCount;
    containerCount = containerCount + 1;
    addID(sContainerID);
    
    $("#body").append('<div id="' + sContainerID + '" class="ui-widget-content">' + 
    '<button class="btClosePanel" type="button" id="delButton0" onmousedown="delElement(\'#' + sContainerID + '\')">X</button>' + 
    '<div id="dvCaption_' + lastTextPanelID + '" class="dvCaption">CAPTION</div>' + 
    '<div id="dvCaption" class="dvCaption"></div>' +
    '<div>Search <input type="text" id="txtBiblioQuery" value="" class="inpText"/> in Dictionary </div>' + 
    '<p id="' + lastTextPanelID + '" class="dvCont">' + lastTextPanelID + '</p></div>');
    $('#' + sContainerID).draggable({cancel : 'p', stack: ".ui-widget-content"});    
}
                          
function createBiblioPanel() {   
    addID("dvLibrary");
    $("#body").append('<div id="dvLibrary" class="ui-widget-content">' + 
    '<button class="btClosePanel" type="button" id="delButton0" onmousedown="hideElement(\'#dvLibrary\')">Hide</button>' + 
    '<div id="dvCaption" class="dvCaption"></div>' +
    '<div id="dvQuery" class="dvQuery">Search <input type="text" id="txtBiblioQuery" value="" class="inpText"/> in LIBRARY</div>' +
    '<p id="pLibrary" class="dvCont"> </p>' +
    '' +
    '</div>');
    $('#dvLibrary').draggable({cancel : 'p, input', stack: ".ui-widget-content"});
    $('#dvLibrary').hide();
}
                          
function delElement(id_) {
    $(id_).remove();
}
         
function hideElement(id_) {
    $(id_).hide();
}
         
function execSampleQuery(id_) {
  //alert(query_);
  id_ = id_.replace(/sampleText:/, '');
 
  qs = '/vicav_001/profile?q=let $out := collection("vicav_samples")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=sampletext_01.xslt';
  console.log(qs);        
  
   
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
            createNewPanel();
            $("#dvCaption_" + lastTextPanelID).html('SAMPLE TEXT');
            $("#" + lastTextPanelID).html(result);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });
}

function execBiblQuery(query_, loc_, keyword_, locType_) {
  query01 = query_.replace(/\./g, '\\\.');
  var subs = '';
  console.log('execBiblQuery');
  console.log(query_ + ' : ' + loc_ + ' : ' + keyword_ + ' : ' + locType_);        
  //var sarray = query01.split('|');
  //for(var i = 0; i < sarray.length; i++) {
    
  if (locType_ == 'region') {
     subs = '[node()][dc:subject[text() contains text "reg:' + loc_ + '" using wildcards using diacritics sensitive]]';      
  } else 
  if (locType_ == 'point') {
     subs = '[node()][dc:subject[text() contains text "geo:' + loc_ + '" using wildcards using diacritics sensitive]]';
  } else 
  if ((locType_ == undefined) && (keyword_ == undefined) && (loc_ == undefined)) {
     subs = '[.//node()[text() contains text "' + query_ + '" using wildcards using diacritics sensitive]]'; 
  } else {
     console.log('locType_ = undefined');        
     subs = '[dc:subject[text() contains text "' + query01 + '" using wildcards using diacritics sensitive]]'; 
  }
  
  if ((keyword_ != '')&&(keyword_ != undefined)) {
    subs = subs + '[dc:subject[text() contains text "' + keyword_ + '" using wildcards using diacritics sensitive]]';
  }  
 
  qs = '/vicav_001/biblio?q=let $art := collection(\'vicav_biblio\')//' +
          'node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection")]' + subs + ' return $art&s=biblio_01.xslt';
  
  console.log(qs);        
            
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
            //createNewPanel();
            $("#pLibrary").html(result);
            $("#dvCaption").html('<b>Query: </b>' + query_);
            $('#dvLibrary').show();
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });             
}

function getFeature_(caption_, id_) {         
  //qs = 'http://localhost:8984/vicav_001/profile?q=let $out := collection("vicav_lingfeatures")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=features_01.xslt';
  qs = '/vicav_001/profile?q=let $out := collection("vicav_lingfeatures")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=features_01.xslt';

  console.log(qs);        
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
            createNewPanel();
            $("#dvCaption_" + lastTextPanelID).html('Ling. Feature: ' + caption_);
            $("#" + lastTextPanelID).html(result);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });             
}

function getProfile_(query_, caption_) {
  //alert(query_);
  query_ = query_.replace(/\./g, '\\\.');
  console.log(query_ + ':' + caption_);
 
  qs = '/vicav_001/profile?q=let $out := collection("vicav_profiles")//tei:TEI[tei:text/tei:body/tei:div/tei:div[@type="positioning"]/'+
       'tei:p/tei:geo[text() contains text "'+
       query_ + 
       '" using wildcards using diacritics sensitive]] return $out&s=profile_01.xslt';
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
        if (result.includes('error type="user authentication"')) {
            alert('Error: authentication did not work');                  
        } else {
            createNewPanel();
            $("#dvCaption_" + lastTextPanelID).html('PROFILE: ' + caption_);
            $("#" + lastTextPanelID).html(result);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });             
}

function getProfile__(caption_, id_) {
  qs = '/vicav_001/profile?q=let $out := collection("vicav_profiles")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=profile_01.xslt';
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
        if (result.includes('error type="user authentication"')) {
            alert('Error: authentication did not work');                  
        } else {
            createNewPanel();
            $("#dvCaption_" + lastTextPanelID).html('PROFILE: ' + caption_);
            $("#" + lastTextPanelID).html(result);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });             
}

function hideAllTabs() {
  $("#dvIntroText").hide();

  $("#txtBiblioQuery").hide();           
  $("#dvEmptyMapCont").hide();
  $("#dvBiblio").hide();
  $("#dvProfiles").hide();
  $("#dvProject").hide();
  $("#dvHelp").hide();
  //$("#dvImprint").hide();
}

function insert(str, index, value) {
   return str.substr(0, index) + value + str.substr(index);
}

function clearMarkerLayers() {
    $("#dvOnMapText").hide();
    
    fgProfileMarkers.clearLayers();
    fgBiblMarkers.clearLayers();
    
}

function showTextScreen(id_) {
    clearMarkerLayers();
    document.getElementById("dvOnMapText").innerHTML = document.getElementById(id_).innerHTML 
    $("#dvOnMapText").show();
}


$(document).ready(
    
   function() {
       hideAllTabs();
       $("#dvMainMapCont").show();
       createBiblioPanel();
       $('#tunicoDict').draggable({cancel : 'p, input, .dvFieldSelect', stack: ".ui-widget-content"});
       //**** "stack" makes sure that the last dragged panel gets on top
       //**** "cancel" allows to transfer the input focus to the elements in the list
                          
       $("#liVicavMission").mousedown ( function(event) { showTextScreen("dvIntroText"); } )
       $("#liProject").mousedown ( function(event) { showTextScreen("dvProjectText"); } )       
       $("#liContributors").mousedown ( function(event) { showTextScreen("dvContributorsText"); } )              
       $("#liDictionaries").mousedown ( function(event) { showTextScreen("dvDictionariesText"); } )
       $("#liLinguistics").mousedown ( function(event) { showTextScreen("dvLinguisticsText"); } )
       $("#liTextTechnology").mousedown ( function(event) { showTextScreen("dvTextTechnologyText"); } )       
       $("#liProfilesExplanation").mousedown ( function(event) { showTextScreen("dvProfilesExplanation"); } )
       $("#liFeaturesExplanation").mousedown ( function(event) { showTextScreen("dvFeaturesExplanation"); } )

       $("#liNotYet").mousedown ( function(event) { alert('Not yet implemented'); } )

             
       $("#liBibliographyLocations").mousedown (
          function(event) {
             hideAllTabs();
             
             clearMarkerLayers();
             insertBiblGeoMarkers();
          }
       )

       $("#liBibliographyRegions").mousedown (
          function(event) {
             hideAllTabs();
             
             clearMarkerLayers();
             insertBiblRegMarkers();
            //$('.navbar-toggle').click();
            //$('.nav-collapse').collapse('hide');
          }
       )
       
       
       /* This is needed to collapse the menu after click in small screens */
       $('.navbar-nav li a').on('click', function(){
          if(!$( this ).hasClass('dropdown-toggle')){
            $('.navbar-collapse').collapse('hide');
          }
       })       
       
       $("#liGeoDicts").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoDictMarkers();
          }
       )
       
       $("#liGeoTextbooks").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoTextbookMarkers();
          }
       )       
       
       $("#liTunico").mousedown (
          function(event) {
             createDictPanel();
          }
       )
       
       /* ********************** */
       /* ****  PROFILES ******* */
       $("#liProfiles").mousedown (
          function(event) {
             hideAllTabs();
            
            clearMarkerLayers();
            insertProfileMarkers();
          }
       )
       
       $("#liProfileRabat").mousedown (
          function(event) {
            /*  getProfile_('34.02.*-6.83', 'Salé');*/
            getProfile__('Rabat (Salé)', 'profile_sale_01');
          }
       )
       
       /* ********************** */
       /* ****  FEATURES ******* */
       /* ********************** */
       $("#liFeatures").mousedown (
          function(event) {
            hideAllTabs();
            
            clearMarkerLayers();
            insertFeatureMarkers();
          }
       )
       
       $("#liFeatureCairo").mousedown (
          function(event) {
            getFeature_('Cairo', 'ling_features_cairo');            
          }
       )
      
       $("#liFeatureDamascus").mousedown (
          function(event) {
            getFeature_('Damascus', 'ling_features_damascus');            
          }
       )
            
       /* ********************** */
       /* ****  SAMPLES ******** */
       /* ********************** */
       $("#liSampleCairo").mousedown (
          function(event) { execSampleQuery('cairo_sample_01'); })       

       $("#liSampleBaghdad").mousedown (
          function(event) { execSampleQuery('baghdad_sample_01'); })       
       
       $("#liSampleDamascus").mousedown ( function(event) { execSampleQuery('damascus_sample_01');  })       
       
       
       /* ********************** */
       /* ****  OTHER STUFF ******** */
       /* ********************** */
       $("[id^=dvDragContainer]").on("click",
          function(event) {
             //alert($(this).attr('id'));
             alert('');
          }
       )
                                   
    }
  );
  
  
function refEvent(url_) {
   if (url_.indexOf("biblid") > -1) {
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


