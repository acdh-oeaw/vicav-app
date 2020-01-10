
function createDisplayCrossSamplesPanel() {
    var searchContainer =
    "<div class='dvCrossSamples' id='dvCrossSamples'></div>";
    //appendPanel(searchContainer, "crossFeaturesResults", "", "grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
    appendPanel(searchContainer, "crossSamplesResults", "", "grid-wrap", '', 'hasTeiLink', '', '');
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

function createExploreSamplesPanel(pID_, pVisiblity_, pURL_) {
    var searchContainer =
    "<form action='javascript:void(0);' class='newQueryForm form-inline mt-2 mt-md-0'>" +
    "    <button class='biblQueryBtn'>Query</button><br/>" +
    "</form>" +
    "<p>For details as to how to formulate meaningful queries in the bibliography <a class='aVicText' href='javascript:createBiblExplanationPanel()'>click here</a>.</p>";
    appendPanel(searchContainer, "biblQueryLauncher", "", "grid-wrap", '', '', '', '', pID_, pVisiblity_, pURL_);
}


// Navigation entry
$("#liExploreSamples").mousedown (function (event) {
    showExploreSamples('tunis_sample_01,garia_sample_01', '1', 'html');
});

