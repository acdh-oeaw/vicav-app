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

function appendToPanel(result, windowType, windowVar) {

/*
  $('.content-panel').each(function(){
    var filled = $(this).attr("data-filled");
    if (filled == "empty") {
      panelFree = $(this);
      return false;
    }
    panelFree = false;
  });
*/
  var openPans = 0;
  $('.content-panel').each(function(){
    if ($(this).hasClass("open-panel")) {
      openPans += 1;
    }
  });

/*  if (!panelFree) {*/

/*
  if (resType == "profile") {
    resType = "Profile: ";
  } else if (resType == "bibl") {
    resType = "Bibliography: ";
  } else if (resType = "feat") {
    resType = "Ling. Feature: ";
  } else if (resType = "search") {
    resType = "Custom Query";
  }
*/

  if (openPans < 3) {
    var resCont = "<div class='grid-wrap'>"+result+"</div>";
    $(".initial-closed-panel").clone().appendTo( ".panels-wrap" ).append(resCont).removeClass("initial-closed-panel").removeClass("closed-panel").addClass("open-panel").find(".chrome-title").html(windowType + windowVar);
  } else {
    var firstPan = $(".open-panel").first();
    var firstCont = firstPan.children(".grid-wrap").html();
    var firstTitl = firstPan.find(".chrome-title").html();
    firstCont = "<div class='grid-wrap'>"+firstCont+"</div>";
    $(".initial-closed-panel").clone().appendTo( ".panels-wrap" ).append(firstCont).removeClass("initial-closed-panel").detach().insertBefore(firstPan).find(".chrome-title").html(firstTitl);
    var secCont = $(".open-panel").eq(1).children(".grid-wrap").html();
    var secTitl = $(".open-panel").eq(1).find(".chrome-title").html();
    var thirdCont = $(".open-panel").eq(2).children(".grid-wrap").html();
    var thirdTitl = $(".open-panel").eq(2).find(".chrome-title").html();
    $(".open-panel").eq(0).children(".grid-wrap").html(secCont);
    $(".open-panel").eq(0).find(".chrome-title").html(secTitl);
    $(".open-panel").eq(1).children(".grid-wrap").html(thirdCont);
    $(".open-panel").eq(1).find(".chrome-title").html(thirdTitl);
    panelFree = $(".open-panel").eq(2);
    $(panelFree).children(".grid-wrap").html(result);
    $(panelFree).find(".chrome-title").html(windowType + windowVar);
    $(panelFree).attr("data-filled", "filled");
    $(panelFree).addClass("open-panel");
  }
    
/*  } */

/*
  $(panelFree).children(".grid-wrap").html(result);
  $(panelFree).attr("data-filled", "filled");
  $(panelFree).addClass("open-panel");
*/

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

function createNewQueryPanel() {
  var searchContainer = "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>"+
                        "   <input class='form-control mr-sm-2' type='text' style='flex: 1;' placeholder='Search in bibliographies ...' aria-label='Search'>" + 
                        "   <button class='btn btn-outline-success my-2 my-sm-0 newBiblQuerybtn'>Search</button></form>";
  appendToPanel(searchContainer, "Custom Query", "");
}

function createNewDictQueryPanel() {
  var searchContainer = "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>"+
                        "<input class='form-control mr-sm-2' type='text' style='flex: 1;' placeholder='Search in dictionary ...' aria-label='Search'>"+
                        "<button class='btn btn-outline-success my-2 my-sm-0 newDictQuerybtn'>Search</button></form>";
  appendToPanel(searchContainer, "Custom Query", "");
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
          console.log(result); 
          appendToPanel(result, "Sample Query: ", id_);
            //createNewPanel();
            //$("#dvCaption_" + lastTextPanelID).html('SAMPLE TEXT');
            //$("#" + lastTextPanelID).html(result);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });
}

function execTextQuery(id_, windowType_, windowVar_) {
    qs = '/vicav_001/text?q=let $out := collection("vicav_texts")//tei:div[@xml:id="' + id_ + '"] return $out&s=vicavTexts.xslt';
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
          appendToPanel(result, windowType_, '');
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
  //console.log('execBiblQuery');
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
    customQuery = "biblQuery";
  }  
 
  qs = '/vicav_001/biblio?q=let $art := collection(\'vicav_biblio\')//' +
          'node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection")]' + subs + ' return $art&s=biblio_01.xslt';
  
  //console.log(qs);
  
  if (loc_ == undefined) {
    loc_ = query_;
  }
            
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
          //console.log(result); 
          appendToPanel(result, "Search in Bibliography: ", loc_);
            //$("#pLibrary").html(result);
            //$("#dvCaption").html('<b>Query: </b>' + query_);
            //$('#dvLibrary').show();
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
/*
            createNewPanel();
            $("#dvCaption_" + lastTextPanelID).html('Ling. Feature: ' + caption_);
            $("#" + lastTextPanelID).html(result);
*/
            appendToPanel(result, "Ling. Feature: ", caption_);
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
          appendToPanel(result, "Profile: ", caption_);
          /*
            createNewPanel();
            $("#dvCaption_" + lastTextPanelID).html('PROFILE: ' + caption_);
            $("#" + lastTextPanelID).html(result);
          */
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
          appendToPanel(result, "Profile: ", id_);
          /*
            createNewPanel();
            $("#dvCaption_" + lastTextPanelID).html('PROFILE: ' + caption_);
            $("#" + lastTextPanelID).html(result);
            */
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
    //clearMarkerLayers();
    //document.getElementById("dvOnMapText").innerHTML = document.getElementById(id_).innerHTML 
    //$("#dvOnMapText").show();
    appendToPanel('ABC', 'VICAV - Mission', '');
}

