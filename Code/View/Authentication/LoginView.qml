import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Helpers"
import "./AuthStyles.js" as AuthStyles

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

        Row {
            anchors.fill: parent
            spacing: 0

            // Left Panel - Login Form
            Rectangle {
                id: leftPanel
                width: parent.width * AuthStyles.loginLeftPanelWidth
                height: parent.height
                color: AuthStyles.whiteColor

                ColumnLayout {
                    anchors.centerIn: parent
                    width: AuthStyles.loginFormWidth
                    spacing: AuthStyles.spacing

                    // Title
                    Text {
                        text: AuthStyles.loginTitle
                        font.pointSize: AuthStyles.loginTitleFontSize
                        font.bold: true
                        color: AuthStyles.darkTextColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Username field
                    TextField {
                        id: usernameField
                        Layout.fillWidth: true
                        placeholderText: AuthStyles.loginUsernamePlaceholder
                        font.pointSize: AuthStyles.fieldFontSize
                        color: AuthStyles.textColor
                        background: Rectangle {
                            color: AuthStyles.lightGrayColor
                            radius: AuthStyles.borderRadius
                            border.color: AuthStyles.borderColor
                            border.width: 1
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        anchors.margins: AuthStyles.margins
                        height: AuthStyles.fieldHeight
                        verticalAlignment: Text.AlignVCenter
                        onActiveFocusChanged: {
                            background.color = activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                        }
                    }

                    // Password field
                    TextField {
                        id: passwordField
                        Layout.fillWidth: true
                        placeholderText: AuthStyles.loginPasswordPlaceholder
                        echoMode: TextInput.Password
                        font.pointSize: AuthStyles.fieldFontSize
                        color: AuthStyles.textColor
                        background: Rectangle {
                            color: AuthStyles.lightGrayColor
                            radius: AuthStyles.borderRadius
                            border.color: AuthStyles.borderColor
                            border.width: 1
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        anchors.margins: AuthStyles.margins
                        height: AuthStyles.fieldHeight
                        verticalAlignment: Text.AlignVCenter
                        onActiveFocusChanged: {
                            background.color = activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                        }
                        onAccepted: authController.loginUser(usernameField.text, passwordField.text)
                    }

                    // Sign In Button
                    Button {
                        id: signInButton
                        Layout.fillWidth: true
                        text: AuthStyles.loginButtonText
                        contentItem: Text {
                            text: signInButton.text
                            font.pointSize: AuthStyles.buttonFontSize
                            font.bold: true
                            color: AuthStyles.whiteColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: signInButton.down ? AuthStyles.primaryPressedColor :
                                   signInButton.hovered ? AuthStyles.primaryHoverColor :
                                   AuthStyles.primaryColor
                            radius: AuthStyles.borderRadius
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        height: AuthStyles.fieldHeight
                        enabled: true
                        onClicked: authController.loginUser(usernameField.text, passwordField.text)
                    }

                    // Message Label
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

            // Right Panel - Welcome
            Rectangle {
                id: rightPanel
                width: parent.width * AuthStyles.loginRightPanelWidth
                height: parent.height
                color: AuthStyles.primaryColor

                ColumnLayout {
                    anchors.centerIn: parent
                    width: parent.width * AuthStyles.loginWelcomePanelContentWidth
                    spacing: AuthStyles.welcomeSpacing

                    Text {
                        text: AuthStyles.loginWelcomeTitle
                        font.pointSize: AuthStyles.welcomeTitleFontSize
                        font.bold: true
                        color: AuthStyles.whiteColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: AuthStyles.loginWelcomeMessage
                        font.pointSize: AuthStyles.welcomeTextFontSize
                        color: AuthStyles.whiteColor
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        lineHeight: AuthStyles.lineHeight
                    }

                    // Register Link
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 40
                        Layout.preferredWidth: childrenRect.width
                        Layout.preferredHeight: childrenRect.height
                        color: "transparent"

                        Text {
                            text: AuthStyles.loginRegisterLink
                            font.pointSize: AuthStyles.linkFontSize
                            color: AuthStyles.whiteColor
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: NavigationManager.navigateTo("qrc:/View/Authentication/RegisterView.qml")
                                onEntered: parent.color = AuthStyles.lightGrayColor
                                onExited: parent.color = AuthStyles.whiteColor
                                propagateComposedEvents: false
                            }
                        }
                    }
                }
            }
        }
    }

    // Auth connections
    Connections {
        target: authController

        function onLoginSuccess(message) {
            console.log(message);
            messageLabel.text = AuthStyles.loginSuccessMessage;
            messageLabel.color = AuthStyles.successColor;
            NavigationManager.navigateTo("qrc:/View/Profile/ProfileView.qml");
        }

        function onLoginFailed(message) {
            messageLabel.text = message || AuthStyles.loginFailedMessage;
            messageLabel.color = AuthStyles.errorColor;
        }
    }
}