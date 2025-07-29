import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: window
    width: 640
    height: 320
    visible: true

    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: nameInput
            width: 200
            text: controller.name
            placeholderText: "Enter your name"
            onTextChanged: controller.name = text
        }

        Text {
            text: "Name: " + (controller.name.length > 0 ? controller.name : "Empty")
        }
    }
}
