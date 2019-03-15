/* ************************************************************************* */
/* *** General String functions ******************************************** */
/* ************************************************************************* */
function xmlToString(xmlData) {
    var xmlString;
    //IE
    if (window.ActiveXObject) {
        xmlString = xmlData.xml;
    }
    // code for Mozilla, Firefox, Opera, etc.
    else {
        xmlString = (new XMLSerializer()).serializeToString(xmlData);
    }
    return xmlString;
}

function countChar(s_, c_) {
    ilen = s_.length;
    var res = 0;
    for (i = 0; i != ilen; i++) {
        if (s_.charAt(i) == c_)
        res = res + 1;
    }
    return res;
}

function sss(s_, slong_) {
  if (slong_.substring(0, s_.length) == s_) {
    return true;
  } else {
    return false;
  }
}

function trim(s_) {
    var res = s_;
    while (res.charAt(0) == ' ') {
        res = res.substring(1, res.length);
    }

    while (res.charAt(res.length -1) == ' ') {
        res = res.substring(0, res.length -1);
    }
    return res;
}

function insert(str, index, value) {
    return str.substr(0, index) + value + str.substr(index);
}
