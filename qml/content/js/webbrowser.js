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

function onKeyPressed(event) {
    switch (event.key) {
        // backspace - go back in navigation history
        case 16777219:
            webView.back();
            break;
        // L - focus on the location field
        case 76:
            console.log("TODO - implement urlInput.cursorVisible + scroll to top");
            break;
    }
}
