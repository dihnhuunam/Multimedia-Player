import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Helper"
import "../Components"
import "./AuthConstants.js" as AuthConstants

Item {
    id: root

    // Properties
    property alias username: usernameField.text
    property alias password: passwordField.text

    Rectangle {
        anchors.fill: parent
        color: AuthConstants.lightBackgroundColor

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
                width: parent.width * AuthConstants.loginLeftPanelWidth
                height: parent.height
                color: AuthConstants.whiteColor

                ColumnLayout {
                    anchors.centerIn: parent
                    width: AuthConstants.loginFormWidth
                    spacing: AuthConstants.spacing

                    // Title
                    Text {
                        text: AuthConstants.loginTitle
                        font.pointSize: AuthConstants.loginTitleFontSize
                        font.bold: true
                        color: AuthConstants.darkTextColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Username field
                    CustomTextField {
                        id: usernameField
                        Layout.fillWidth: true
                        placeholderText: AuthConstants.loginUsernamePlaceholder
                    }

                    // Password field
                    CustomTextField {
                        id: passwordField
                        Layout.fillWidth: true
                        placeholderText: AuthConstants.loginPasswordPlaceholder
                        echoMode: TextInput.Password
                        onAccepted: authController.loginUser(usernameField.text, passwordField.text)
                    }

                    // Sign In Button
                    CustomButton {
                        Layout.fillWidth: true
                        text: AuthConstants.loginButtonText
                        backgroundColor: AuthConstants.primaryColor
                        hoverColor: AuthConstants.primaryHoverColor
                        pressedColor: AuthConstants.primaryPressedColor
                        onClicked: authController.loginUser(usernameField.text, passwordField.text)
                    }

                    // Message Label
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

            // Right Panel - Welcome
            Rectangle {
                id: rightPanel
                width: parent.width * AuthConstants.loginRightPanelWidth
                height: parent.height
                color: AuthConstants.primaryColor

                ColumnLayout {
                    anchors.centerIn: parent
                    width: parent.width * AuthConstants.loginWelcomePanelContentWidth
                    spacing: AuthConstants.welcomeSpacing

                    Text {
                        text: AuthConstants.loginWelcomeTitle
                        font.pointSize: AuthConstants.welcomeTitleFontSize
                        font.bold: true
                        color: AuthConstants.whiteColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: AuthConstants.loginWelcomeMessage
                        font.pointSize: AuthConstants.welcomeTextFontSize
                        color: AuthConstants.whiteColor
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        lineHeight: AuthConstants.lineHeight
                    }

                    // Register Link
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 40
                        Layout.preferredWidth: childrenRect.width
                        Layout.preferredHeight: childrenRect.height
                        color: "transparent"

                        Text {
                            text: AuthConstants.loginRegisterLink
                            font.pointSize: AuthConstants.linkFontSize
                            color: AuthConstants.whiteColor
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: NavigationManager.navigateTo("qrc:/View/Authentication/RegisterView.qml")
                                onEntered: parent.color = AuthConstants.lightGrayColor
                                onExited: parent.color = AuthConstants.whiteColor
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
            messageLabel.text = AuthConstants.loginSuccessMessage;
            messageLabel.color = AuthConstants.successColor;
        }

        function onLoginFailed(message) {
            messageLabel.text = message || AuthConstants.loginFailedMessage;
            messageLabel.color = AuthConstants.errorColor;
        }
    }
}
