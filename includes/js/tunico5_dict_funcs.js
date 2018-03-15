var sDict = 'dc_tunico';
var sDictInd = 'dc_tunico__ind';
var sXSLT = 'tunico5.xslt';
var sSubDir = 'tunico5';
var sourceISO = '{sourceISO}';
var targetISO = '{targetISO}';
var inpSel = 0;         
var ramz = "";
var usr = "";

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
    if (s_.startsWith('.*') == true) {
        s_ = s_.replace('.', '');
        s_ = s_.replace('*', '');
        s_ = encodeURIComponent(s_);
        res = 'ends-with(., "' + s_ + '")';                                  
        
    } else if (s_.endsWith('.*') == true) {
        s_ = s_.replace('.', '');
        s_ = s_.replace('*', '');
        s_ = encodeURIComponent(s_);
        res = 'starts-with(., "' + s_ + '")';                                  
    } else {
        s_ = encodeURIComponent(s_);
        res = 'matches(., "' + s_ + '")';                                  
    }
    
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
         
function hideAllTabs() {
  $("#btnQuery").attr('class', 'btnInActive');
  $("#btnProject").attr('class', 'btnInActive');
  $("#btnUser").attr('class', 'btnInActive');
  $("#btnHelp").attr('class', 'btnInActive');
  $("#btnLang").attr('class', 'btnInActive');
  $("#btnImprint").attr('class', 'btnInActive');

  $("#btnQuery1").attr('class', 'btnInActive');
  $("#btnProject1").attr('class', 'btnInActive');
  $("#btnUser1").attr('class', 'btnInActive');
  $("#btnHelp1").attr('class', 'btnInActive');
  $("#btnLang1").attr('class', 'btnInActive');
  $("#btnImprint1").attr('class', 'btnInActive');
             
  $("#dvMobileMenu").hide();
  //$("#dvStart").hide();
  //$("#dvInpText").hide();
  $("#dvProject").hide();
  $("#dvUser").hide();
  $("#dvHelp").hide();
  $("#dvLang").hide();
  $("#dvImprint").hide();
  $("#dvCharTable").hide();
  
  $("#imgPleaseWait").css('visibility', 'hidden');
}

function insert(str, index, value) {
   return str.substr(0, index) + value + str.substr(index);
}
         
function showKWICsTab() {
    hideAllTabs();
    $("#dvInpText").show();
    $("#btnQuery").attr('class', 'btnActive');
}

function tryIt(query_, field_) {
    hideAllTabs();
    $("btnQuery").attr('class', 'btnActive');
    $("#dvInpText").show();
    $("#txt1").val(query_);
    if (field_.length > 0) {
       $('#dvFieldSelect').show();
       $('#slFieldSelect').val(field_).prop('selected', true);
       query_ = "(" + field_ + "=" + query_ + ")";
    } else {
       $('#dvFieldSelect').hide();
    }
    sQuery = prepareQuery(query_);
    if (sQuery.length > 0) { 
        execQuery(sQuery);    
    }
}

