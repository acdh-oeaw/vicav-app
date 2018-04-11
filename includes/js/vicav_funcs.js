var inpSel = 0;         
var ramz = "";
var usr = "";
var containerCount = 0;
var lastTextPanelID = '';
var panelIDs = [];

var charTable_tunis = '’,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_cairo = '’,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_damasc = '’,ʕ,ʔ,ā,ḅ,ʕ,ḏ,̣ḏ,ǝ,ᵊ,ē,ġ,ǧ,ḥ,ī,ᴵ,ḷ,ṃ,ō,ṛ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ž';
var charTable_msa = 'ˀ,ˁ,ā,ḍ,ḏ,ē,ġ,ǧ,ḥ,ī,ḷ,ṣ,s̠,š,ṭ,ṯ,ū,ẓ,ʔ';

function createCharTable(idSuffix_, chars_) {
   sarr = chars_.split(',');
   s = '';
   for (var i = 0, len = sarr.length; i < len; i++) {
     s = s + "   <div id='ct" + idSuffix_ + "' class='dvLetter'>" + sarr[i] + "</div>";     
   }
   return "   <div class='dvCharTable' id='dvCharTable" + idSuffix_ + "'>" + s + "   </div>";
}

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

/*  
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
*/


function appendToPanel(result_, windowType_, windowVar_, contClass_, query_, teiLink_, pID_, pVisiblity_) {
  var openPans = 0;
  result_ = result_.replace(/{query}/, query_);
  $('.content-panel').each(function(){
    if ($(this).hasClass("open-panel")) {
      openPans += 1;
    }
  });
  if (openPans > 2) {
    $(".open-panel").first().removeClass('open-panel').addClass('closed-panel');
  }
  
  var teiLink = '';
  if ((result_.indexOf('<pre ') == -1)&&(teiLink_.length > 0)) {
    teiLink = "<span class='spTeiLink'><a href='javascript:" + teiLink_ + "'>TEI</a></span>";
  } else { teiLink = ''; }
  console.log('teiLink: ' + teiLink);  
  result_ = result_.replace(/{teiLink}/, teiLink);
  
  var resCont = 
  "<div class='" + contClass_ + "'>" +
  result_ + "</div>";
  $(".initial-closed-panel").clone().removeClass('closed-panel initial-closed-panel').addClass('open-panel').appendTo( ".panels-wrap" ).append(resCont).find(".chrome-title").html(windowType_ + windowVar_);

  // Add view
  //var currentURL = window.location.toString();
  //window.history.replaceState( {} , "", currentURL+"&p="+query );


}

function setExplanation(s_) {
    document.getElementById("dvExplanations").innerHTML = s_;    
}

function createNewQueryBiblioPanel() {
    var searchContainer = "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>"+
                "   <input class='form-control mr-sm-2' type='text' style='flex: 1;' placeholder='Search in bibliographies ...' aria-label='Search'>" + 
                "   <button class='newBiblQueryBtn'>Query</button>" +
                "'</form>";
    appendToPanel(searchContainer, "QUERY BIBLIOGRAPHY", "", "grid-wrap", '', '');
}


function createNewDictQueryPanel(dict_, dictName_, idSuffix_, xslt_, chartable_) {

  ob = $("#loading-wrapper" + idSuffix_).length;
  if (ob > 0) {
      alert('Dict query panel already exists');
  } else {
    
    var js = 'javascript:execDictQuery_tei("' + idSuffix_ + '")';
    var searchContainer =    
        //"<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>"+
        "   <div class='loading-wrapper' id='loading-wrapper" + idSuffix_ + "'><img class='imgPleaseWait' id='imgPleaseWait" + idSuffix_ + "' src='balls_in_circle.gif' alt='Query'></div>"+
        "   <div class='dict-search-wrapper'>"+
        "    <table class='tbHeader'>"+
        "        <tr><td><h2>" + dictName_ + "</h2></td><td class='tdTeiLink'><a href='" + js + "'><span class='spTeiLink'>TEI</span></a></td></tr>"+
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
        "        <div class='tdInputFrameRight my-2 my-sm-0'><button class='btn btn-outline-success dictQueryBtn' id='newDictQuerybtn" + idSuffix_ + "'>Search</button></div>"+
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
     
        appendToPanel(searchContainer, dictName_, "", "grid-wrap dict-grid-wrap", '', '');
   }
}

