#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/qml/webbrowser.qml"));

    #if defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
    // auto-rotate on Maemo
    viewer.setAttribute(Qt::WA_Maemo5AutoOrientation, true);
    #endif

    viewer.showExpanded();

    return app.exec();
}
