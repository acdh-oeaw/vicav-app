function createDisplayCrossFeaturesPanel(query_, pID_ = '', pVisiblity_ = 'open', pURL_ = false) {
    $( '<div>' ).load( "compare-features.html form" , function(event) {
        var pID = appendPanel(this.innerHTML, "crossFeaturesForm", "", "grid-wrap", '', 'hasTeiLink', '', 'compare-features', pID_, pVisiblity_, pURL_);

        var $root = $('[data-pid=' + pID + ']');
        attachAgeSliderHandler($root)

        $('form.compare-features', $root).submit(function(event) {
            event.preventDefault();
            compareFormSubmit($root, function (result, query) {
                if (result.includes('error type="user authentication"')) {
                    alert('Error: authentication did not work');
                } 
                else {
                    createCrossFeaturesResultsPanel(result, query)
                }
            });
        });
    });    
}

function createCrossFeaturesResultsPanel(contents_ = '', query_ = '', pID_ = '', pVisiblity_ = 'open', pURL_ = false) {
    var attachPagingHandlers = function(pID, query) {
        var $root = $('[data-pid=' + pID + ']');

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
            changeSentence(feature);
        })

        $root.on('click', 'a[data-featurelist]', function(e) {    
            e.preventDefault();
            var feature = $(e.target).closest('[data-featurelist]').attr('data-featurelist');
            if (feature) {
                getFeatureOfLocation('', feature, 'features_01.xslt');
            }
        })

        $root.on('click', 'a[data-wordform]', function(e) {    
            e.preventDefault();

            var word = $(e.target).closest('[data-wordform]').attr('data-wordform');
            console.log($(e.target))

            compareQuery('word=' + word, function(result) {
                createCrossFeaturesResultsPanel(result, 'word=' + word);
            })
        })

        $root.on('click', 'a[data-feature]', function(e) {
            e.preventDefault();
            var feature = $(e.target).attr('data-feature');
            changeFeature(feature);
        })        
    }
        query = query_.replace(/\+/g, '&').replace(/\|/g, '=')

    if (contents_ == '' && query != '') {
        compareQuery(query, function(result) {
            var pID = appendPanel(result, "crossFeaturesResult", "", "grid-wrap", query, 'hasTeiLink', '', 'compare-features-result', '', pVisiblity_, pURL_);
            attachPagingHandlers(pID, query)
        })
    } else if (contents_ !== '') {
        var pID = appendPanel(contents_, "crossFeaturesResult", "", "grid-wrap", query, 'hasTeiLink', '', 'compare-features-result', '', pVisiblity_, pURL_);
            attachPagingHandlers(pID, query)
    }
}

// Navigation entry
$("#liVicavCrossFeatureQuery").mousedown (function (event) {
    clearMarkerLayers();
    insertFeatureMarkers();
    adjustNav(this.id, "#subNavFeaturesGeoRegMarkers");
	createDisplayCrossFeaturesPanel('','', 'open', false);
});
