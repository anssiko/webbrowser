#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/qml/webbrowser.qml"));
    // auto-rotate on Maemo5
    viewer.setAttribute(Qt::WA_Maemo5AutoOrientation, true);
    viewer.showExpanded();

    return app.exec();
}
