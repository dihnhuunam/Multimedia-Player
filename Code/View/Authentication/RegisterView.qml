import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Helpers"
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

                            TextField {
                                id: firstNameField
                                Layout.fillWidth: true
                                placeholderText: AuthStyles.registerFirstNameLabel
                                Layout.preferredHeight: AuthStyles.fieldHeight
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
                                verticalAlignment: Text.AlignVCenter
                                onActiveFocusChanged: {
                                    background.color = activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                                }
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

                            TextField {
                                id: lastNameField
                                Layout.fillWidth: true
                                placeholderText: AuthStyles.registerLastNameLabel
                                Layout.preferredHeight: AuthStyles.fieldHeight
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
                                verticalAlignment: Text.AlignVCenter
                                onActiveFocusChanged: {
                                    background.color = activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                                }
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

                        TextField {
                            id: emailField
                            Layout.fillWidth: true
                            placeholderText: AuthStyles.registerEmailLabel
                            Layout.preferredHeight: AuthStyles.fieldHeight
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
                            verticalAlignment: Text.AlignVCenter
                            onActiveFocusChanged: {
                                background.color = activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                            }
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

                        TextField {
                            id: passwordField
                            Layout.fillWidth: true
                            placeholderText: AuthStyles.registerPasswordPlaceholder
                            Layout.preferredHeight: AuthStyles.fieldHeight
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
                            verticalAlignment: Text.AlignVCenter
                            onActiveFocusChanged: {
                                background.color = activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                            }
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

                            // Month ComboBox
                            ComboBox {
                                id: monthComboBox
                                Layout.preferredWidth: 140
                                Layout.preferredHeight: AuthStyles.fieldHeight
                                
                                property var monthNames: ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                                
                                model: monthNames
                                currentIndex: 0
                                
                                delegate: ItemDelegate {
                                    width: monthComboBox.width
                                    height: 30
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        color: parent.hovered ? AuthStyles.primaryColor : "transparent"
                                        radius: AuthStyles.borderRadius
                                    }
                                    
                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.pointSize: AuthStyles.fieldFontSize - 1
                                        color: parent.hovered ? AuthStyles.whiteColor : AuthStyles.textColor
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            monthComboBox.currentIndex = index
                                            monthComboBox.popup.close()
                                        }
                                    }
                                }
                                
                                popup: Popup {
                                    y: monthComboBox.height
                                    width: monthComboBox.width
                                    height: Math.min(monthComboBox.count * 30, 180)
                                    padding: 2
                                    
                                    background: Rectangle {
                                        color: AuthStyles.whiteColor
                                        border.color: AuthStyles.borderColor
                                        border.width: 1
                                        radius: AuthStyles.borderRadius
                                    }
                                    
                                    contentItem: ListView {
                                        anchors.fill: parent
                                        model: monthComboBox.model
                                        delegate: monthComboBox.delegate
                                        currentIndex: monthComboBox.currentIndex
                                        clip: true
                                        ScrollBar.vertical: ScrollBar {
                                            active: true
                                            policy: ScrollBar.AsNeeded
                                        }
                                    }
                                }
                                
                                background: Rectangle {
                                    color: monthComboBox.activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                                    radius: AuthStyles.borderRadius
                                    border.color: AuthStyles.borderColor
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: monthComboBox.currentText
                                    font.pointSize: AuthStyles.fieldFontSize
                                    color: AuthStyles.textColor
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }

                            // Day ComboBox
                            ComboBox {
                                id: dayComboBox
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: AuthStyles.fieldHeight
                                
                                property var dayNumbers: {
                                    var days = ["Day"];
                                    for (var i = 1; i <= 31; i++) {
                                        days.push(i.toString());
                                    }
                                    return days;
                                }
                                
                                model: dayNumbers
                                currentIndex: 0
                                
                                delegate: ItemDelegate {
                                    width: dayComboBox.width
                                    height: 30
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        color: parent.hovered ? AuthStyles.primaryColor : "transparent"
                                        radius: AuthStyles.borderRadius
                                    }
                                    
                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.pointSize: AuthStyles.fieldFontSize - 1
                                        color: parent.hovered ? AuthStyles.whiteColor : AuthStyles.textColor
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            dayComboBox.currentIndex = index
                                            dayComboBox.popup.close()
                                        }
                                    }
                                }
                                
                                popup: Popup {
                                    y: dayComboBox.height
                                    width: dayComboBox.width
                                    height: Math.min(dayComboBox.count * 30, 180)
                                    padding: 2
                                    
                                    background: Rectangle {
                                        color: AuthStyles.whiteColor
                                        border.color: AuthStyles.borderColor
                                        border.width: 1
                                        radius: AuthStyles.borderRadius
                                    }
                                    
                                    contentItem: ListView {
                                        anchors.fill: parent
                                        model: dayComboBox.model
                                        delegate: dayComboBox.delegate
                                        currentIndex: dayComboBox.currentIndex
                                        clip: true
                                        ScrollBar.vertical: ScrollBar {
                                            active: true
                                            policy: ScrollBar.AsNeeded
                                        }
                                    }
                                }
                                
                                background: Rectangle {
                                    color: dayComboBox.activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                                    radius: AuthStyles.borderRadius
                                    border.color: AuthStyles.borderColor
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: dayComboBox.currentText
                                    font.pointSize: AuthStyles.fieldFontSize
                                    color: AuthStyles.textColor
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }

                            // Year ComboBox
                            ComboBox {
                                id: yearComboBox
                                Layout.preferredWidth: 120
                                Layout.preferredHeight: AuthStyles.fieldHeight
                                
                                property var yearNumbers: {
                                    var years = ["Year"];
                                    var currentYear = new Date().getFullYear();
                                    for (var i = currentYear; i >= currentYear - 100; i--) {
                                        years.push(i.toString());
                                    }
                                    return years;
                                }
                                
                                model: yearNumbers
                                currentIndex: 0
                                
                                delegate: ItemDelegate {
                                    width: yearComboBox.width
                                    height: 30
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        color: parent.hovered ? AuthStyles.primaryColor : "transparent"
                                        radius: AuthStyles.borderRadius
                                    }
                                    
                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.pointSize: AuthStyles.fieldFontSize - 1
                                        color: parent.hovered ? AuthStyles.whiteColor : AuthStyles.textColor
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            yearComboBox.currentIndex = index
                                            yearComboBox.popup.close()
                                        }
                                    }
                                }
                                
                                popup: Popup {
                                    y: yearComboBox.height
                                    width: yearComboBox.width
                                    height: Math.min(yearComboBox.count * 30, 180)
                                    padding: 2
                                    
                                    background: Rectangle {
                                        color: AuthStyles.whiteColor
                                        border.color: AuthStyles.borderColor
                                        border.width: 1
                                        radius: AuthStyles.borderRadius
                                    }
                                    
                                    contentItem: ListView {
                                        anchors.fill: parent
                                        model: yearComboBox.model
                                        delegate: yearComboBox.delegate
                                        currentIndex: yearComboBox.currentIndex
                                        clip: true
                                        ScrollBar.vertical: ScrollBar {
                                            active: true
                                            policy: ScrollBar.AsNeeded
                                        }
                                    }
                                }
                                
                                background: Rectangle {
                                    color: yearComboBox.activeFocus ? AuthStyles.focusColor : AuthStyles.lightGrayColor
                                    radius: AuthStyles.borderRadius
                                    border.color: AuthStyles.borderColor
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: yearComboBox.currentText
                                    font.pointSize: AuthStyles.fieldFontSize
                                    color: AuthStyles.textColor
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
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
                        }
                    }

                    // Register Button
                    Button {
                        id: registerButton
                        Layout.fillWidth: true
                        Layout.topMargin: AuthStyles.registerSpacing
                        text: AuthStyles.registerButtonText
                        contentItem: Text {
                            text: registerButton.text
                            font.pointSize: AuthStyles.buttonFontSize
                            font.bold: true
                            color: AuthStyles.whiteColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: registerButton.down ? AuthStyles.primaryPressedColor :
                                   registerButton.hovered ? AuthStyles.primaryHoverColor :
                                   AuthStyles.primaryColor
                            radius: AuthStyles.borderRadius
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        height: AuthStyles.fieldHeight
                        enabled: true
                        onClicked: {
                            // Debug output
                            console.log("Month index:", monthComboBox.currentIndex, "Text:", monthComboBox.currentText)
                            console.log("Day index:", dayComboBox.currentIndex, "Text:", dayComboBox.currentText)
                            console.log("Year index:", yearComboBox.currentIndex, "Text:", yearComboBox.currentText)
                            
                            // Validation
                            if (monthComboBox.currentIndex === 0 || dayComboBox.currentIndex === 0 || yearComboBox.currentIndex === 0) {
                                messageLabel.text = "Please select a valid date of birth";
                                messageLabel.color = AuthStyles.errorColor;
                                return;
                            }
                            if (firstNameField.text === "" || lastNameField.text === "" || emailField.text === "" || passwordField.text === "") {
                                messageLabel.text = "Please fill in all fields";
                                messageLabel.color = AuthStyles.errorColor;
                                return;
                            }
                            
                            // Get selected values
                            var selectedMonth = monthComboBox.currentIndex;
                            var selectedDay = parseInt(dayComboBox.currentText);
                            var selectedYear = parseInt(yearComboBox.currentText);
                            
                            // Create date string
                            var dateString = selectedYear + "-" + String(selectedMonth).padStart(2, '0') + "-" + String(selectedDay).padStart(2, '0');
                            console.log("Final date:", dateString)
                            
                            var name = firstNameField.text + " " + lastNameField.text;
                            authController.registerUser(emailField.text, passwordField.text, name, dateString);
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