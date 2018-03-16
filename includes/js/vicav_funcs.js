var inpSel = 0;         
var ramz = "";
var usr = "";
var containerCount = 0;
var lastTextPanelID = '';
var panelIDs = [];

var charTableDamascus =
    "   <div class='dvCharTable' id='dvCharTable'>"+
    "   <div id='ct_a' class='dvLetter'>’</div>"+
    "   <div id='ct_a1' class='dvLetter'>ʔ</div>"+                 
    "   <div id='ct_a2' class='dvLetter'>ā</div>"+         
    "   <div id='ct_b' class='dvLetter'>ḅ</div>"+         
    "   <div id='ct_c' class='dvLetter'>ʕ</div>"+
    "   <div id='ct_d' class='dvLetter'>ḏ</div>"+
    "   <div id='ct_d1' class='dvLetter'>̣ḏ</div>"+
    "   <div id='ct_e' class='dvLetter'>ē</div>"+
    "   <div id='ct_gh' class='dvLetter'>ġ</div>"+
    "   <div id='ct_gj' class='dvLetter'>ǧ</div>"+
    "   <div id='ct_h' class='dvLetter'>ḥ</div>"+
    "   <div id='ct_i' class='dvLetter'>ī</div>"+
    "   <div id='ct_i1' class='dvLetter'>ᴵ</div>"+
    "   <div id='ct_l' class='dvLetter'>ḷ</div>"+
    "   <div id='ct_m' class='dvLetter'>ṃ</div>"+
    "   <div id='ct_o' class='dvLetter'>ō</div>"+
    "   <div id='ct_r' class='dvLetter'>ṛ</div>"+
    "   <div id='ct_s' class='dvLetter'>ṣ</div>"+
    "   <div id='ct_s1' class='dvLetter'>s̠</div>"+
    "   <div id='ct_s2' class='dvLetter'>š</div>"+
    "   <div id='ct_t' class='dvLetter'>ṭ</div>"+
    "   <div id='ct_t1' class='dvLetter'>ṯ</div>"+
    "   <div id='ct_u' class='dvLetter'>ū</div>"+
    "   <div id='ct_z' class='dvLetter'>ẓ</div>"+
    "   <div id='ct_z1' class='dvLetter'>ž</div>"+  
    "   </div>";


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
    $(panelFree).children(".grid-wrap").html(result).scrollTop(0);
    $(panelFree).find(".chrome-title").html(windowType + windowVar);
    $(panelFree).attr("data-filled", "true");
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

