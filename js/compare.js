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

// Init person widges

$.ajax({
    url: "sample_persons",
    dataType: "xml",
    success: function( xmlResponse ) {
      var data = $( "person", xmlResponse ).map(function() {
        if( $( this ).text() !== "") {
          return {
            value: $( this ).text(),
            label: [$( this ).text(), $( this ).attr('sex'), $( this ).attr('age')].join('/') 
          };
        }
      }).get();

      // Uniques.
      data = Array.from(new Set(data.map(JSON.stringify))).map(JSON.parse);

      $("[data-snippetid='compare-samples'] .person").tagit({
          autocomplete: {
            delay: 200, 
            minLength: 1,       
            source: function( request, response ) {
                var matcher = new RegExp( $.ui.autocomplete.escapeRegex( request.term ), "i" );
                response( $.grep( data, function( value ) {
                  value = value.label || value.value || value;
                  return matcher.test( value );
                }) );
              }
          },
          allowSpaces: true,
          placeholderText: 'Search speaker IDs like Beja1...'
      });
    }
});

$(document).ready(function(event) {
  var location = getParam('location')
  var person = getParam('person')
  var age = getParam('age')
  var $root = $('[data-pid=1]');

  if (age) {
    $('[name="age"]', $root)[0].value = age;
  }
  $('.display-age', $root).text( $('[name="age"]', $root)[0].value.split(',').join(' - '))
  $('[name="age"]', $root).hide();

  if (location || person){
    $('[name="location"]', $root)[0].value = location;
    $('[name="person"]', $root)[0].value = person;
    var $form = $('form.compare-samples', $root);
    
    $.ajax({
      url: 'explore_samples?query=' + 
        encodeURIComponent(location) + 
        '&person=' + encodeURIComponent(person) + 
        '&age=' + encodeURIComponent(age) + 
        '&sentences=any&xslt=cross_samples_01.xslt',
      dataType: 'html',
      cache: false,
      crossDomain: true,
      contentType: 'application/html; ',
      success: function (result) {
        if (result.includes('error type="user authentication"')) {
            alert('Error: authentication did not work');
        } 
        else {              
          $form.siblings('.results').html(result);
        }
       }
    });
  }

  $( ".age-slider", $root ).slider({
    range: true,
    min: 0,
    max: 100,
    step: 10,
    values:  $('[name="age"]', $root)[0].value == '' ? [0,100] : $('[name="age"]', $root)[0].value.split(','),
    slide: function( event, ui ) {
      $('[name="age"]', $root).val(ui.values[ 0 ] + "," + ui.values[ 1 ] );
      $('.display-age', $root).text( $('[name="age"]', $root)[0].value.split(',').join(' - '))
    }
  });
});

$("body").tooltip({
    selector: '[data-toggle="tooltip"]',
    trigger: 'hover focus'
});
