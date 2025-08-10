pragma Singleton
import QtQuick

QtObject {
    property string currentScreen: "qrc:/View/Authentication/RegisterView.qml"

    function navigateTo(screen) {
        currentScreen = screen;
    }
}
