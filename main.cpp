#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <iostream>
#include "Sources/videoprocessor.h"
#include <QQmlContext>
namespace fs = std::filesystem;
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    VideoProcessor* videoProcessor = new VideoProcessor();
    engine.rootContext()->setContextProperty("fileDialog",videoProcessor->getDialogInstance());
    const QUrl url(QStringLiteral("qrc:/Resources/HMI/MainView/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);


    return app.exec();
}