$(document).ready(
    
   function() {
       hideAllTabs();
       $("#dvMainMapCont").show();
       createBiblioPanel();
       
       insertBiblGeoMarkers();
       
       $('#tunicoDict').draggable({cancel : 'p, input, .dvFieldSelect', stack: ".ui-widget-content"});
       //**** "stack" makes sure that the last dragged panel gets on top
       //**** "cancel" allows to transfer the input focus to the elements in the list
                          
       $("#liVicavMission").mousedown ( function(event) { execTextQuery('vicavMission', 'MISSION', ''); } )              
       $("#liVicavContributors").mousedown ( function(event) { execTextQuery('vicavContributors', 'CONTRIBUTORS', ''); } )              
       $("#liVicavLinguistics").mousedown ( function(event) { execTextQuery('vicavLinguistics', 'LINGUISTICS', ''); } )              
       $("#liVicavDictionaries").mousedown ( function(event) { execTextQuery('vicavDictionaries', 'DICTIONARIES', ''); } )
       $("#liVicavTypesOfText").mousedown ( function(event) { execTextQuery('vicavTypesOfText', 'TYPES OF TEXT/DATA', ''); } )
       $("#liVicavDictionaryEncoding").mousedown ( function(event) { execTextQuery('vicavDictionaryEncoding', 'DICTIONARY ENCODING', ''); } )       
       $("#liVicavVLE").mousedown ( function(event) { execTextQuery('vicavVLE', 'DICTIONARY ENCODING', ''); } )       
       $("#liVicavArabicTools").mousedown ( function(event) { execTextQuery('vicavArabicTools', 'ARABIC TOOLS', ''); } )       
       
       
       $("#liVicavBibliographyExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationBibliography', 'BIBLIOGRAPHY: Explanation', ''); } )          
       $("#liProfilesExplanation").mousedown ( function(event) { showTextScreen("dvProfilesExplanation"); } )
       $("#liFeaturesExplanation").mousedown ( function(event) { showTextScreen("dvFeaturesExplanation"); } )

       $("#liVicavContributeBibliography").mousedown ( function(event) { execTextQuery('vicavContributionBibliography', 'BIBLIOGRAPHY: Contributing', ''); } )
       $("#liVicavContributeProfile").mousedown ( function(event) { execTextQuery('vicavContributeProfile', 'PROFILES: Contributing', ''); } )
       $("#liVicavContributeFeature").mousedown ( function(event) { execTextQuery('vicavContributeFeature', 'FEATURES: Contributing', ''); } )
       $("#liVicavContributeSampleText").mousedown ( function(event) { execTextQuery('vicavContributeSampleText', 'SAMPLE TEXTS: Contributing', ''); } )
       $("#liVicavContributeDictionary").mousedown ( function(event) { execTextQuery('vicavContributeDictionary', 'DICTIONARY/GLOSSARY: Contributing', ''); } )
       
       $("#liTryButton").mousedown ( function(event) { alert('Not yet implemented'); } )

             
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
       
       $("#liGeoDicts1").mousedown (
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
       
       $("#liBiblNewQuery").mousedown (
          function(event) {
             createNewQueryPanel();
          }
       )

       $("#liVicavDictQueryTunis").mousedown (
          function(event) {
             createNewDictQueryPanel();
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

       $("#liProfileTunis").mousedown (
          function(event) {
            getProfile__('Tunis', 'profile_tunis_01');
          }
       )

       $("#liProfileSousse").mousedown ( function(event) { getProfile__('Sousse', 'profile_sousse_01'); } )

       $("#liProfileCairo").mousedown ( function(event) { getProfile__('Cairo', 'profile_cairo_01'); } )
       $("#liProfileDamascus").mousedown ( function(event) { getProfile__('Damascus', 'profile_damascus_01'); } )      
       $("#liProfileBaghdad").mousedown ( function(event) { getProfile__('Baghdad', 'profile_baghdad_01'); } )      
       $("#liProfileKhabura").mousedown ( function(event) { getProfile__('al-Khabura', 'profile_khabura_01'); })      
       $("#liProfileDouz").mousedown ( function(event) { getProfile__('Douz', 'profile_douz_01'); })
       $("#liProfileUrfa").mousedown ( function(event) { getProfile__('Şanlıurfa', 'profile_urfa_01'); })

       
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


      /* PANEL BEHAVIOR */
      $(document).on("click", '.chrome-minimize', function(){
        if($(this).parents(':eq(1)').hasClass('open-panel')){
          $(this).parents(':eq(1)').removeClass('open-panel');
          $(this).parents(':eq(1)').addClass('closed-panel');
        } else if($(this).parents(':eq(1)').hasClass('closed-panel')){
          $(this).parents(':eq(1)').removeClass('closed-panel');
          $(this).parents(':eq(1)').addClass('open-panel');
        }
      });

      $(document).on("click", '.chrome-close', function(){
        $(this).parents(':eq(1)').remove();
      });

      $(document).on("click", '.newBiblQuerybtn', function(){
        keyword = $(this).prev().val()
        execBiblQuery(keyword);
      });
      
      $(document).on("click", '.newDictQuerybtn', function(){
        keyword = $(this).prev().val()
        execBiblQuery(keyword);
      });
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

/* Search Button */

// When clicked on search icon show the overlay
$('.search-button').on( 'click', function() {
  //$('.search-container').fadeIn(300);
  //$( ".header_search" ).focus();
  createNewQueryPanel();
}); 

/*
// When pressed on ESC icon hide the overlay
$('body').keydown(function(e) {
    if (e.keyCode == 27) {
        $('.search-container').fadeOut(300);
    }
});

// When clicked on search cancel icon hide the overlay
$('.search-cancel-icon').on( 'click', function() {
  $('.search-container').fadeOut(300);
}); 
*/