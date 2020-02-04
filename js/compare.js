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
            delay: 0, 
            minLength: 2,       
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
      });
    }
});

$('form.compare-samples').submit(function(event) {
  console.log($(this).serialize());
  event.preventDefault();
})
   