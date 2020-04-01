
var oms = new OverlappingMarkerSpiderfier(mainMap, {nearbyDistance: 2});

oms.addListener('click', function(marker) {
    var isComparisonOpen = document.getElementById("dvCrossSamples");
    if (isComparisonOpen) {
		let samples = window.localStorage.getItem('crossSamples.samples') + ',' + marker.options.id;
		window.localStorage.setItem('crossSamples.samples', samples)
        showExploreSamples(samples, '', 'html')
    }
    else {
        getSample('', marker.options.id, 'sampletext_01.xslt');
    }
});

function createDisplayCrossSamplesPanel(query_, pID_ = '', pVisiblity_ = 'open', pURL_ = false) {
    $( '<div>' ).load( "compare-samples.html form" , function(event) {
        var pID = appendPanel(this.innerHTML, "crossSamplesForm", "", "grid-wrap", '', 'hasTeiLink', '', 'compare-samples', pID_, pVisiblity_, pURL_);
        var $root = $('[data-pid=' + pID + ']');
        $('form.compare-samples', $root).submit(function(event) {
            event.preventDefault();
            crossSamplesFormSubmit($root, function (result, query) {
                if (result.includes('error type="user authentication"')) {
                    alert('Error: authentication did not work');
                } 
                else {
                    createCrossSamplesResultsPanel(result, query)
                }
            });
        })

    });    
}

function createCrossSamplesResultsPanel(contents_ = '', query_ = '', pID_ = '', pVisiblity_ = 'open', pURL_ = false) {
    var attachPagingHandlers = function(pID, query) {
        var $root = $('[data-pid=' + pID + ']');

        function changeSentence(sentence) {
            var query = $root.attr('data-query').replace(/\+/g, '&').replace(/\|/g, '=')
            if (query.match(/sentences=/)) {
                query = query.replace(/sentences=[0-9]*/, 'sentences=' + encodeURIComponent(sentence));
            } else {
                query = query + 'sentences=' + encodeURIComponent(sentence)
            }
            crossSamplesQuery(query, function(result) {
                $('.grid-wrap > div', $root).html(result);
                var currentURL = decodeURI(window.location.toString());
                var re = new RegExp("^(.*&" + pID + "=\\[.*?\\,.*)sentences|[0-9]*(.*\\])$")
                var newUrl = currentURL.replace(re, '$1sentences|' + sentence + '$2')
                window.history.replaceState({ }, "", newUrl);
            })
        }

        $root.on('change', '[name=sentences]', function(e) {
            var sentence = $(e.target)[0].value.split(/,\s*/).join(',');
            e.preventDefault();
            changeSentence(sentence);
        })

        $root.on('click', 'a[data-sentence]', function(e) {
            e.preventDefault();
            var sentence = $(e.target).attr('data-sentence');
            changeSentence(sentence);
        })        
    }
        query = query_.replace(/\+/g, '&').replace(/\|/g, '=')

    if (contents_ == '' && query != '') {
        crossSamplesQuery(query, function(result) {
            var pID = appendPanel(result, "crossSamplesResult", "", "grid-wrap", query, 'hasTeiLink', '', 'compare-samples-result', '', pVisiblity_, pURL_);
            attachPagingHandlers(pID, query)
        })
    } else if (contents_ !== '') {
        var pID = appendPanel(contents_, "crossSamplesResult", "", "grid-wrap", query, 'hasTeiLink', '', 'compare-samples-result', '', pVisiblity_, pURL_);
            attachPagingHandlers(pID, query)
    }
}

// Navigation entry
$("#liExploreSamples").mousedown (function (event) {
    clearMarkerLayers();
    insertSampleMarkers();
    adjustNav(this.id, "#subNavSamplesGeoRegMarkers");
	createDisplayCrossSamplesPanel('','', 'open', false);
});

