#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "DatabaseAuthModel.hpp"
#include "APIFactory.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    APIFactory *api = new APIFactory("http://localhost:3000/api");
    IAuthModel *authModel = new DatabaseAuthModel(api);
    authModel->loginUser("nam@gmail.com", "Nam123");

    const QUrl url("qrc:/View/Main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
                     {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}