import Qt 4.7

Theme {
    // http://src.chromium.org/viewvc/chrome/trunk/src/chrome/app/theme/
    path: "../images/theme/chromium/"
    titleBarBackground: path + "titlebar-bg.png"
    urlInput: path + "display.png"
    backButton: path + "back-big.png"
    forwardButton: path + "forward-big.png"
    reloadButton: path + "reload-big.png"
    stopButton: path + "stop-big.png"
    quitButton: path + "quit-big.png"
    goButton: path + "go.png"

    property string titleTextColor: "black"
    property string titleTextStyleColor: "white"
}
