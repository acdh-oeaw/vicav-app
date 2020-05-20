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

function loadWords($root) {
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

			$(".word", $root).tagit({
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
				placeholderText: 'Search words...'
			});
		}
	});
}

function loadLocations($root) {
	$.ajax({
		url: "sample_locations",
		dataType: "xml",
		success: function( xmlResponse ) {
			var data = $( "location", xmlResponse ).map(function() {
				if( $( "name", this ).text() !== "") {
					return {
						value: $( "name", this ).text(),
						label: $("label", this).text()
					};
				}
			}).get();

			data = Array.from(new Set(data.map(JSON.stringify))).map(JSON.parse);

			$(".location", $root).tagit({
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
}
// Init person widges

$(document).on('DOMNodeInserted', "[data-snippetid='compare-samples']", function(event) {
	loadWords($(event.target))
	loadLocations($(event.target))
	loadPersons($(event.target))
})

$(document).on('DOMNodeInserted', "[data-snippetid='compare-features']", function(event) {
	loadWords($(event.target))
	loadLocations($(event.target))
	loadPersons($(event.target))
	loadFeatures($(event.target))
})


function loadPersons($root) {
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

        $(".person", $root).tagit({
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
}


function loadFeatures($root) {
	$.ajax({
		url: "feature_labels",
		dataType: "xml",
		success: function( xmlResponse ) {
			var data = $( "feature", xmlResponse ).map(function() {
				if( $( this ).text() !== "") {
					return {
						value: $( this ).attr('ana'),
						label: $( this ).text() 
					};
				}
			}).get();

        // Uniques.
        data = Array.from(new Set(data.map(JSON.stringify))).map(JSON.parse);

        $(".features", $root).tagit({
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
        	placeholderText: 'Search features like "who?"...'
        });
    }
});
}

function attachAgeSliderHandler($root) {
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

	$('.display-age', $root).text( $('[name="age"]', $root)[0].value.split(',').join(' - '))
	$('[name="age"]', $root).hide();
}

function compareQuery(query, success_callback) {
	var url = 'explore_samples?'+ query + '&xslt=cross_samples_01.xslt';
	$.ajax({
		url: url,
		dataType: 'html',
		cache: false,
		crossDomain: true,
		contentType: 'application/html; ',
		success: function(result) {
			success_callback(result, query)
		}
	});
}

function compareFormSubmit($root, success_callback) {
	var $form = $('form[class^=compare]', $root); 

	var sex = []
	if ($('[name="sex"][value=m]', $root).prop('checked')) {
		sex.push('m')
	}
	if (    $('[name="sex"][value=f]', $root).prop('checked')) {
		sex.push('f')
	}

	query = $form.serialize().replace(/(&sex=[a-z])/g, '') + ('&sex=' + encodeURIComponent(sex.join(',')));

  //var sentencesUri = (Array.isArray(sentences) && sentences.indexOf('any') != -1) ? 'any' : sentences.replace(/\s+/g, '')
  compareQuery(query, success_callback)
}