/* *************************************************************************** */ 
/* ** This func is used by the examples of the explanation texts (vicav_texts) */ 
/* *************************************************************************** */ 
function autoDictQuery(idSuffix_, query_, field_) {
 
    ob = document.getElementById('inpDictQuery' + idSuffix_);
    if (ob==null) {
      createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary', '_tunis', 'tunis_001.xslt', charTable_tunis);           
    }
    
    ob = document.getElementById('inpDictQuery' + idSuffix_);
    if (ob) {
        $('#' + 'inpDictQuery' + idSuffix_).val(query_);        
        $('#slFieldSelect' + idSuffix_).val(field_).change();
        execDictQuery(idSuffix_);
    } 
}

/* 
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
*/
 
function delElement(id_) {
    $(id_).remove();
}
         
function hideElement(id_) {
    $(id_).hide();
}
         
function execSampleQuery(coll_, id_, style_) {
  id_ = id_.replace(/sampleText:/, '');
 
  /*console.log('style: ' + style_);*/ 
  qs = '/vicav_001/profile?q=let $out := collection("' + coll_ + '")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=' + style_;
  /* console.log(qs); */
  /* console.log(coll_ + ' : ' + id_); */  
   
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
          /*console.log(result);*/ 
          teiLink = 'execSampleQuery("' + coll_ + '", "' + id_ + '", "tei_2_html__v004__gen.xsl")';
          appendToPanel(result, "Sample Query: ", id_, "grid-wrap", '', teiLink);
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

function execTextQuery(id_, windowType_, style_) {
    qs = '/vicav_001/text?q=let $out := collection("vicav_texts")//tei:div[@xml:id="' + id_ + '"] return $out&s=' + style_;
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
          teiLink = 'execTextQuery("' + id_ + '", "' + windowType_ + '", "tei_2_html__v004__gen.xsl")';
          appendToPanel(result, windowType_, '', "grid-wrap", '', teiLink);
        }
     },
     error: function (error) { alert('Error: ' + error); }                           
  });
}

function execBiblQuery(query_, loc_, keyword_, locType_, pID_, pVisiblity_) {
  /* query01 = query_.replace(/\./g, '\\\.'); */
  query01 = query_;
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
          
     var sarray = query01.split('&');        
     for(var i = 0; i < sarray.length; i++) {
        subs = subs + '[.//node()[text() contains text "' + sarray[i] + '" using wildcards using diacritics sensitive]]';    
     }
     
  } else {
     //console.log('locType_ = undefined');
     subs = '[dc:subject[text() contains text "' + query01 + '" using wildcards using diacritics sensitive]]'; 
  }
  
  if ((keyword_ != '')&&(keyword_ != undefined)) {
    subs = subs + '[dc:subject[text() contains text "' + keyword_ + '" using wildcards using diacritics sensitive]]';
    customQuery = "biblQuery";
  }  
 
  /* 
  qs = '/vicav_001/biblio?q=let $art := collection("vicav_biblio")//' +
          'node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection")]' + subs + ' return $art&s=biblio_01.xslt';
  */
  
  qs = '/vicav_001/biblio?q=' + 
       'let $arts := collection("vicav_biblio")//node()[(name()="bib:Article") or (name()="bib:Book") or (name()="bib:BookSection")] ' +
       subs + 
       'for $art in $arts ' + 
       'let $author := $art/bib:authors[1]/rdf:Seq[1]/rdf:li[1]/foaf:Person[1]/foaf:surname[1] ' + 
       'order by $author return $art&s=biblio_01.xslt';
  /*console.log(qs);*/
  
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
           
          appendToPanel(result, "Search in Bibliography: ", loc_, "grid-wrap", query_, '', pID_, pVisiblity_);
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

function getFeature_(caption_, id_, style_) {         
  //qs = 'http://localhost:8984/vicav_001/profile?q=let $out := collection("vicav_lingfeatures")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=features_01.xslt';
  qs = '/vicav_001/profile?q=let $out := collection("vicav_lingfeatures")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=' + style_;
  
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
            teiLink = 'getFeature_("' + caption_ + '", "' + id_ + '", "tei_2_html__v004__gen.xsl")';
            appendToPanel(result, "Ling. Feature: ", caption_, "grid-wrap", '', teiLink);
        }
     },
     error: function (error) {
        alert('Error: ' + error);
     }                           
  });             
}

