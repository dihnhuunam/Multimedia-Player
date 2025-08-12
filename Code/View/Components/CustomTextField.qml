import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    // Public properties - using alias to expose TextField properties
    property alias text: textField.text
    property alias placeholderText: textField.placeholderText
    property alias echoMode: textField.echoMode
    property alias font: textField.font
    property alias validator: textField.validator

    // Custom property instead of alias to avoid conflict
    property color textColor: "#333"

    // Customizable appearance
    property color backgroundColor: "#f0f0f0"
    property color focusColor: "#e0e0e0"
    property int borderRadius: 5
    property int textMargins: 15

    // Custom signals
    signal accepted

    // Default appearance
    height: 50
    color: textField.activeFocus ? focusColor : backgroundColor
    radius: borderRadius

    // Smooth color transition
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    // Smooth scale animation when focus changes
    scale: textField.activeFocus ? 1.03 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }

    TextField {
        id: textField
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: parent.textMargins
        background: null
        font.pointSize: 14
        color: root.textColor

        onAccepted: root.accepted()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: textField.forceActiveFocus()
        propagateComposedEvents: false
    }
}
