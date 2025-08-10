import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Helper"

Item {
    property alias username: usernameField.text
    property alias password: passwordField.text

    // Signals for navigation
    signal skipLogin
    signal navigateToRegister
    signal facebookLogin
    signal googleLogin
    signal linkedinLogin

    Rectangle {
        anchors.fill: parent
        color: "#d3d3d3"  // Light gray background

        Row {
            anchors.fill: parent
            spacing: 0

            // Left side - Login Form
            Rectangle {
                width: parent.width * 0.5
                height: parent.height
                color: "white"

                ColumnLayout {
                    anchors.centerIn: parent
                    width: 350
                    spacing: 25

                    // Title
                    Text {
                        text: "Signin"
                        font.pointSize: 36
                        font.bold: true
                        color: "#2c3e50"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Username field
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        color: "#f0f0f0"
                        radius: 5

                        TextField {
                            id: usernameField
                            anchors.fill: parent
                            anchors.margins: 15
                            placeholderText: "ByteWebster"
                            font.pointSize: 14
                            color: "#333"
                            background: Rectangle {
                                color: "transparent"
                            }
                        }
                    }

                    // Password field
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        color: "#f0f0f0"
                        radius: 5

                        TextField {
                            id: passwordField
                            anchors.fill: parent
                            anchors.margins: 15
                            placeholderText: "•••••••"
                            echoMode: TextInput.Password
                            font.pointSize: 14
                            color: "#333"
                            background: Rectangle {
                                color: "transparent"
                            }
                        }
                    }

                    // Signin Button
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        color: "#4CAF50"  // Green color
                        radius: 5

                        Text {
                            anchors.centerIn: parent
                            text: "Signin"
                            color: "white"
                            font.pointSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                authController.loginUser(usernameField.text, passwordField.text);
                            }
                            onPressed: parent.color = "#45a049"
                            onReleased: parent.color = "#4CAF50"
                        }
                    }

                    // Or signin with text
                    Text {
                        text: "or signin with"
                        font.pointSize: 14
                        color: "#666"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 10
                    }

                    // Social login buttons
                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 15

                        // Facebook
                        Rectangle {
                            width: 45
                            height: 45
                            radius: 22.5
                            color: "#3b5998"

                            Text {
                                anchors.centerIn: parent
                                text: "f"
                                color: "white"
                                font.pointSize: 20
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: facebookLogin()
                            }
                        }

                        // Google
                        Rectangle {
                            width: 45
                            height: 45
                            radius: 22.5
                            color: "#dd4b39"

                            Text {
                                anchors.centerIn: parent
                                text: "G+"
                                color: "white"
                                font.pointSize: 12
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: googleLogin()
                            }
                        }

                        // LinkedIn
                        Rectangle {
                            width: 45
                            height: 45
                            radius: 22.5
                            color: "#0077b5"

                            Text {
                                anchors.centerIn: parent
                                text: "in"
                                color: "white"
                                font.pointSize: 14
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: linkedinLogin()
                            }
                        }
                    }

                    // Error/Success message
                    Label {
                        id: messageLabel
                        text: ""
                        font.pointSize: 12
                        color: "#e74c3c"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }

            // Right side - Welcome Panel
            Rectangle {
                width: parent.width * 0.5
                height: parent.height
                color: "#4CAF50"  // Green background

                ColumnLayout {
                    anchors.centerIn: parent
                    width: parent.width * 0.7
                    spacing: 30

                    Text {
                        text: "Welcome back!"
                        font.pointSize: 32
                        font.bold: true
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Welcome back! We are so happy to have you here. It's great to see you again. We hope you had a safe and enjoyable time away."
                        font.pointSize: 16
                        color: "white"
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        lineHeight: 1.3
                    }

                    // Register link
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 40
                        width: childrenRect.width
                        height: childrenRect.height
                        color: "transparent"

                        Text {
                            text: "No account yet? Signup."
                            font.pointSize: 16
                            color: "white"
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: navigateToRegister()

                                onEntered: parent.color = "#f0f0f0"
                                onExited: parent.color = "white"
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: authController

        function onLoginSuccessed(message) {
            console.log(message);
            messageLabel.text = "Login successful!";
            messageLabel.color = "#27ae60";
        }

        function onLoginFailed(message) {
            messageLabel.text = message || "Login failed!";
            messageLabel.color = "#e74c3c";
        }
    }
}
