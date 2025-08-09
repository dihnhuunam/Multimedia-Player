import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: "Login Demo"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        // Thông báo khởi tạo
        Text {
            id: initText
            text: "Running initial login tests..."
            color: "blue"
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }

        // Nhập email
        TextField {
            id: emailField
            placeholderText: "Enter email"
            Layout.fillWidth: true
            text: "nam@gmail.com" // Giá trị mặc định
        }

        // Nhập password
        TextField {
            id: passwordField
            placeholderText: "Enter password"
            echoMode: TextInput.Password
            Layout.fillWidth: true
            text: "Nam1234" // Giá trị mặc định
        }

        // Nút đăng nhập
        Button {
            text: "Login"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                authController.loginUser(emailField.text, passwordField.text);
            }
        }

        // Hiển thị kết quả
        Text {
            id: resultText
            text: "Login result will appear here"
            color: "black"
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }
    }

    // Kết nối với tín hiệu loginResult từ authController
    Connections {
        target: authController
        function onLoginSuccessed(message) {
            initText.text = "";
            resultText.text = "Login successful: " + message;
            resultText.color = "green";
        }

        function onLoginFailed(message) {
            resultText.text = "Login failed: " + message;
            resultText.color = "red";
        }
    }
}
