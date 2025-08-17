import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Helpers"
import "../Components"
import "./AuthStyles.js" as AuthStyles
import "../Helpers/RegisterHelper.js" as RegisterHelper

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: AuthStyles.lightBackgroundColor

        // MouseArea to remove focus of TextField
        MouseArea {
            anchors.fill: parent
            onClicked: parent.focus = true
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: AuthStyles.registerFormWidth
            spacing: AuthStyles.registerSpacing

            // Logo and Title
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: AuthStyles.spacing

                // Logo
                Text {
                    text: AuthStyles.registerLogoText
                    font.pointSize: AuthStyles.logoFontSize
                    font.bold: true
                    color: AuthStyles.primaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                // Title banner
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: AuthStyles.bannerHeight
                    color: AuthStyles.lightGreenColor
                    radius: AuthStyles.borderRadius

                    Text {
                        anchors.centerIn: parent
                        text: AuthStyles.registerTitle
                        font.pointSize: AuthStyles.registerTitleFontSize
                        font.bold: true
                        color: AuthStyles.textColor
                    }
                }
            }

            // Registration Form
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: childrenRect.height + 2 * AuthStyles.margins
                color: AuthStyles.whiteColor
                radius: AuthStyles.borderRadius
                border.color: AuthStyles.borderColor
                border.width: 1

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: AuthStyles.margins
                    spacing: AuthStyles.registerSpacing

                    // First Name and Last Name row
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: AuthStyles.spacing

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: AuthStyles.spacing / 2

                            Text {
                                text: AuthStyles.registerFirstNameLabel
                                font.pointSize: AuthStyles.fieldFontSize
                                font.bold: true
                                color: AuthStyles.textColor
                            }

                            CustomTextField {
                                id: firstNameField
                                Layout.fillWidth: true
                                placeholderText: AuthStyles.registerFirstNameLabel
                                Layout.preferredHeight: AuthStyles.fieldHeight
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: AuthStyles.spacing / 2

                            Text {
                                text: AuthStyles.registerLastNameLabel
                                font.pointSize: AuthStyles.fieldFontSize
                                font.bold: true
                                color: AuthStyles.textColor
                            }

                            CustomTextField {
                                id: lastNameField
                                Layout.fillWidth: true
                                placeholderText: AuthStyles.registerLastNameLabel
                                Layout.preferredHeight: AuthStyles.fieldHeight
                            }
                        }
                    }

                    // Email Address
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AuthStyles.spacing / 2

                        Text {
                            text: AuthStyles.registerEmailLabel
                            font.pointSize: AuthStyles.fieldFontSize
                            font.bold: true
                            color: AuthStyles.textColor
                        }

                        CustomTextField {
                            id: emailField
                            Layout.fillWidth: true
                            placeholderText: AuthStyles.registerEmailLabel
                            Layout.preferredHeight: AuthStyles.fieldHeight
                        }
                    }

                    // Password
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AuthStyles.spacing / 2

                        Text {
                            text: AuthStyles.registerPasswordLabel
                            font.pointSize: AuthStyles.fieldFontSize
                            font.bold: true
                            color: AuthStyles.textColor
                        }

                        CustomTextField {
                            id: passwordField
                            Layout.fillWidth: true
                            placeholderText: AuthStyles.registerPasswordPlaceholder
                            Layout.preferredHeight: AuthStyles.fieldHeight
                            echoMode: TextInput.Password
                        }
                    }

                    // Date of Birth
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AuthStyles.spacing / 2

                        Text {
                            text: AuthStyles.registerBirthDateLabel
                            font.pointSize: AuthStyles.fieldFontSize
                            font.bold: true
                            color: AuthStyles.textColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: AuthStyles.spacing / 2
                            Layout.alignment: Qt.AlignHCenter

                            CustomComboBox {
                                id: monthComboBox
                                Layout.preferredWidth: 140
                                Layout.preferredHeight: AuthStyles.fieldHeight
                                model: ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                                currentIndex: 0
                                font.pointSize: AuthStyles.fieldFontSize
                                backgroundColor: AuthStyles.lightGrayColor
                                focusColor: AuthStyles.focusColor
                                textColor: AuthStyles.textColor
                                borderColor: AuthStyles.borderColor
                                popupBackgroundColor: AuthStyles.whiteColor
                                highlightColor: AuthStyles.primaryColor
                                borderRadius: AuthStyles.borderRadius
                                textMargins: AuthStyles.margins
                                fieldHeight: AuthStyles.fieldHeight
                            }

                            CustomComboBox {
                                id: dayComboBox
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: AuthStyles.fieldHeight
                                model: {
                                    var days = ["Day"];
                                    for (var i = 1; i <= 31; i++) {
                                        days.push(i.toString());
                                    }
                                    return days;
                                }
                                currentIndex: 0
                                font.pointSize: AuthStyles.fieldFontSize
                                backgroundColor: AuthStyles.lightGrayColor
                                focusColor: AuthStyles.focusColor
                                textColor: AuthStyles.textColor
                                borderColor: AuthStyles.borderColor
                                popupBackgroundColor: AuthStyles.whiteColor
                                highlightColor: AuthStyles.primaryColor
                                borderRadius: AuthStyles.borderRadius
                                textMargins: AuthStyles.margins
                                fieldHeight: AuthStyles.fieldHeight
                            }

                            CustomComboBox {
                                id: yearComboBox
                                Layout.preferredWidth: 120
                                Layout.preferredHeight: AuthStyles.fieldHeight
                                model: {
                                    var years = ["Year"];
                                    var currentYear = new Date().getFullYear();
                                    for (var i = currentYear; i >= currentYear - 100; i--) {
                                        years.push(i.toString());
                                    }
                                    return years;
                                }
                                currentIndex: 0
                                font.pointSize: AuthStyles.fieldFontSize
                                backgroundColor: AuthStyles.lightGrayColor
                                focusColor: AuthStyles.focusColor
                                textColor: AuthStyles.textColor
                                borderColor: AuthStyles.borderColor
                                popupBackgroundColor: AuthStyles.whiteColor
                                highlightColor: AuthStyles.primaryColor
                                borderRadius: AuthStyles.borderRadius
                                textMargins: AuthStyles.margins
                                fieldHeight: AuthStyles.fieldHeight
                            }

                            // Calendar icon
                            Rectangle {
                                Layout.preferredWidth: AuthStyles.fieldHeight
                                Layout.preferredHeight: AuthStyles.fieldHeight
                                color: AuthStyles.lightBackgroundColor
                                border.color: AuthStyles.borderColor
                                border.width: 1
                                radius: AuthStyles.borderRadius

                                Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/Assets/calendar.png"
                                    width: 24
                                    height: 24
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: console.log("Calendar clicked")
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // Register Button
                    CustomButton {
                        Layout.fillWidth: true
                        Layout.topMargin: AuthStyles.registerSpacing
                        text: AuthStyles.registerButtonText
                        backgroundColor: AuthStyles.primaryColor
                        hoverColor: AuthStyles.primaryHoverColor
                        pressedColor: AuthStyles.primaryPressedColor
                        onClicked: {
                            var dob = RegisterHelper.formatDateOfBirth(monthComboBox.currentIndex, dayComboBox.currentIndex, yearComboBox.currentIndex, yearComboBox.model);
                            var name = RegisterHelper.getFullName(firstNameField.text, lastNameField.text);
                            if (name === "" || emailField.text === "" || passwordField.text === "" || dob === "") {
                                messageLabel.text = "Please fill in all fields";
                                messageLabel.color = AuthStyles.errorColor;
                                return;
                            }
                            authController.registerUser(emailField.text, passwordField.text, name, dob);
                        }
                    }

                    // Back to Login link
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: AuthStyles.registerSpacing / 2
                        Layout.preferredWidth: childrenRect.width
                        Layout.preferredHeight: childrenRect.height
                        color: "transparent"

                        Text {
                            text: AuthStyles.registerLoginLink
                            font.pointSize: AuthStyles.linkFontSize
                            color: AuthStyles.primaryColor
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: NavigationManager.navigateTo("qrc:/View/Authentication/LoginView.qml")
                                onEntered: parent.color = AuthStyles.primaryHoverColor
                                onExited: parent.color = AuthStyles.primaryColor
                            }
                        }
                    }

                    // Error/Success message
                    Label {
                        id: messageLabel
                        text: ""
                        font.pointSize: AuthStyles.messageFontSize
                        color: AuthStyles.errorColor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    // Auth connections
    Connections {
        target: authController
        function onRegisterSuccess(message) {
            messageLabel.text = AuthStyles.registerSuccessMessage;
            messageLabel.color = AuthStyles.successColor;
        }

        function onRegisterFailed(message) {
            messageLabel.text = message || AuthStyles.registerFailedMessage;
            messageLabel.color = AuthStyles.errorColor;
        }
    }
}
