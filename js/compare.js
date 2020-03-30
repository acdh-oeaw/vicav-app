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
    attachAgeSliderHandler($root)
    formSubmit($root, function (result) {
        if (result.includes('error type="user authentication"')) {
            alert('Error: authentication did not work');
        } 
        else {
          console.log($('form', $root)[0])
          $($('form', $root)[0]).siblings('.results').html(result);
        }
    });
  }
});

$("body").tooltip({
    selector: '[data-toggle="tooltip"]',
    trigger: 'hover focus'
});
