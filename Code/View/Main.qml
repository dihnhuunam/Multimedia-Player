import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    visible: true
    width: 400
    height: 500
    title: "Login"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        Text {
            text: "Login"
            font.bold: true
            font.pixelSize: 16
            Layout.fillWidth: true
        }

        TextField {
            id: emailField
            placeholderText: "Email"
            Layout.fillWidth: true
        }

        TextField {
            id: passwordField
            placeholderText: "Password"
            echoMode: TextInput.Password
            Layout.fillWidth: true
        }

        Button {
            text: "Login"
            Layout.fillWidth: true
            onClicked: {
                if (emailField.text === "" || passwordField.text === "") {
                    statusMessage.text = "Please enter email and password";
                    statusMessage.messageColor = "red";
                } else {
                    authController.loginUser(emailField.text, passwordField.text);
                }
            }
        }

        Text {
            text: authController.getUserModel.getEmail !== "" ? "User Information" : ""
            font.bold: true
            font.pixelSize: 16
            Layout.fillWidth: true
            Layout.topMargin: 20
        }

        ColumnLayout {
            visible: authController.getUserModel.getEmail !== ""
            Layout.fillWidth: true
            Text {
                text: "Email: " + authController.getUserModel.getEmail
            }
            Text {
                text: "Name: " + authController.getUserModel.getName
            }
            // Text {
            //     text: authController.getUserModel.dateOfBirth.isValid ? "Date of Birth: " + Qt.formatDate(authController.getUserModel.dateOfBirth, "dd/MM/yyyy") : "Date of Birth: N/A"
            // }
        }

        Text {
            id: statusMessage
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            color: messageColor
            property string messageColor: "black"
        }

        Item {
            Layout.fillHeight: true
        }
    }

    Connections {
        target: authController
        function onLoginSuccessed(message) {
            statusMessage.text = message;
            statusMessage.messageColor = "green";
        }
        function onLoginFailed(message) {
            statusMessage.text = message;
            statusMessage.messageColor = "red";
        }
    }
}
