const exploreDataStrings = {
    feature: {
        class: 'Features',
        db: 'lingfeatures',
        xslt: 'cross_features_02.xslt',
        xslt_single: 'features_01.xslt',
        single_selector: 'data-featurelist'
    },
    sample: {
        class: 'Samples',
        db: 'samples',
        xslt: 'cross_samples_01.xslt',
        xslt_single: 'sampletext_01.xslt',
        single_selector: 'data-sampletext'
    }
}

const accentMap = {
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

function loadWords($root, type) {
	if ('wordsLoading' in window) {
		return;
	} else {
		wordsLoading = true;
	}

	$.ajax({
		url: "data_words",
		data: {type: type},
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

			delete window.wordsLoading
		}
	});
}

function loadLocations($root, type) {
	if ('locationsLoading' in window) {
		return;
	} else {
		locationsLoading = true;
	}
	$.ajax({
		url: "data_locations",
		data: {type: type},
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

			delete window.locationsLoading
		}
	});
}
// Init person widges

$(document).on('DOMNodeInserted', "[data-snippetid='compare-samples']", function(event) {
	loadWords($(event.target), 'samples')
	loadLocations($(event.target), 'samples')
	loadPersons($(event.target), 'samples')
})

$(document).on('DOMNodeInserted', "[data-snippetid='compare-features']", function(event) {
	loadWords($(event.target), 'lingfeatures')
	loadLocations($(event.target), 'lingfeatures')
	loadPersons($(event.target), 'lingfeatures')
	loadFeatures($(event.target))
})

$(document).on('click', 'a[data-wordform]', function(e) {    
    e.preventDefault();

    var word = $(e.target).closest('[data-wordform]').attr('data-wordform');
    var dataType = $(e.target).closest('[data-type]').attr('data-type');

    compareQuery('type='+ exploreDataStrings[dataType].db +'&word=' + word + '&xslt=' + exploreDataStrings[dataType].xslt, function(result) {
        createExploreDataResultsPanel(dataType, result, 'type='+ exploreDataStrings[dataType].db +'&word=' + word + '&xslt=' + exploreDataStrings[dataType].xslt);
    })
})

$(document).on('click', 'a[data-featurelist]', function(e) {    
    e.preventDefault();
    var item = $(e.target).closest('[data-featurelist]').attr('data-featurelist');
    if (item) {
        getFeatureOfLocation('', item, 'features_01.xslt');
    }
});

$(document).on('click', 'a[data-sampletext]', function(e) {    
    e.preventDefault();
    var item = $(e.target).closest('[data-sampletext]').attr('data-sampletext');
    if (item) {
        getSample('', item, 'sampletext_01.xslt');
    }
});

function loadPersons($root, type) {
	if ('personsLoading' in window) {
		return;
	} else {
		personsLoading = true;
	}
	$.ajax({
		url: "data_persons",
		data: {type: type},
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

        delete window.personsLoading
    }
});
}


function loadFeatures($root) {
	if ('featuresLoading' in window) {
		return;
	} else {
		featuresLoading = true;
	}
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
        	placeholderText: 'Search features like "whose?"...'
        });

        delete window.featuresLoading
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
	var url = 'explore_samples?'+ query;
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

function createDisplayExploreDataPanel(type, query_, pID_ = '', pVisiblity_ = 'open', pURL_ = false) {
    $( '<div>' ).load( "compare-" + type + "s.html form" , function(event) {
        var pID = appendPanel(this.innerHTML, "cross" + exploreDataStrings[type].class + "Form", "", "grid-wrap", '', 'hasTeiLink', '', 'compare-' + type + 's', pID_, pVisiblity_, pURL_);

        var $root = $('[data-pid=' + pID + ']');
        attachAgeSliderHandler($root)

        $('form.compare-' + type + 's', $root).submit(function(event) {
            event.preventDefault();
            compareFormSubmit($root, function (result, query) {
                if (result.includes('error type="user authentication"')) {
                    alert('Error: authentication did not work');
                } 
                else {
                    createExploreDataResultsPanel(type, result, query)
                }
            });
        });
    });    
}

function createExploreDataResultsPanel(type, contents_ = '', query_ = '', pID_ = '', pVisiblity_ = 'open', pURL_ = false) {
    var attachPagingHandlers = function(pID, query) {
        var $root = $('[data-pid=' + pID + ']');

        if (type == 'sample') {
            function changeFeature(feature) {
                var query = $root.attr('data-query').replace(/\+/g, '&').replace(/\|/g, '=')
                if (query.match(/features=/)) {
                    query = query.replace(/features=[0-9]*/, 'features=' + encodeURIComponent(feature));
                } else {
                    query = query + 'features=' + encodeURIComponent(feature)
                }
                compareQuery(query, function(result) {
                    $('.grid-wrap > div', $root).html(result);
                    var currentURL = decodeURI(window.location.toString());
                    var re = new RegExp("^(.*&" + pID + "=\\[.*?\\,.*)features|[0-9]*(.*\\])$")
                    var newUrl = currentURL.replace(re, '$1features|' + feature + '$2')
                    window.history.replaceState({ }, "", newUrl);
                })
            }
    
            $root.on('change', '[name=features]', function(e) {
                var feature = $(e.target)[0].value.split(/,\s*/).join(',');
                e.preventDefault();
                changeFeature(feature);
            })
            $root.on('click', 'a[data-feature]', function(e) {
                e.preventDefault();
                var feature = $(e.target).attr('data-feature');
                changeFeature(feature);
            })  
        }
    }
        query = query_.replace(/\+/g, '&').replace(/\|/g, '=')

    if (contents_ == '' && query != '') {
        compareQuery(query, function(result) {
            var pID = appendPanel(result, "cross" + exploreDataStrings[type].class + "Result", "", "grid-wrap", query, 'hasTeiLink', '', 'compare-' +type + 's-result', '', pVisiblity_, pURL_);
            attachPagingHandlers(pID, query)
        })
    } else if (contents_ !== '') {
        var pID = appendPanel(contents_, "cross"+ exploreDataStrings[type].class + "Result", "", "grid-wrap", query, 'hasTeiLink', '', 'compare-' + type + 's-result', '', pVisiblity_, pURL_);
            attachPagingHandlers(pID, query)
    }
}

// Navigation entry
$(document).on('mousedown', "#liVicavCrossFeatureQuery", function (event) {
    clearMarkerLayers();
    insertFeatureMarkers();
    adjustNav(this.id, "#subNavFeaturesGeoRegMarkers");
	createDisplayExploreDataPanel('feature', '','', 'open', false);
});


// Navigation entry
$(document).on('mousedown', "#liExploreSamples", function (event) {
    clearMarkerLayers();
    insertSampleMarkers();
    adjustNav(this.id, "#subNavSamplesGeoRegMarkers");
    createDisplayExploreDataPanel('sample', '','', 'open', false);
});