function createNewDictQueryPanel(dict_, dictName_, idSuffix_, xslt_, path_) {
  var searchContainer =
    ""+
    
    //"<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>"+
    "   <div id='dv_" + dict_ + "'>" + dictName_ + "</div>"+
    
    "   <table class='tbInputFrame'>" + 
    "      <tr>"+
    "        <td class='tdInputFrameLeft'><img class='imgQuery' src='looking_glass_16.png' alt='Query' /></td>"+
    "        <td class='tdInputFrameMiddle'><input type='text' id='inpDictQuery" + idSuffix_ + "' xslt='" + xslt_ + "' path='" + path_ + "' dict='" + dict_ + "' value='' placeholder='Search in dictionary ...' class='inpDictQuery" + idSuffix_ + "'/></td>"+
    "        <td class='tdInputFrameMiddle'><img class='imgPleaseWait' id='imgPleaseWait' src='balls_in_circle.gif' alt='Query' /></td>"+
    "        <td class='tdInputFrameRight'><input type='submit' id='btnX' class='btnX' value='✕' /></td>"+
    "        <td class='tdInputFrameRight'><button class='btn btn-outline-success my-2 my-sm-0 newDictQuerybtn'>Search</button></td>"+
    "      </tr>"+
    "      <tr>"+
    "         <td class='tdFieldSelectorLeft'>&nbsp;</td>"+
    "         <td class='tdFieldSelectorRight' colspan='3'>"+
    "            <div id='dvFieldSelect" + idSuffix_ + "' class='dvFieldSelect'>"+                  
    "               <select id='slFieldSelect" + idSuffix_ + "' class='slFieldSelect'>"+
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
    "         </td>"+
    "       </tr>"+
    "    </table>"+
       
    charTableDamascus + 
         
    "   <div id='dvWordSelector' class='dvWordSelector'>"+
    "      <select size='10' id='slWordSelector" + idSuffix_ + "'>"+
    "         <option></option>"+
    "       </select>"+
    "   </div>";
    //"</form>";
     
  appendToPanel(searchContainer, "DICTIONARY", "");
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
  
  //console.log('getFeature_: ' + qs);        
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

/* **************************************************** */
/* *** DICTIONARY FUNCTIONS *************************** */
/* **************************************************** */
function prepareDictQuery(sq_, dict_, xslt_, subdir_) {   
   ok = -1;   
   sq_ = trim(sq_);
   sq_ = sq_.replace("((", "(");
   sq_ = sq_.replace("))", ")");
   sq_ = sq_.replace("[[", "[");
   sq_ = sq_.replace("]]", "]");
   iBrackets = countChar(sq_, ')');

   var str_array = sq_.split('&');
   var res = '/dict_api1/' + dict_ + '/' + xslt_ + '/' + subdir_ + '?q=declare namespace tei = \'http://www.tei-c.org/ns/1.0\';' + 'collection(\'' + dict_ + '\')//tei:entry';
   
   for(var i = 0; i < str_array.length; i++) {
     s = str_array[i];
     s = trim(s);
     n = s.indexOf('=');  
     
     if (n > -1) {
        field = s.substring(0, n);
        field = field.replace("(", "");
        field = field.replace(")", "");
        
        tail = s.substring(n + 1, s.length);                
        tail = tail.replace("(", "");
        tail = tail.replace(")", "");
        tail = createMatchString(tail)
        
        if ((iBrackets == 1)&&(field == 'any')) {
            res = '/dict_api1/' + dict_ + '/' + xslt_ + '/' + subdir_ + '?q=declare namespace tei = \'http://www.tei-c.org/ns/1.0\';' + 
                           'collection(\'' + dict_ + '\')//tei:entry[tei:form/tei:orth[' + tail + ']] |' +
                           'collection(\'' + dict_ + '\')//tei:entry[tei:sense/tei:cit[@type="translation"][@xml:lang="de"]/tei:quote[' + tail + ']] |' +
                           'collection(\'' + dict_ + '\')//tei:entry[tei:sense/tei:cit[@type="translation"][@xml:lang="en"]/tei:quote[' + tail + ']] |' +
                           'collection(\'' + dict_ + '\')//tei:entry[tei:sense/tei:cit[@type="translation"][@xml:lang="fr"]/tei:quote[' + tail + ']] |' +
                           'collection(\'' + dict_ + '\')//tei:entry[tei:etym/tei:mentioned[' + tail + ']] |' +
                           'collection(\'' + dict_ + '\')//tei:entry[tei:etym/tei:lang[' + tail + ']] |' +
                           'collection(\'' + dict_ + '\')//tei:entry[tei:gramGrp/tei:gram[@type="root"][' + tail + ']]';
            ok = 0;
        } else {            
            switch (field) {
                case 'ar-aeb-x-tunis-vicav': res = res + '[tei:form[@type="lemma"]/tei:orth[' + tail + ']]'; 
                                             ok = 0; break;
                case 'en': res = res  + '[tei:sense/tei:cit[@type="translation"][@xml:lang="en"]/tei:quote[' + tail + ']]';
                           ok = 0; break;
                case 'de': res = res  + '[tei:sense/tei:cit[@type="translation"][@xml:lang="de"]/tei:quote[' + tail + ']]';
                           ok = 0; break;
                case 'fr': res = res  + '[tei:sense/tei:cit[@type="translation"][@xml:lang="fr"]/tei:quote[' + tail + ']]';
                           ok = 0; break;

                case 'etymLang': res = res  + '[tei:etym/tei:lang[' + tail + ']]';
                                 ok = 0; break;                           
                case 'etymSrc': res = res  + '[tei:etym/tei:mentioned[' + tail + ']]';
                                ok = 0; break;                           
                case 'root': res = res + '[tei:gramGrp/tei:gram[@type="root"][' + tail + ']]';
                             ok = 0; break;
                case 'subc': res = res + '[tei:gramGrp/tei:gram[@type="subc"][' + tail + ']]';
                             ok = 0; break;
                case 'pos': res = res + '[tei:gramGrp/tei:gram[@type="pos"][' + tail + ']]';
                             ok = 0; break;
             }
        }
     }     
   }
   
   if (ok == 0) {
      return res  + '';    
   } else {
      return ''; 
   }
}

function initDictUser() {
   //ramz = $("#pw1").val();
   //ramz = $.sha256(ramz).toUpperCase();
   //usr = $("#usr1").val();
   ramz = $.sha256('KRT3poskd9kkks').toUpperCase();
   usr = 'webuser';         
}
 
function execDictQuery(query_) {
    $("#imgPleaseWait").css('visibility', 'visible');
    initDictUser();
    
    $.ajax({
       url: query_,
       type: 'GET',
       dataType: 'html',
       cache: false,
       crossDomain: true,
       //headers: {'From': usr, 'Pragma': ramz,},
       headers: {'autho': usr + ':' + ramz},
       contentType: 'application/html; charset=utf-8',
       success: function (result) {                 
          //showKWICsTab();
          if (result.includes('error type="user authentication"')) {
              alert('Error: authentication did not work');                  
          } else {
              appendToPanel(result, 'TYPE', '');  
              //$("#dvKWICs").html(result);
              //$("#dvWordSelector").hide();
              //$("#imgPleaseWait").css('visibility', 'hidden');                     
          }
       },
       error: function (error) {
          alert('Error: ' + error);
       }                           
    });
}

function fillWordSelector(q_, dictInd_, idSuffix_) {
    console.log('fillWordSelector: ' + dictInd_);
    
    $("#imgPleaseWait").css('visibility', 'visible');

    if (q_.length == 0) { q_ = '*'; }
    sInd = $("#slFieldSelect" + idSuffix_).val();
    sUrl1 = '/dict_index/' + dictInd_ + '/' + sInd + '/' + q_;
    $.ajax({
    url: sUrl1,
            type: 'GET',
            dataType: 'html',
               contentType: 'application/html; charset=utf-8',
               success: function(result) {
                  if (result.indexOf('option') !== -1) {
                     $("#dvWordSelector" + idSuffix_).show();
                     $("#slWordSelector" + idSuffix_).html(result);
                  } else {
                     $("#dvWordSelector" + idSuffix_).hide();
                  }
                  $("#imgPleaseWait").css('visibility', 'hidden');
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

function showTextScreen(id_) {
    //clearMarkerLayers();
    //document.getElementById("dvOnMapText").innerHTML = document.getElementById(id_).innerHTML 
    //$("#dvOnMapText").show();
    appendToPanel('ABC', 'VICAV - Mission', '');
}

function dealWithDictKeyInput(event_, idSuffix_) {
   collName = $("#inpDictQuery" + idSuffix_).attr('dict');
   XSLTName = $("#inpDictQuery" + idSuffix_).attr('xslt'); 
   pathName = $("#inpDictQuery" + idSuffix_).attr('path'); 
             
   if ( event_.which == 13 ) {
      $("#dvCharTable").hide();
      $("#imgPleaseWait").css('visibility', 'visible');
      //$("#dvKWICs").html('');
             
      var sq = $("#inpDictQuery" + idSuffix_).val();
      var field = $("#slFieldSelect" + idSuffix_).val();
      //console.log('sq: ' + sq);
      //console.log('field: ' + field);
                                        
      if (sq.indexOf("=") == -1) {
         sq = "(" + field + "=" + sq + ")";
      }
      //sQuery = prepareDictQuery(sq, 'dc_tunico', 'tunis_001.xslt', 'tunico');
      //sQuery = prepareDictQuery(sq, 'dc_apc_eng_03', 'damascus_001.xslt', 'tunico');
      sQuery = prepareDictQuery(sq, collName, XSLTName, pathName);
                 
      console.log("SQuery: " + sQuery);
      if (sQuery.length > 0) {                           
        execDictQuery(sQuery);    
        console.log('dvStats: ' + $("#dvStats").text());
      } else {
        alert('Could not create query.');
      }                                        
    } else if ( event_.which == 40 )
      /* Arrow Down */
    { 
       $("#slWordSelector" + idSuffix_).focus();
       $("#slWordSelector" + idSuffix_ + " option:first").attr('selected','selected');                                                      
    } else {
       $("#dvCharTable").show();
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

$(document).ready(
    
   function() {
       hideAllTabs();
       $("#dvMainMapCont").show();
       createBiblioPanel();
       
       insertBiblGeoMarkers();
       
       $(document).on("keyup", '.inpDictQuery_tunis', function(event){ dealWithDictKeyInput(event, '_tunis'); } );
       $(document).on("keyup", '.inpDictQuery_damascus', function(event){ dealWithDictKeyInput(event, '_damascus'); } );
      
       //$('#tunicoDict').draggable({cancel : 'p, input, .dvFieldSelect', stack: ".ui-widget-content"});
       //**** "stack" makes sure that the last dragged panel gets on top
       //**** "cancel" allows to transfer the input focus to the elements in the list
                          
       $("#liVicavMission").mousedown ( function(event) { execTextQuery('vicavMission', 'MISSION', ''); } );              
       $("#liVicavContributors").mousedown ( function(event) { execTextQuery('vicavContributors', 'CONTRIBUTORS', ''); } );              
       $("#liVicavLinguistics").mousedown ( function(event) { execTextQuery('vicavLinguistics', 'LINGUISTICS', ''); } );              
       $("#liVicavDictionaries").mousedown ( function(event) { execTextQuery('vicavDictionaries', 'DICTIONARIES', ''); } );
       $("#liVicavTypesOfText").mousedown ( function(event) { execTextQuery('vicavTypesOfText', 'TYPES OF TEXT/DATA', ''); } );
       $("#liVicavDictionaryEncoding").mousedown ( function(event) { execTextQuery('vicavDictionaryEncoding', 'DICTIONARY ENCODING', ''); } );       
       $("#liVicavVLE").mousedown ( function(event) { execTextQuery('vicavVLE', 'DICTIONARY ENCODING', ''); } );       
       $("#liVicavArabicTools").mousedown ( function(event) { execTextQuery('vicavArabicTools', 'ARABIC TOOLS', ''); } );       
       
       
       $("#liBibliographyExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationBibliography', 'BIBLIOGRAPHY: Explanation', ''); } );          
       $("#liProfilesExplanation").mousedown ( function(event) { showTextScreen("dvProfilesExplanation"); } );
       $("#liFeaturesExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationFeatures', 'LING. FEATURES: Explanation', ''); } );


       /* *************************** */
       /* ****  CONTRIBUTIONS ******* */
       /* *************************** */
       $("#liVicavContributeBibliography").mousedown ( function(event) { execTextQuery('vicavContributionBibliography', 'BIBLIOGRAPHY: Contributing', ''); } );
       $("#liVicavContributeProfile").mousedown ( function(event) { execTextQuery('vicavContributeProfile', 'PROFILES: Contributing', ''); } );
       $("#liVicavContributeFeature").mousedown ( function(event) { execTextQuery('vicavContributeFeature', 'FEATURES: Contributing', ''); } );
       $("#liVicavContributeSampleText").mousedown ( function(event) { execTextQuery('vicavContributeSampleText', 'SAMPLE TEXTS: Contributing', ''); } );
       $("#liVicavContributeDictionary").mousedown ( function(event) { execTextQuery('vicavContributeDictionary', 'DICTIONARY/GLOSSARY: Contributing', ''); } );
       
             
       $("#liBibliographyLocations").mousedown (
          function(event) {
             hideAllTabs();
             
             clearMarkerLayers();
             insertBiblGeoMarkers();
          }
       );

       $("#sub-nav-biblLoc").mousedown (
          function(event) {
             hideAllTabs();
             clearMarkerLayers();
             insertBiblGeoMarkers();
             $(".sub-nav-map-items .active").removeClass("active");
             $(this).addClass("active");
          }
       );

       $("#liBibliographyRegions").mousedown (
          function(event) {
             hideAllTabs();
             
             clearMarkerLayers();
             insertBiblRegMarkers();
            //$('.navbar-toggle').click();
            //$('.nav-collapse').collapse('hide');
          }
       );

       $("#sub-nav-biblReg").mousedown (
          function(event) {
             hideAllTabs();
             
             clearMarkerLayers();
             insertBiblRegMarkers();
            //$('.navbar-toggle').click();
            //$('.nav-collapse').collapse('hide');
             $(".sub-nav-map-items .active").removeClass("active");
             $(this).addClass("active");
          }
       );

       /* This is needed to collapse the menu after click in small screens */
       $('.navbar-nav li a').on('click', function(){
          if(!$( this ).hasClass('dropdown-toggle')){
            $('.navbar-collapse').collapse('hide');
          }
       });

       $("#liGeoDicts").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoDictMarkers();
          }
       );

       $("#sub-nav-allDict").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoDictMarkers();
            $(".sub-nav-map-items .active").removeClass("active");
            $(this).addClass("active");
          }
       );

       $("#liGeoDicts1").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoDictMarkers();
          }
       );
       
       $("#liGeoTextbooks").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoTextbookMarkers();
          }
       );

       $("#sub-nav-allText").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoTextbookMarkers();
            $(".sub-nav-map-items .active").removeClass("active");
            $(this).addClass("active");
          }
       );

       $("#liBiblNewQuery").mousedown ( function(event) { createNewQueryPanel(); } );

       /* ************************** */
       /* ****  DICTIONARIES ******* */
       /* ************************** */
       $("#liVicavDictQueryTunis").mousedown ( function(event) { createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary', '_tunis', 'tunis_001.xslt', 'tunico'); } );
       $("#liVicavDictQueryDamascus").mousedown ( function(event) { createNewDictQueryPanel('dc_acp_eng_003', 'Damascus Dictionary', '_damascus', 'damascus_001.xslt', 'tunico'); } );
       $("#liVicavDictQueryCairo").mousedown ( function(event) { alert('To be implemented'); } );
       $("#liVicavDictQueryMSA").mousedown ( function(event) { alert('To be implemented'); } );

       /* ************************** */
       /* ****  PROFILES *********** */
       /* ************************** */
       $("#liProfiles").mousedown (
          function(event) {
             hideAllTabs();
            
            clearMarkerLayers();
            insertProfileMarkers();
          }
       );     

       $("#sub-nav-allProf").mousedown (
          function(event) {
             hideAllTabs();
            
            clearMarkerLayers();
            insertProfileMarkers();
            $(".sub-nav-map-items .active").removeClass("active");
            $(this).addClass("active");
          }
       );

       $("#liProfileBaghdad").mousedown ( function(event) { getProfile__('Baghdad', 'profile_baghdad_01'); } );      
       $("#liProfileCairo").mousedown ( function(event) { getProfile__('Cairo', 'profile_cairo_01'); } );
       $("#liProfileDamascus").mousedown ( function(event) { getProfile__('Damascus', 'profile_damascus_01'); } );      
       $("#liProfileDouz").mousedown ( function(event) { getProfile__('Douz', 'profile_douz_01'); });
       $("#liProfileKhabura").mousedown ( function(event) { getProfile__('al-Khabura', 'profile_khabura_01'); });      
       $("#liProfileRabat").mousedown ( function(event) { getProfile__('Rabat (Salé)', 'profile_sale_01'); } );
       $("#liProfileSousse").mousedown ( function(event) { getProfile__('Sousse', 'profile_sousse_01'); } );
       $("#liProfileTunis").mousedown ( function(event) { getProfile__('Tunis', 'profile_tunis_01'); } );
       $("#liProfileUrfa").mousedown ( function(event) { getProfile__('Şanlıurfa', 'profile_urfa_01'); });

       
       /* ********************** */
       /* ****  FEATURES ******* */
       /* ********************** */
       $("#liFeatures").mousedown ( function(event) { hideAllTabs(); clearMarkerLayers(); insertFeatureMarkers(); } );

       $("#sub-nav-allFeat").mousedown ( function(event) { 
         hideAllTabs(); 
         clearMarkerLayers(); 
         insertFeatureMarkers(); 
         $(".sub-nav-map-items .active").removeClass("active");
         $(this).addClass("active"); 
        } );

       $("#liFeatureBaghdad").mousedown ( function(event) { getFeature_('Cairo', 'ling_features_baghdad'); } );      
       $("#liFeatureCairo").mousedown ( function(event) { getFeature_('Cairo', 'ling_features_cairo'); } );      
       $("#liFeatureDamascus").mousedown ( function(event) { getFeature_('Damascus', 'ling_features_damascus'); } );
       $("#liFeatureDouz").mousedown ( function(event) { getFeature_('Damascus', 'ling_features_douz'); } );
       $("#liFeatureTunis").mousedown ( function(event) { getFeature_('Tunis', 'ling_features_tunis'); } );
       $("#liFeatureUrfa").mousedown ( function(event) { getFeature_('Urfa', 'ling_features_urfa'); } );
            
       /* ********************** */
       /* ****  SAMPLES ******** */
       /* ********************** */
       $("#liSampleCairo").mousedown ( function(event) { execSampleQuery('cairo_sample_01'); });       
       $("#liSampleBaghdad").mousedown ( function(event) { execSampleQuery('baghdad_sample_01'); });              
       $("#liSampleDamascus").mousedown ( function(event) { execSampleQuery('damascus_sample_01');  });             
       
       
       /* *******************************************************/
       /* ***********PANEL BEHAVIOR *****************************/
       /* *******************************************************/
       $(document).on("click", '.chrome-minimize', function(){
        if($(this).parents(':eq(1)').hasClass('open-panel')){
          $(this).parents(':eq(1)').removeClass('open-panel');
          $(this).parents(':eq(1)').addClass('closed-panel');
        } else if($(this).parents(':eq(1)').hasClass('closed-panel')){
          $(this).parents(':eq(1)').removeClass('closed-panel');
          $(this).parents(':eq(1)').addClass('open-panel');
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
             console.log('suf: ' + suf);

             inpID = 'inpDictQuery_' + suf;
             $('#' + inpID).val($("#slWordSelector_" + suf + " option:selected").text());
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
          alert($(this).attr('id'));
          //$('#txt1').val($("#slWordSelector option:selected").text());
          }
       );
       /* *******************************************************/
               
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
          $('.content-panel:not(.initial-closed-panel)').remove();
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