$(document).ready(
    function() {
       //hideAllTabs();
       $("#dvCharTable").hide();
       $("#dvWordSelector").hide();
    
       $("#btnUser").show();
       $("#dvStart").show();            
    
       var txtValues = '';
       $("#btn2").mousedown (
          function(event) { 
             var sQuery = sApi2.replace(/{query}/g, 'karibu');
             jQuery.get(sQuery, 
                function(data) { 
                   var oSerializer = new XMLSerializer(); 
                   var xmlString = oSerializer.serializeToString(data);
                },'xml' );
          }
       );
       
       $("#btnX").mousedown (
          function(event) {
             $("#txt1").val('');
             $("#txt1").focus();
          }
       )
       
       $("[id^=btnProject]").mousedown (
          function(event) {
             hideAllTabs();
             $(this).attr('class', 'btnActive');
             $("#dvProject").show();
          }
       )
       
       $("[id^=btnQuery]").mousedown (
          function(event) {
             hideAllTabs();
             $("#imgPleaseWait").css('visibility', 'hidden');
             $(this).attr('class', 'btnActive');
             $("#dvInpText").show();
          }
       )
       
       $("[id^=btnUse]").mousedown (
          function(event) {
             hideAllTabs();
             $(this).attr('class', 'btnActive');
             $("#dvUser").show();
          }
       )
       
       $("[id^=btnHelp]").mousedown (
          function(event) {
             hideAllTabs();
             $(this).attr('class', 'btnActive');
             $("#dvHelp").show();
          }
       )
       
       $("[id^=btnLang]").mousedown (
          function(event) {
             hideAllTabs();
             $(this).attr('class', 'btnActive');
             $("#dvLang").show();
          }
       )
       
       $("[id^=btnImprint]").mousedown (
          function(event) {
             hideAllTabs();
             $(this).attr('class', 'btnActive');
             $("#dvImprint").show();
          }
       )              
       
       $("#btnExperiment").mousedown (
          function(event) {
             s = prepareQuery("(root=ktb)");
             execQuery(s);
          }
       );
       
       $("#usr1,#pw1").keyup (
          function(event) { 
             if ( event.which == 13 ) {
                $("#inpUser").hide();
                $("#dvInpText").css('visibility', 'visible');
                $("#txt1").attr("autofocus","autofocus");
                return false;
             }
          }
       );
       
      $("[id^=ct]").mousedown (
          function(event) {
             var s1 = $("#txt1").val();
             var s2 = $(this).text(); 
             var s = insert(s1, inpSel, s2);
             $("#txt1").val(s);
             
             inpSel += 1;
             document.getElementById('txt1').selectionStart = inpSel + 1;
             fillWordSelector($("#txt1").val());
          }
       );
       
       $("[id^=ct]").mouseover (
         function(event) {
            $(this).css( 'cursor', 'pointer' );
         }
       );
       
       $("[id^=ct]").mouseout (
         function(event) {
            $(this).css( 'cursor', 'auto' );
         }
       );
       
       $("[id^=id_opt]").mouseenter (
         function(event) {
            $(this).toggleClass('liHigh');
         }
       );
       
       $("[id^=id_opt]").mouseleave (
         function(event) {
            $(this).toggleClass('liHigh');
            //$('#dvDebug').text('not high');
         }
       );
       
       $("#btnMobileMenu").click (
         function(event) {
          hideAllTabs();
          $("#dvMobileMenu").show();
         }               
       )
       
       $("[id^=id_opt]").click (
         function(event) {
         }
       );
       
       $("#slWordSelector").keyup (
         function(event) {
            $('#txt1').val($("#slWordSelector option:selected").text());
         }
       );
       
       $("#slWordSelector").keydown (
          function(event) { 
             if ( event.which == 13 ) {         
                $('#txt1').val($("#slWordSelector option:selected").text());
                $('#txt1').focus();
                $('#dvWordSelector').hide();
             }  else if ( event.which == 27 ) {  /* Key: ESCAPE */
                $("#dvWordSelector").hide();
                $("#txt1").focus();                     
             } else if ( event.which == 38 ) {  /* Key: Up */                     
                if (document.getElementById("slWordSelector").selectedIndex == 0) {
                  $("#slWordSelector option:first").removeAttr('selected');
                  $('#txt1').focus();
                }
             }
          }
       );
    
       
       $("#slWordSelector").click (
          function() {
             $('#txt1').val($("#slWordSelector option:selected").text());
          }
       );
       
       
       $("#txt1").mousedown (
          function(event) {
             if ($("#slFieldSelect").val() == 'ar' ) {
                $("#dvCharTable").show();
             }
          }
       );
       
       $('#txt1').on("focus", function(){
          $("#dvCharTable").show();
       });
    
       $("#txt1").keyup (
          function(event) { 
             inpSel = document.getElementById('txt1').selectionStart;
             if ( event.which == 13 ) {
                $("#dvCharTable").hide();
                $("#imgPleaseWait").css('visibility', 'visible');
                $("#dvKWICs").html('');
             
                var sq = $("#txt1").val();
                var field = $("#slFieldSelect").val();
                //console.log(sq);
                //console.log(field);
                                        
                if (sq.indexOf("=") == -1) {
                   sq = "(" + field + "=" + sq + ")";
                }
                sQuery = prepareQuery(sq);
                console.log("Query: " + sQuery);
                if (sQuery.length > 0) {                           
                   execQuery(sQuery);    
                   //console.log('dvStats: ' + $("#dvStats").text());
                } else {
                   alert('Could not create query.');
                }
                                        
             } else if ( event.which == 40 )
             /* Arrow Down */
             { 
                $("#slWordSelector").focus();
                $("#slWordSelector option:first").attr('selected','selected');                                                      
             } else {
                $("#dvCharTable").show();
                var sq = $("#txt1").val();
    
                if (sq.indexOf('=') > -1) {
                   $('#dvFieldSelect').hide();
                } else {
                   $('#dvFieldSelect').show();
                }
                
                if (sq.length > 1) {
                   if (sq.indexOf('=') == -1) {
                      fillWordSelector(sq);
                   }
                } else {
                   $("#dvWordSelector").hide();
                }
             
             }
          }
       );
}
);

