#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "AuthController.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    // QQuickStyle::setStyle("Material");
    QQuickStyle::setStyle("Basic");

    // Init AppState and API Service
    AppState *appState = AppState::instance();
    APIFactory *api = new APIFactory("http://localhost:3000/api");

    // AuthController
    AuthService *authService = new AuthService(api);
    UserModel *userModel = new UserModel();
    AuthController *authController = new AuthController(authService, appState, userModel);

    engine.rootContext()->setContextProperty("authController", authController);
    engine.rootContext()->setContextProperty("userModel", userModel);

    engine.addImportPath("qrc:/");
    qmlRegisterSingletonType(QUrl("qrc:/View/Helpers/NavigationManager.qml"), "NavigationManager", 1, 0, "NavigationManager");

    const QUrl url("qrc:/View/Main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
                     {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}