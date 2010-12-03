.pragma library

function addScheme(url) {
    if (url.indexOf("http://") == 0 || url.indexOf("https://") == 0) return url
    else if (url.indexOf("/") == 0) return "file://" + url
    else if (url.indexOf(".") != -1) return "http://" + url
    else return "http://www.google.com/search?q=" + url
}
