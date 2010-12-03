.pragma library

function addScheme(url) {
    if (url.indexOf("http://") == 0 || url.indexOf("https://") == 0) return url
    else if (url.indexOf("/") == 0) return "file://" + url
    else if (url.indexOf(".") != -1) return "http://" + url
    else return "http://www.google.com/search?q=" + url
}

function getPrettyUrl(url) {
    var prettyUrl;
    // remove "http://" (but keep "https://")
    prettyUrl = url.toString().replace("http://", "");
     // remove trailing slash if no path component exists
    if (prettyUrl.split("/").length < 3 && prettyUrl[prettyUrl.length-1] == "/") {
        prettyUrl = prettyUrl.substring(0, prettyUrl.length-1);
    }
    return prettyUrl;
}