function getProfile__(caption_, id_, style_) {
  qs = '/vicav_001/profile?q=let $out := collection("vicav_profiles")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=' + style_;
  /* qs = '/vicav_001/profile?q=let $out := collection("vicav_profiles")//tei:TEI[@xml:id="' + id_ + '"] return $out&s=tei_2_html__v004__gen.xsl'; */
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
          teiLink = 'getProfile__("' + caption_ + '", "' + id_ + '", "tei_2_html__v004__gen.xsl")';
          appendToPanel(result, "Profile: ", id_, "grid-wrap", '', teiLink);
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
    fgSampleMarkers.clearLayers();    
    fgBiblMarkers.clearLayers();
    fgDictMarkers.clearLayers();
    
    fgFeatureMarkers.clearLayers();
    fgGeoDictMarkers.clearLayers();
    
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
        field = field.replace(/\(/g, "");
        field = field.replace(/\)/g, "");
        
        tail = s.substring(n + 1, s.length);                
        tail = tail.replace(/\"/g, "");
        tail = tail.replace(/\(/g, "");
        tail = tail.replace(/\)/g, "");
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
                case 'lem': res = res + '[tei:form[@type="lemma"]/tei:orth[' + tail + ']]'; 
                                             ok = 0; break;
                case 'infl': res = res + '[tei:form[@type="inflected"]/tei:orth[' + tail + ']]'; 
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
 
function execDictQuery_ajax(query_, idSuffix_) {
    /*console.log('query_: ' + query_);*/
    if (query_.length > 0) {
        
        $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');
        $("#loading-wrapper" + idSuffix_).css('visibility', 'visible');
        
        xslt = $("#inpDictQuery" + idSuffix_).attr('xslt');
        teiQuery = query_.replace(xslt, "tei_2_html__v004__gen.xsl"); 
        $("#inpDictQuery" + idSuffix_).attr('teiQuery', teiQuery);
        /*console.log('teiQuery: ' + teiQuery);*/
        initDictUser();
        
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
                  //appendToPanel(result, 'TYPE', '', "grid-wrap", '', '');  
                  //console.log('suffix_: ' + suffix_);
                  //console.log('res: ' + result);
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
    console.log('fillWordSelector: ' + dictInd_);
    console.log('q_: ' + q_);
    console.log('idSuffix_: ' + idSuffix_);
    
    $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');

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
    /*console.log('XSLT: ' + XSLTName);*/

    //$("#dvCharTable" + idSuffix_).hide();
    $("#imgPleaseWait" + idSuffix_).css('visibility', 'visible');
    $("#dvDictResults" + idSuffix_).html('');
         
    var sq = $("#inpDictQuery" + idSuffix_).val();
    var field = $("#slFieldSelect" + idSuffix_).val();
    if (sq.length > 0) {
        console.log('suf: ' + idSuffix_);
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
           execDictQuery_ajax(sQuery, idSuffix_);    
        //console.log('dvStats: ' + $("#dvStats").text());
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
    /*alert("teiQuery: " + idSuffix_ + ": " + teiQuery);*/
}

function dealWithDictQueryKeyInput(event_, idSuffix_) {
   //console.log('suf: ' + idSuffix_);
   collName = $("#inpDictQuery" + idSuffix_).attr('dict');
   //inpSel = document.getElementById('inpDictQuery' + idSuffix_).selectionStart;
             
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

$(document).ready(
    
   function() {      
       hideAllTabs();
       $("#dvMainMapCont").show();
       /* createBiblioPanel(); */
       
       insertBiblGeoMarkers();

       // Parse the given url parameters for views
       var currentURL = window.location.toString();
       var args = currentURL.split('?');
       var args = args[1].split('&');
       // Parse the map
       var mapArg = args[0].split('=');
       if (mapArg[0] == 'map') {
         hideAllTabs();
         clearMarkerLayers();
         window["insert"+mapArg[1]]();
         //TODO make the selected subnav item active
       }
       // Parse the panels
       for (var i = 1; i < args.length; i++) {
          var pArgs = args[i].split('=');
          var pID_ = pArgs[0];
          pArgs = pArgs[1].replace(/((\[\s*)|(\s*\]))/g,"");
          pArgs = pArgs.split(',');
          var queryFunc = pArgs[0];
          var loc_ = pArgs[1];
          var locType_ = pArgs[2];
          var pVisiblity_ = pArgs[3];
          window["exec"+queryFunc]('', loc_, '', locType_, pID_, pVisiblity_);
       }


       $("#liVicavMission").mousedown ( function(event) { execTextQuery('vicavMission', 'MISSION', 'vicavTexts.xslt'); } );              
       $("#liVicavContributors").mousedown ( function(event) { execTextQuery('vicavContributors', 'CONTRIBUTORS', 'vicavTexts.xslt'); } );              
       $("#liVicavLinguistics").mousedown ( function(event) { execTextQuery('vicavLinguistics', 'LINGUISTICS', 'vicavTexts.xslt'); } );              
       $("#liVicavDictionaries").mousedown ( function(event) { execTextQuery('vicavDictionaries', 'DICTIONARIES', 'vicavTexts.xslt'); } );
       $("#liVicavTypesOfText").mousedown ( function(event) { execTextQuery('vicavTypesOfText', 'TYPES OF TEXT/DATA', 'vicavTexts.xslt'); } );
       $("#liVicavDictionaryEncoding").mousedown ( function(event) { execTextQuery('vicavDictionaryEncoding', 'DICTIONARY ENCODING', 'vicavTexts.xslt'); } );       
       $("#liVicavVLE").mousedown ( function(event) { execTextQuery('vicavVLE', 'DICTIONARY ENCODING', 'vicavTexts.xslt'); } );       
       $("#liVicavArabicTools").mousedown ( function(event) { execTextQuery('vicavArabicTools', 'ARABIC TOOLS', 'vicavTexts.xslt'); } );              
       
       $("#liBibliographyExplanation").mousedown ( function(event) { execTextQuery('vicavExplanationBibliography', 'BIBLIOGRAPHY: Explanation', 'vicavTexts.xslt'); } );          
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
       $(document).on("click", '#liVicavDictQuery_Tunis', function(){ createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary Query', '_tunis', 'tunis_001.xslt', charTable_tunis); });
       /*$(document).on("click", '#liVicavDictQuery_Tunis', function(){ createNewDictQueryPanel('dc_tunico', 'TUNCIO Dictionary Query', '_tunis', 'tei_2_html__v004__gen.xsl', charTable_tunis); });*/
       $(document).on("click", '#liVicavDictQuery_Damascus', function(){ createNewDictQueryPanel('dc_apc_eng_03', 'Damascus Dictionary Query', '_damascus', 'damascus_001.xslt', charTable_damasc); } );
       $(document).on("click", '#liVicavDictQuery_Cairo', function(){ createNewDictQueryPanel('dc_arz_eng_007', 'Cairo Dictionary Query', '_cairo', 'cairo_001.xslt', charTable_cairo); } );
       $(document).on("click", '#liVicavDictQuery_MSA', function(){ createNewDictQueryPanel('dc_ar_en', 'MSA Dictionary Query', '_MSA', 'fusha_001.xslt', charTable_msa); } );
       
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
       $("#liProfileBaghdad").mousedown ( function(event) { getProfile__('Baghdad', 'profile_baghdad_01', 'profile_01.xslt'); } );      
       $("#liProfileCairo").mousedown ( function(event) { getProfile__('Cairo', 'profile_cairo_01', 'profile_01.xslt'); } );
       $("#liProfileDamascus").mousedown ( function(event) { getProfile__('Damascus', 'profile_damascus_01', 'profile_01.xslt'); } );      
       $("#liProfileDouz").mousedown ( function(event) { getProfile__('Douz', 'profile_douz_01', 'profile_01.xslt'); });
       $("#liProfileKhabura").mousedown ( function(event) { getProfile__('al-Khabura', 'profile_khabura_01', 'profile_01.xslt'); });      
       $("#liProfileRabat").mousedown ( function(event) { getProfile__('Rabat (Salé)', 'profile_sale_01', 'profile_01.xslt'); } );
       $("#liProfileSousse").mousedown ( function(event) { getProfile__('Sousse', 'profile_sousse_001', 'profile_01.xslt'); } );
       $("#liProfileTunis").mousedown ( function(event) { getProfile__('Tunis', 'profile_tunis_01', 'profile_01.xslt'); } );
       $("#liProfileUrfa").mousedown ( function(event) { getProfile__('Şanlıurfa', 'profile_urfa_01', 'profile_01.xslt'); });

       
       /* **************************************** */
       /* ****  Show map with locators *********** */
       /* **************************************** */
       $("#sub-nav-allDict").mousedown (
          function(event) {
            hideAllTabs();
             
            clearMarkerLayers();
            insertGeoDictMarkers();
            $(".sub-nav-map-items .active").removeClass("active");
            $(this).addClass("active");
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

       $("#liProfiles,#sub-nav-allProf").mousedown ( function(event) {
            hideAllTabs();           
            clearMarkerLayers();
            insertProfileMarkers();
            
            $(".sub-nav-map-items .active").removeClass("active");
            $(this).addClass("active"); 
       });

       $("#liFeatures,#sub-nav-allFeat").mousedown ( function(event) { 
             hideAllTabs(); 
             clearMarkerLayers(); 
             insertFeatureMarkers();
             
             $(".sub-nav-map-items .active").removeClass("active");
             $(this).addClass("active"); 
        } );

       $("#liSamples,#sub-nav-allSamp").mousedown ( function(event) {
            hideAllTabs();
            clearMarkerLayers();
            insertSampleMarkers();
            
            $(".sub-nav-map-items .active").removeClass("active");
            $(this).addClass("active");
          }
       );     

       $("#liDicts,#sub-nav-allDict").mousedown ( function(event) {
            hideAllTabs();
            clearMarkerLayers();
            insertDictMarkers();
            
            $(".sub-nav-map-items .active").removeClass("active");
            $(this).addClass("active");
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
       $("#liSampleCairo").mousedown ( function(event) { execSampleQuery('vicav_samples', 'cairo_sample_01', 'sampletext_01.xslt'); });       
       $("#liSampleBaghdad").mousedown ( function(event) { execSampleQuery('vicav_samples', 'baghdad_sample_01', 'sampletext_01.xslt'); });              
       $("#liSampleDamascus").mousedown ( function(event) { execSampleQuery('vicav_samples', 'damascus_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleUrfa").mousedown ( function(event) { execSampleQuery('vicav_samples', 'urfa_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleTunis").mousedown ( function(event) { execSampleQuery('vicav_samples', 'tunis_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleDouz").mousedown ( function(event) { execSampleQuery('vicav_samples', 'douz_sample_01', 'sampletext_01.xslt');  });             
       $("#liSampleMSA").mousedown ( function(event) { execSampleQuery('vicav_samples', 'msa_sample_01', 'sampletext_01.xslt');  });             
       
       
       /* ******************************** */
       /* ****  CORPUS ******* */
       /* ******************************** */
       $(document).on("click", '#liTextCukurova_001', function(){ execSampleQuery('vicav_corpus', 'cukurova_001', 'sampletext_01.xslt'); });
       $(document).on("click", '#liTextJakal_001', function(){ execSampleQuery('vicav_corpus', 'killing_jackal', 'sampletext_01.xslt'); });     
       

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
             //console.log('suf: ' + suf);

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
       //$("[id^=ct]").mousedown (
          function(event) {
             suf = getSufixID($(this).attr('id'));
             inpID = 'inpDictQuery_' + suf;
             //console.log(inpID);
             var s1 = $('#' + inpID).val();
             var s2 = $(this).text();
             //console.log(s2);             
             var s = insert(s1, inpSel, s2);
             $('#' + inpID).val(s);
             inpSel += 1;
             document.getElementById(inpID).selectionStart = inpSel + 1;
             var sq = $("#" + inpID).val();
             //console.log('s3: ' + s3);             
             collName = $("#" + inpID).attr('dict');
             fillWordSelector(sq, collName + '__ind', '_' + suf);
          }
        );
               
        $(document).on("mouseover", '[id^=ct]',
        //$("[id^=ct]").mouseover (
           function(event) {
             //console.log('mouseover');
             $(this).css( 'cursor', 'pointer' );
           }
        );
           
        //$("[id^=ct]").mouseout (
        $(document).on("mouseout", '[id^=ct]',
            function(event) {
               //console.log('mouseout');
               $(this).css( 'cursor', 'auto' );
            }
        );
               

      /* *******************************************************/               
      $(document).on("click", '.chrome-close', function(){
        $(this).parents(':eq(1)').remove();
      });

      $(document).on("click", '.grid-wrap', function(){
        $(this).find('.dvWordSelector').hide();
      });


      /* *******************************************************/               
      /* ****Query Bibliography Button Action  *****************/               
      /* *******************************************************/               
      $(document).on("click", '.newBiblQueryBtn', function(){
        keyword = $(this).prev().val()
        execBiblQuery(keyword);
      });
      
      /* *******************************************************/               
      /* ****Query Dictionary Button Action  *******************/               
      /* *******************************************************/               
      $(document).on("click", '[id^=newDictQuerybtn]', function(){
         //console.log('');
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
          $('.content-panel:not(.initial-closed-panel)').remove();
       });

      $("body").tooltip({
          selector: '[data-toggle="tooltip"]',
          trigger: 'hover focus'
      });

    }
  );
  
  
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
  //$('.search-container').fadeIn(300);
  //$( ".header_search" ).focus();
  createNewQueryBiblioPanel();
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



