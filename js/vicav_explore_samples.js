
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
            formSubmit($root, function (result, query) {
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
    if (contents_ == '' && query_ != '') {
        crossSamplesQuery(query_.replace(/\+/g, '&').replace(/\|/g, '='), function(result, query) {
            return appendPanel(result, "crossSamplesResult", "", "grid-wrap", query, 'hasTeiLink', '', 'compare-samples-result', '', pVisiblity_, pURL_);
        })
    } else if (contents_ !== '') {
        return appendPanel(contents_, "crossSamplesResult", "", "grid-wrap", query_, 'hasTeiLink', '', 'compare-samples-result', '', pVisiblity_, pURL_);
    }
}

// Navigation entry
$("#liExploreSamples").mousedown (function (event) {
    clearMarkerLayers();
    insertSampleMarkers();
    adjustNav(this.id, "#subNavSamplesGeoRegMarkers");
	createDisplayCrossSamplesPanel('','', 'open', false);
});

