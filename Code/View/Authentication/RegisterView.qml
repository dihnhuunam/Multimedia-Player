import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Helper"
import "../Components"
import "./AuthConstants.js" as AuthConstants
import "../Helper/RegisterHelper.js" as RegisterHelper

Item {
    id: root

    // Properties
    property alias firstName: firstNameField.text
    property alias lastName: lastNameField.text
    property alias email: emailField.text
    property alias birthMonth: monthComboBox.currentIndex
    property alias birthDay: dayComboBox.currentIndex
    property alias birthYear: yearComboBox.currentIndex

    // Signals
    signal registerUser
    signal navigateToLogin

    Rectangle {
        anchors.fill: parent
        color: AuthConstants.lightBackgroundColor

        // MouseArea to remove focus of TextField
        MouseArea {
            anchors.fill: parent
            onClicked: parent.focus = true
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: AuthConstants.registerFormWidth
            spacing: AuthConstants.registerSpacing

            // Logo and Title
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: AuthConstants.spacing

                // Logo
                Text {
                    text: AuthConstants.registerLogoText
                    font.pointSize: AuthConstants.logoFontSize
                    font.bold: true
                    color: AuthConstants.primaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                // Title banner
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: AuthConstants.bannerHeight
                    color: AuthConstants.lightGreenColor
                    radius: AuthConstants.borderRadius

                    Text {
                        anchors.centerIn: parent
                        text: AuthConstants.registerTitle
                        font.pointSize: AuthConstants.registerTitleFontSize
                        font.bold: true
                        color: AuthConstants.textColor
                    }
                }
            }

            // Registration Form
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: childrenRect.height + 2 * AuthConstants.margins
                color: AuthConstants.whiteColor
                radius: AuthConstants.borderRadius
                border.color: AuthConstants.borderColor
                border.width: 1

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: AuthConstants.margins
                    spacing: AuthConstants.registerSpacing

                    // First Name and Last Name row
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: AuthConstants.spacing

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: AuthConstants.spacing / 2

                            Text {
                                text: AuthConstants.registerFirstNameLabel
                                font.pointSize: AuthConstants.fieldFontSize
                                font.bold: true
                                color: AuthConstants.textColor
                            }

                            CustomTextField {
                                id: firstNameField
                                Layout.fillWidth: true
                                placeholderText: AuthConstants.registerFirstNameLabel
                                Layout.preferredHeight: AuthConstants.fieldHeight
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: AuthConstants.spacing / 2

                            Text {
                                text: AuthConstants.registerLastNameLabel
                                font.pointSize: AuthConstants.fieldFontSize
                                font.bold: true
                                color: AuthConstants.textColor
                            }

                            CustomTextField {
                                id: lastNameField
                                Layout.fillWidth: true
                                placeholderText: AuthConstants.registerLastNameLabel
                                Layout.preferredHeight: AuthConstants.fieldHeight
                            }
                        }
                    }

                    // Email Address
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AuthConstants.spacing / 2

                        Text {
                            text: AuthConstants.registerEmailLabel
                            font.pointSize: AuthConstants.fieldFontSize
                            font.bold: true
                            color: AuthConstants.textColor
                        }

                        CustomTextField {
                            id: emailField
                            Layout.fillWidth: true
                            placeholderText: AuthConstants.registerEmailLabel
                            Layout.preferredHeight: AuthConstants.fieldHeight
                        }
                    }

                    // Password
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AuthConstants.spacing / 2

                        Text {
                            text: AuthConstants.registerPasswordLabel
                            font.pointSize: AuthConstants.fieldFontSize
                            font.bold: true
                            color: AuthConstants.textColor
                        }

                        CustomTextField {
                            id: passwordField
                            Layout.fillWidth: true
                            placeholderText: AuthConstants.registerPasswordPlaceholder
                            Layout.preferredHeight: AuthConstants.fieldHeight
                            echoMode: TextInput.Password
                        }
                    }

                    // Date of Birth
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AuthConstants.spacing / 2

                        Text {
                            text: AuthConstants.registerBirthDateLabel
                            font.pointSize: AuthConstants.fieldFontSize
                            font.bold: true
                            color: AuthConstants.textColor
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: AuthConstants.spacing / 2
                            Layout.alignment: Qt.AlignHCenter

                            CustomComboBox {
                                id: monthComboBox
                                Layout.preferredWidth: 140
                                Layout.preferredHeight: AuthConstants.fieldHeight
                                model: ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                                currentIndex: 0
                                font.pointSize: AuthConstants.fieldFontSize
                                backgroundColor: AuthConstants.lightGrayColor
                                focusColor: AuthConstants.focusColor
                                textColor: AuthConstants.textColor
                                borderColor: AuthConstants.borderColor
                                popupBackgroundColor: AuthConstants.whiteColor
                                highlightColor: AuthConstants.primaryColor
                                borderRadius: AuthConstants.borderRadius
                                textMargins: AuthConstants.margins
                                fieldHeight: AuthConstants.fieldHeight
                            }

                            CustomComboBox {
                                id: dayComboBox
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: AuthConstants.fieldHeight
                                model: {
                                    var days = ["Day"];
                                    for (var i = 1; i <= 31; i++) {
                                        days.push(i.toString());
                                    }
                                    return days;
                                }
                                currentIndex: 0
                                font.pointSize: AuthConstants.fieldFontSize
                                backgroundColor: AuthConstants.lightGrayColor
                                focusColor: AuthConstants.focusColor
                                textColor: AuthConstants.textColor
                                borderColor: AuthConstants.borderColor
                                popupBackgroundColor: AuthConstants.whiteColor
                                highlightColor: AuthConstants.primaryColor
                                borderRadius: AuthConstants.borderRadius
                                textMargins: AuthConstants.margins
                                fieldHeight: AuthConstants.fieldHeight
                            }

                            CustomComboBox {
                                id: yearComboBox
                                Layout.preferredWidth: 120
                                Layout.preferredHeight: AuthConstants.fieldHeight
                                model: {
                                    var years = ["Year"];
                                    var currentYear = new Date().getFullYear();
                                    for (var i = currentYear; i >= currentYear - 100; i--) {
                                        years.push(i.toString());
                                    }
                                    return years;
                                }
                                currentIndex: 0
                                font.pointSize: AuthConstants.fieldFontSize
                                backgroundColor: AuthConstants.lightGrayColor
                                focusColor: AuthConstants.focusColor
                                textColor: AuthConstants.textColor
                                borderColor: AuthConstants.borderColor
                                popupBackgroundColor: AuthConstants.whiteColor
                                highlightColor: AuthConstants.primaryColor
                                borderRadius: AuthConstants.borderRadius
                                textMargins: AuthConstants.margins
                                fieldHeight: AuthConstants.fieldHeight
                            }

                            // Calendar icon
                            Rectangle {
                                Layout.preferredWidth: AuthConstants.fieldHeight
                                Layout.preferredHeight: AuthConstants.fieldHeight
                                color: AuthConstants.lightBackgroundColor
                                border.color: AuthConstants.borderColor
                                border.width: 1
                                radius: AuthConstants.borderRadius

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
                        Layout.topMargin: AuthConstants.registerSpacing
                        text: AuthConstants.registerButtonText
                        backgroundColor: AuthConstants.primaryColor
                        hoverColor: AuthConstants.primaryHoverColor
                        pressedColor: AuthConstants.primaryPressedColor
                        onClicked: {
                            var dob = RegisterHelper.formatDateOfBirth(monthComboBox.currentIndex, dayComboBox.currentIndex, yearComboBox.currentIndex, yearComboBox.model);
                            var name = RegisterHelper.getFullName(firstNameField.text, lastNameField.text);
                            if (name === "" || emailField.text === "" || passwordField.text === "" || dob === "") {
                                messageLabel.text = "Please fill in all fields";
                                messageLabel.color = AuthConstants.errorColor;
                                return;
                            }
                            authController.registerUser(emailField.text, passwordField.text, name, dob);
                        }
                    }

                    // Back to Login link
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: AuthConstants.registerSpacing / 2
                        Layout.preferredWidth: childrenRect.width
                        Layout.preferredHeight: childrenRect.height
                        color: "transparent"

                        Text {
                            text: AuthConstants.registerLoginLink
                            font.pointSize: AuthConstants.linkFontSize
                            color: AuthConstants.primaryColor
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: NavigationManager.navigateTo("qrc:/View/Authentication/LoginView.qml")
                                onEntered: parent.color = AuthConstants.primaryHoverColor
                                onExited: parent.color = AuthConstants.primaryColor
                            }
                        }
                    }

                    // Error/Success message
                    Label {
                        id: messageLabel
                        text: ""
                        font.pointSize: AuthConstants.messageFontSize
                        color: AuthConstants.errorColor
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
            messageLabel.text = AuthConstants.registerSuccessMessage;
            messageLabel.color = AuthConstants.successColor;
        }

        function onRegisterFailed(message) {
            messageLabel.text = message || AuthConstants.registerFailedMessage;
            messageLabel.color = AuthConstants.errorColor;
        }
    }
}
