import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "Helper"

ApplicationWindow {
    id: root
    width: 1280
    height: 800
    visible: true
    title: "Media Player"

    Loader {
        id: mainLoader
        anchors.fill: parent
        source: NavigationManager.currentScreen
    }
}
