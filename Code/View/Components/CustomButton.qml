import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    // Public properties
    property alias text: buttonText.text
    property alias font: buttonText.font
    property color backgroundColor: "#4CAF50"
    property color hoverColor: "#45a049"
    property color pressedColor: "#3d8b40"
    property color textColor: "white"
    property int borderRadius: 5
    property bool enabled: true

    // Signals
    signal clicked
    signal pressed
    signal released

    // Default appearance
    height: 50
    color: {
        if (!enabled)
            return Qt.darker(backgroundColor, 1.5);
        if (mouseArea.pressed)
            return pressedColor;
        if (mouseArea.containsMouse)
            return hoverColor;
        return backgroundColor;
    }
    radius: borderRadius
    opacity: enabled ? 1.0 : 0.6

    // Smooth transitions
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        color: textColor
        font.pointSize: 16
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.clicked()
        onPressed: root.pressed()
        onReleased: root.released()

        propagateComposedEvents: false
    }
}
