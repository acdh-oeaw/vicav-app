var getParam = function(name) { 
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search); 
  return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
}

var accentMap = {
  "â": "a",
  "æ": "a",
  "ç": "c",
  "é": "e",
  "è": "e",
  "ê": "e",
  "ë": "e",
  "ï": "i",
  "î": "i",
  "ô": "o",
  "œ": "o",
  "û": "u",
  "ù": "u",
  "ü": "u",
  "ÿ": "y",
  "ä": "a",
  "ö": "o",
  "ü": "u",
  "ß": "s",
  "ʔ": "'",
  "ā": "a",
  "ǟ": "a",
  "ḅ": "b",
  "ʕ": "'",
  "ḏ̣": "d",
  "ḏ": "d",
  "ē": "e",
  "ġ": "g",
  "ǧ": "g",
  "ḥ": "h",
  "ī": "i",
  "ᴵ": "i",
  "ə": "e",
  "ᵊ": "e",
  "ḷ": "l",
  "ṃ": "m",
  "ō": "o",
  "ṛ": "r",
  "ṣ": "s",
  "š": "s",
  "ṭ": "t",
  "ṯ": "t",
  "ū": "u",
  "ẓ": "z",
  "ž": "z"
};
var normalize = function( term ) {
  var ret = "";
  for ( var i = 0; i < term.length; i++ ) {
    ret += accentMap[ term.charAt(i) ] || term.charAt(i);
  }
  return ret;
};

var unique = function(array) {
  var newArray = array.pam()

  return newArray;
}

$.ajax({
    url: "sample_markers",
    dataType: "xml",
    success: function( xmlResponse ) {
      var data = $( "r", xmlResponse ).map(function() {
        if( $( "alt", this ).text() !== "") {
          return {
            value: $( "alt", this ).text(),
            label: $("alt", this).text()
          };
        }
      }).get();

      data = Array.from(new Set(data.map(JSON.stringify))).map(JSON.parse);

      $("[data-snippetid='compare-samples'] .location").tagit({
          autocomplete: {
            delay: 200, 
            minLength: 1,       
            source: function( request, response ) {
                var matcher = new RegExp( $.ui.autocomplete.escapeRegex( request.term ), "i" );
                response( $.grep( data, function( value ) {
                  console.log(value);
                  value = value.label || value.value || value;

                  return matcher.test( value ) || matcher.test( normalize( value.toLowerCase() ) );
                }) );
              }
          },
          allowSpaces: true,
          placeholderText: 'Seach place names...'
      });
    }
});

$(document).ready(function(event) {
  var location = getParam('location') //encodeURIComponent($('[name=location]', this)[0].value);

  if (location){
    $('[name="location"]', this)[0].value = location;
    var $form = $('form.compare-samples');
    
    
    $.ajax({
      url: 'explore_samples?query=' + encodeURIComponent(location) + '&sentences=all&xslt=cross_samples_01.xslt',
      dataType: 'html',
      cache: false,
      crossDomain: true,
      contentType: 'application/html; ',
      success: function (result) {
        if (result.includes('error type="user authentication"')) {
            alert('Error: authentication did not work');
        } 
        else {              
          var doc = new DOMParser().parseFromString(result, "text/html");
          if (doc) {
            var el = doc.getElementsByTagName("div")[0];
              if (el) {
                var shortTitle = el.getAttribute("name"); 
                if (shortTitle) {
                  secLabel_ = shortTitle;
                }
                
              } else {
                //console.log('no el'); 
              }
          } else {
            //console.log('doc not ok');  
          }
          console.log($form)
          $form.siblings('.results').html(result);
        }
       }
    });
  }
    //event.preventDefault();
});

$("body").tooltip({
    selector: '[data-toggle="tooltip"]',
    trigger: 'hover focus'
});
