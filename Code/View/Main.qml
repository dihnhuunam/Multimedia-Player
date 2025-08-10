import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "Helper"

ApplicationWindow {
    id: root
    width: 1400
    height: 900
    minimumWidth: 1400
    minimumHeight: 900
    visible: true
    title: "Media Player"

    Loader {
        id: mainLoader
        anchors.fill: parent
        source: NavigationManager.currentScreen
    }
}
