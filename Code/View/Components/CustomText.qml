import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    // Public properties
    property string text: ""
    property int fontPointSize: 14
    property color textColor: "#333"
    property color backgroundColor: "#f0f0f0"
    property color hoverColor: "#e0e0e0"
    property color borderColor: "#ced4da"
    property int borderRadius: 5
    property int textMargins: 15

    // Default appearance
    height: 50
    color: mouseArea.containsMouse ? hoverColor : backgroundColor
    radius: borderRadius
    border.color: borderColor
    border.width: 1

    // Smooth color transition
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Text {
        id: textElement
        anchors.fill: parent
        anchors.margins: root.textMargins
        text: root.text
        font.pointSize: root.fontPointSize
        color: root.textColor
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
