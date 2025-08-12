import QtQuick
import QtQuick.Controls

ComboBox {
    id: root

    // Public properties
    property color backgroundColor: "#f0f0f0"
    property color focusColor: "#e0e0e0"
    property color textColor: "#495057"
    property color borderColor: "#ced4da"
    property color popupBackgroundColor: "#ffffff"
    property color highlightColor: "#4CAF50"
    property int borderRadius: 5
    property int textMargins: 15
    property int fieldHeight: 50

    property int popupMaxHeight: 280

    implicitHeight: fieldHeight

    background: Rectangle {
        color: root.activeFocus ? root.focusColor : root.backgroundColor
        border.color: root.borderColor
        border.width: 1
        radius: root.borderRadius

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    contentItem: Text {
        text: root.currentText
        font: root.font
        color: root.textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: root.textMargins
        elide: Text.ElideRight
    }

    indicator: Rectangle {
        x: root.width - width - root.rightPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        width: 12
        height: 8
        color: "transparent"

        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.moveTo(0, 0);
                ctx.lineTo(width, 0);
                ctx.lineTo(width / 2, height);
                ctx.closePath();
                ctx.fillStyle = root.textColor;
                ctx.fill();
            }
        }
    }

    popup: Popup {
        y: root.height
        width: root.width
        padding: 1

        height: Math.min(contentItem.contentHeight, root.popupMaxHeight)

        contentItem: ListView {
            anchors.fill: parent

            clip: true
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            color: root.popupBackgroundColor
            border.color: root.borderColor
            radius: root.borderRadius
        }
    }

    delegate: ItemDelegate {
        width: root.width
        height: 40

        contentItem: Text {
            text: modelData
            color: highlighted ? root.popupBackgroundColor : root.textColor
            font: root.font
            verticalAlignment: Text.AlignVCenter
            leftPadding: root.textMargins
        }

        background: Rectangle {
            color: highlighted ? root.highlightColor : "transparent"
            radius: root.borderRadius
        }
    }
}
