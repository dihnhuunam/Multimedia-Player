import QtQuick

Window {
    id: window
    width: 640
    height: 320
    visible: true
    title: "Multimedia Player"

    Item {
        id: root
        anchors.fill: parent

        Text {
            text: "Multimedia Player Template"
            font {
                pixelSize: 100
            }
            anchors.centerIn: parent
        }
    }
}
