#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "AuthController.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // AuthController
    AppState *appState = AppState::instance();
    APIFactory *api = new APIFactory("http://localhost:3000/api");
    AuthService *authService = new AuthService(api);
    UserModel *userModel = new UserModel();
    AuthController *authController = new AuthController(authService, appState, userModel);

    engine.rootContext()->setContextProperty("authController", authController);

    const QUrl url("qrc:/View/Main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
                     {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}