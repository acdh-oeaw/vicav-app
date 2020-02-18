var $root = $('[data-pid=1]');

var getParam = function(name) { 
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)", 'g'), match = regex.exec(window.location.search);
  results = [];

  for (var i = 0; i<10; i++ ) {
    if (match == null) { break; }
    results.push(match)
    match = regex.exec(window.location.search);
  }

  if (results.length == 0) {
    return ""
  } else if (results.length == 1) {
      return decodeURIComponent(results[0][1].replace(/\+/g, " "));
  } else {
    return results.filter((r) => { return r[1] != '' }).map(function(r) {
        return decodeURIComponent(r[1].replace(/\+/g, " "))
    })
  }
 
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
    url: "sample_words",
    dataType: "xml",
    success: function( xmlResponse ) {
      var data = $( "word", xmlResponse ).map(function() {
        if( $( this ).text() !== "") {
          return {
            value: $( this ).text(),
            label: $(this).text()
          };
        }
      }).get();

      data = Array.from(new Set(data.map(JSON.stringify))).map(JSON.parse);

      $("[data-snippetid='compare-samples'] .word").tagit({
          autocomplete: {
            delay: 200, 
            minLength: 2,       
            source: function( request, response ) {
                var matcher = new RegExp( $.ui.autocomplete.escapeRegex( request.term ), "i" );
                response( $.grep( data, function( value ) {
                  value = value.label || value.value || value;

                  return matcher.test( value ) || matcher.test( normalize( value.toLowerCase() ) );
                }) );
              }
          },
          allowSpaces: true,
          placeholderText: 'Search words...'
      });
    }
});

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
  var sentences = getParam('sentences')

  var location = getParam('location')
  var word = getParam('word')
  var person = getParam('person')
  var age = getParam('age');
  var sex= getParam('sex');

  $('[name="word"]', $root)[0].value = word;
  $('[name="age"]', $root)[0].value = age;
  $('[name="location"]', $root)[0].value = location;
  $('[name="person"]', $root)[0].value = person;

  if (sex.indexOf('m') != -1) {
    $('[name="sex"][value=m]', $root).prop('checked', true);
  } else {
    $('[name="sex"][value=m]', $root).prop('checked', false);
  }

  if (sex.indexOf('f') != -1) {
    $('[name="sex"][value=f]', $root).prop('checked', true);
  } else {
    $('[name="sex"][value=f]', $root).prop('checked', false);
  }

  if (sentences == 'any') {
      $('[value=any][name="sentences"]', $root).prop('checked', true);
  } else {
      $('[value=any][name="sentences"]', $root).prop('checked', false);

      $('[type=text][name="sentences"]', $root)[0].value = sentences;    
  }

  $('[type=text][name="sentences"]', $root).change(function() {
    $('[value=any][name="sentences"]', $root).prop('checked', false);
  });    

  $('[value=any][name="sentences"]', $root).click(function() {
    $('[type=text][name="sentences"]', $root)[0].value = ''
  });


  
  $('.display-age', $root).text( $('[name="age"]', $root)[0].value.split(',').join(' - '))
  $('[name="age"]', $root).hide();

  if (location || person || word){
    var $form = $('form.compare-samples', $root); 
  
  var xsl = (word && word != '') ? 'cross_samples_word_01.xslt' : 'cross_samples_01.xslt'

  var sentencesUri = (Array.isArray(sentences) && sentences.indexOf('any') != -1) ? 'any' : sentences.replace(/\s+/g, '')

  var url = 'explore_samples?'+
        'location=' + encodeURIComponent(location) + 
        '&word=' + encodeURIComponent(word) +
        '&person=' + encodeURIComponent(person) + 
        '&age=' + encodeURIComponent(age) + 
        '&sex=' + encodeURIComponent(new Array(sex).join(',')) + 
        '&sentences='+ encodeURIComponent(sentencesUri) + '&xslt=' + xsl;
    $.ajax({
      url: url,
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
