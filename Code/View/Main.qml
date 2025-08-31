import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "./Helpers"

ApplicationWindow {
    id: root
    width: 1280
    height: 800
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: "Media Player"

    Loader {
        id: mainLoader
        anchors.fill: parent
        source: NavigationManager.currentScreen
    }
}
