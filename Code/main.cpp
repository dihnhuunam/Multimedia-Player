#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "Model.hpp"
#include "Controller.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Model model;
    Controller controller(model);
    engine.rootContext()->setContextProperty("controller", &controller);

    const QUrl url("qrc:/View/Main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
                     {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}