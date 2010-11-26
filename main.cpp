#include <QApplication>
#include <QDeclarativeView>

 int main(int argc, char *argv[])
 {
     QApplication app(argc, argv);

     QDeclarativeView view;
     view.setSource(QUrl::fromLocalFile("webbrowser.qml"));
     view.show();

     return app.exec();
 }
