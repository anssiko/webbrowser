import QtQuick 1.1

Item {
    property string path: "images/theme/default/"
    property string titleBarBackground: path + "titlebar-bg.png"
    property string backButton: path + "go-previous-view.png"
    property string forwardButton: path + "go-next-view.png"
    property string urlInput: path + "display.png"
    property string reloadButton: path + "theme/default/view-refresh.png"
    property string stopButton: path + "edit-delete.png"
    property string goButton: path + "go-jump-locationbar.png"
    property string quitButton: path + "quit.png"
    property string scrollBar: path + "scrollbar.png"

    property string backgroundColor: "#343434"
    property string titleTextColor: "white"
    property string titleTextStyleColor: "black"
    property string urlTextColor: "black"
}
