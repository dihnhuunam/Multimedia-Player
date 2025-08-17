pragma Singleton
import QtQuick

QtObject {
    property string currentScreen: "qrc:/View/Authentication/LoginView.qml"

    function navigateTo(screen) {
        currentScreen = screen;
    }
}
