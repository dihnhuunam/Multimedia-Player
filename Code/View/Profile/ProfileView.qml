import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Components"
import "./ProfileStyles.js" as ProfileStyles

Item {
    id: root

    // Properties to manage popup state
    property string currentField: "" // "name", "email", or "dob"
    property string currentValue: ""

    Rectangle {
        anchors.fill: parent
        color: ProfileStyles.lightBackgroundColor

        MouseArea {
            anchors.fill: parent
            onClicked: parent.focus = true
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: ProfileStyles.profileFormWidth
            spacing: ProfileStyles.profileSpacing

            // Logo and Title
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: ProfileStyles.spacing

                Text {
                    text: ProfileStyles.profileLogoText
                    font.pointSize: ProfileStyles.logoFontSize
                    font.bold: true
                    color: ProfileStyles.primaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: ProfileStyles.bannerHeight
                    color: ProfileStyles.lightGreenColor
                    radius: ProfileStyles.borderRadius

                    Text {
                        anchors.centerIn: parent
                        text: ProfileStyles.profileTitle
                        font.pointSize: ProfileStyles.profileTitleFontSize
                        font.bold: true
                        color: ProfileStyles.textColor
                    }
                }
            }

            // Profile Information
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: childrenRect.height + 2 * ProfileStyles.margins
                color: ProfileStyles.whiteColor
                radius: ProfileStyles.borderRadius
                border.color: ProfileStyles.borderColor
                border.width: 1

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: ProfileStyles.margins
                    spacing: ProfileStyles.profileSpacing

                    // Email Address
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: ProfileStyles.spacing / 2

                        Text {
                            text: ProfileStyles.profileEmailLabel
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.textColor
                        }

                        CustomText {
                            Layout.fillWidth: true
                            Layout.preferredHeight: ProfileStyles.fieldHeight
                            text: userModel.email
                            fontPointSize: ProfileStyles.fieldFontSize
                            backgroundColor: ProfileStyles.lightGrayColor
                            hoverColor: ProfileStyles.focusColor
                            textColor: ProfileStyles.textColor
                            borderColor: ProfileStyles.borderColor
                            borderRadius: ProfileStyles.borderRadius
                            textMargins: ProfileStyles.margins
                        }
                    }

                    // Full Name
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: ProfileStyles.spacing / 2

                        Text {
                            text: ProfileStyles.profileNameLabel
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.textColor
                        }

                        CustomText {
                            Layout.fillWidth: true
                            Layout.preferredHeight: ProfileStyles.fieldHeight
                            text: userModel.name
                            fontPointSize: ProfileStyles.fieldFontSize
                            backgroundColor: ProfileStyles.lightGrayColor
                            hoverColor: ProfileStyles.focusColor
                            textColor: ProfileStyles.textColor
                            borderColor: ProfileStyles.borderColor
                            borderRadius: ProfileStyles.borderRadius
                            textMargins: ProfileStyles.margins

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.currentField = "name";
                                    root.currentValue = userModel.name;
                                    editPopup.open();
                                }
                            }
                        }
                    }

                    // Date of Birth
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: ProfileStyles.spacing / 2

                        Text {
                            text: ProfileStyles.profileBirthDateLabel
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.textColor
                        }

                        CustomText {
                            Layout.fillWidth: true
                            Layout.preferredHeight: ProfileStyles.fieldHeight
                            text: Qt.formatDate(userModel.dateOfBirth, "yyyy-MM-dd")
                            fontPointSize: ProfileStyles.fieldFontSize
                            backgroundColor: ProfileStyles.lightGrayColor
                            hoverColor: ProfileStyles.focusColor
                            textColor: ProfileStyles.textColor
                            borderColor: ProfileStyles.borderColor
                            borderRadius: ProfileStyles.borderRadius
                            textMargins: ProfileStyles.margins

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.currentField = "dob";
                                    root.currentValue = Qt.formatDate(userModel.dateOfBirth, "yyyy-MM-dd");
                                    editPopup.open();
                                }
                            }
                        }
                    }

                    // Back to Home link
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: ProfileStyles.profileSpacing / 2
                        Layout.preferredWidth: childrenRect.width
                        Layout.preferredHeight: childrenRect.height
                        color: "transparent"

                        Text {
                            text: ProfileStyles.profileBackLink
                            font.pointSize: ProfileStyles.linkFontSize
                            color: ProfileStyles.primaryColor
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: NavigationManager.navigateTo("qrc:/View/HomeView.qml")
                                onEntered: parent.color = ProfileStyles.primaryHoverColor
                                onExited: parent.color = ProfileStyles.primaryColor
                            }
                        }
                    }
                }
            }
        }
    }

    // Popup for editing
    Popup {
        id: editPopup
        anchors.centerIn: parent
        width: ProfileStyles.editPopUpFormWidth
        height: ProfileStyles.editPopUpFormHeight
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Rectangle {
            anchors.fill: parent
            color: ProfileStyles.whiteColor
            radius: ProfileStyles.borderRadius
            border.color: ProfileStyles.borderColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: ProfileStyles.margins
                spacing: ProfileStyles.profileSpacing

                Text {
                    text: "Edit " + (root.currentField === "name" ? ProfileStyles.profileNameLabel : root.currentField === "email" ? ProfileStyles.profileEmailLabel : ProfileStyles.profileBirthDateLabel)
                    font.pointSize: ProfileStyles.fieldFontSize
                    font.bold: true
                    color: ProfileStyles.textColor
                    Layout.alignment: Qt.AlignHCenter
                }

                TextField {
                    id: editTextField
                    Layout.fillWidth: true
                    Layout.preferredHeight: ProfileStyles.fieldHeight
                    text: root.currentValue
                    font.pointSize: ProfileStyles.fieldFontSize
                    color: ProfileStyles.textColor
                    background: Rectangle {
                        color: ProfileStyles.lightGrayColor
                        radius: ProfileStyles.borderRadius
                        border.color: ProfileStyles.borderColor
                        border.width: 1
                    }
                    leftPadding: ProfileStyles.margins
                    verticalAlignment: Text.AlignVCenter
                    validator: RegularExpressionValidator {
                        regularExpression: root.currentField === "dob" ? /^\d{4}-\d{2}-\d{2}$/ : root.currentField === "email" ? /^[^\s@]+@[^\s@]+\.[^\s@]+$/ : /.*/
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: ProfileStyles.spacing

                    CustomButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Save Changes"
                        backgroundColor: ProfileStyles.primaryColor
                        hoverColor: ProfileStyles.primaryHoverColor
                        pressedColor: ProfileStyles.primaryPressedColor
                        textColor: ProfileStyles.whiteColor
                        borderRadius: ProfileStyles.borderRadius

                        onClicked: {
                            if (root.currentField === "name") {
                                userModel.name = editTextField.text;
                            } else if (root.currentField === "email") {
                                userModel.email = editTextField.text;
                            } else if (root.currentField === "dob") {
                                var date = Date.fromLocaleString(Qt.locale(), editTextField.text, "yyyy-MM-dd");
                                if (date.toString() !== "Invalid Date") {
                                    userModel.dateOfBirth = date;
                                }
                            }
                            editPopup.close();
                        }
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Cancel"
                        backgroundColor: ProfileStyles.lightGrayColor
                        hoverColor: ProfileStyles.focusColor
                        pressedColor: ProfileStyles.lightGrayColor
                        textColor: ProfileStyles.textColor
                        borderRadius: ProfileStyles.borderRadius

                        onClicked: {
                            editPopup.close();
                        }
                    }
                }
            }
        }
    }
}
