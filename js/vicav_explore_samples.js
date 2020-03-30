
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
    var pID = appendPanel('', "crossSamplesForm", "", "grid-wrap", '', 'hasTeiLink', '', 'compare-samples', pID_, pVisiblity_, pURL_);
    var $root = $('[data-pid=' + pID + ']');
    $( 'div[data-pid=' + pID + '] .grid-wrap' ).load( "compare-samples.html form" , function() {
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

