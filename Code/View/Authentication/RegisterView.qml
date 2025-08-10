import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Helper"

Item {
    property alias firstName: firstNameField.text
    property alias lastName: lastNameField.text
    property alias email: emailField.text
    property alias company: companyField.text
    property alias address: addressField.text
    property alias birthMonth: monthComboBox.currentIndex
    property alias birthDay: dayComboBox.currentIndex
    property alias birthYear: yearComboBox.currentIndex

    // Signals for navigation
    signal registerUser
    signal navigateToLogin

    Rectangle {
        anchors.fill: parent
        color: "#f8f9fa"

        ColumnLayout {
            anchors.centerIn: parent
            width: 500
            spacing: 20

            // Logo and Title
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                // Logo (using text as placeholder)
                Text {
                    text: "👥 YourEvent"
                    font.pointSize: 24
                    font.bold: true
                    color: "#28a745"
                    Layout.alignment: Qt.AlignHCenter
                }

                // Title banner
                Rectangle {
                    Layout.fillWidth: true
                    height: 50
                    color: "#e8f5e8"
                    radius: 8

                    Text {
                        anchors.centerIn: parent
                        text: "Online Registration"
                        font.pointSize: 16
                        font.bold: true
                        color: "#495057"
                    }
                }
            }

            // Registration Form
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: childrenRect.height + 40
                color: "white"
                radius: 8
                border.color: "#e9ecef"
                border.width: 1

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 20
                    spacing: 20

                    // First Name and Last Name row
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 15

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: "First Name"
                                font.pointSize: 12
                                font.bold: true
                                color: "#495057"
                            }

                            TextField {
                                id: firstNameField
                                Layout.fillWidth: true
                                placeholderText: "First Name"
                                font.pointSize: 12
                                height: 40
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: "Last Name"
                                font.pointSize: 12
                                font.bold: true
                                color: "#495057"
                            }

                            TextField {
                                id: lastNameField
                                Layout.fillWidth: true
                                placeholderText: "Last Name"
                                font.pointSize: 12
                                height: 40
                            }
                        }
                    }

                    // Email Address
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Email Address"
                            font.pointSize: 12
                            font.bold: true
                            color: "#495057"
                        }

                        TextField {
                            id: emailField
                            Layout.fillWidth: true
                            placeholderText: "Email Address"
                            font.pointSize: 12
                            height: 40
                        }
                    }

                    // Company (if applicable)
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Company (if applicable)"
                            font.pointSize: 12
                            font.bold: true
                            color: "#495057"
                        }

                        TextField {
                            id: companyField
                            Layout.fillWidth: true
                            placeholderText: "Company"
                            font.pointSize: 12
                            height: 40
                        }
                    }

                    // Physical Address
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Physical Address"
                            font.pointSize: 12
                            font.bold: true
                            color: "#495057"
                        }

                        TextField {
                            id: addressField
                            Layout.fillWidth: true
                            placeholderText: "Physical Address"
                            font.pointSize: 12
                            height: 40
                        }
                    }

                    // Date of Birth
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Date of Birth"
                            font.pointSize: 12
                            font.bold: true
                            color: "#495057"
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            ComboBox {
                                id: monthComboBox
                                Layout.preferredWidth: 120
                                height: 40
                                model: ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                                currentIndex: 0
                                font.pointSize: 12
                            }

                            ComboBox {
                                id: dayComboBox
                                Layout.preferredWidth: 80
                                height: 40
                                model: {
                                    var days = ["Day"];
                                    for (var i = 1; i <= 31; i++) {
                                        days.push(i.toString());
                                    }
                                    return days;
                                }
                                currentIndex: 0
                                font.pointSize: 12
                            }

                            ComboBox {
                                id: yearComboBox
                                Layout.preferredWidth: 100
                                height: 40
                                model: {
                                    var years = ["Year"];
                                    var currentYear = new Date().getFullYear();
                                    for (var i = currentYear; i >= currentYear - 100; i--) {
                                        years.push(i.toString());
                                    }
                                    return years;
                                }
                                currentIndex: 0
                                font.pointSize: 12
                            }

                            // Calendar icon
                            Rectangle {
                                width: 40
                                height: 40
                                color: "#f8f9fa"
                                border.color: "#ced4da"
                                border.width: 1
                                radius: 4

                                Text {
                                    anchors.centerIn: parent
                                    text: "📅"
                                    font.pointSize: 16
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        console.log("Calendar clicked");
                                    }
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // Register Button
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.topMargin: 20
                        height: 50
                        color: "#28a745"
                        radius: 5

                        Text {
                            anchors.centerIn: parent
                            text: "Register"
                            color: "white"
                            font.pointSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: registerUser()
                            onPressed: parent.color = "#218838"
                            onReleased: parent.color = "#28a745"
                        }
                    }

                    // Back to Login link
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 10
                        width: childrenRect.width
                        height: childrenRect.height
                        color: "transparent"

                        Text {
                            text: "Already have an account? Login"
                            font.pointSize: 12
                            color: "#007bff"
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: navigateToLogin()

                                onEntered: parent.color = "#0056b3"
                                onExited: parent.color = "#007bff"
                            }
                        }
                    }

                    // Error/Success message
                    Label {
                        id: messageLabel
                        text: ""
                        font.pointSize: 12
                        color: "#dc3545"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    // You can connect to your auth controller here
    Connections {
        target: authController // if you have one

        function onRegisterSuccessed(message) {
            messageLabel.text = "Registration successful!";
            messageLabel.color = "#28a745";
        }

        function onRegisterFailed(message) {
            messageLabel.text = message || "Registration failed!";
            messageLabel.color = "#dc3545";
        }
    }
}
