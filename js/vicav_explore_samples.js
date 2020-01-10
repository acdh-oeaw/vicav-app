
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

function createDisplayCrossSamplesPanel(pID_ = '', pVisiblity_ = 'open', pURL_ = true) {
    window.localStorage.setItem('crossSamples.samples', '')
    window.localStorage.setItem('crossSamples.sentences', '')

    var searchContainer =
    "<div class='dvCrossSamples' id='dvCrossSamples'><h2>Click on sample markers to add them. Reload the page to start again.</h2><div class='content'></div>";
    appendPanel(searchContainer, "crossSamplesResults", "", "grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
    //appendPanel(searchContainer, "crossSamplesResults", "", "grid-wrap", '', 'hasTeiLink', '', '');
}

function showExploreSamples(query_, sentences_, type_) {
    if (type_ == 'tei') {
        qs = './explore_samples?query=' + encodeURIComponent(query_) + '&sentences=' + encodeURIComponent(sentences_) + '&xslt=tei_2_html__v004__gen.xslt';
    } else {
        qs = './explore_samples?query=' + encodeURIComponent(query_) + '&sentences=' + encodeURIComponent(sentences_) + '&xslt=cross_samples_01.xslt';
    }

    $.ajax({
        url: qs,
        type: 'GET',
        dataType: 'html',
        cache: false,
        crossDomain: true,
        contentType: 'application/html; ',
        success: function (result) {
            if (result.includes('error type="user authentication"')) {
                alert('Error: authentication did not work');
            } else {
                //appendPanel(result, "featureQuery", "features", "grid-wrap", '', 'hasTeiLink', '', snippetID_, pID_, pVisiblity_, pURL_);
                //console.log(result);
                // result = result.replace(/==teiFuncID==/, '#' + ana_);
                // result = result.replace(/==teiFuncLabel==/, expl_);
                
                ob = document.getElementById("dvCrossSamples");
                if (ob) {
                  ob.innerHTML = result;
                } else {
                  createDisplayCrossSamplesPanel();  
                  ob = document.getElementById("dvCrossSamples");
                  if (ob) {
                    ob.innerHTML = result;
                  }
                }
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert(errorThrown);
        }
    });
}

// Navigation entry
$("#liExploreSamples").mousedown (function (event) {
    clearMarkerLayers();
    insertSampleMarkers();
    adjustNav(this.id, "#subNavSamplesGeoRegMarkers");
	createDisplayCrossSamplesPanel();
//    showExploreSamples('tunis_sample_01,garia_sample_01', '1', 'html');
});

