import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "./ProfileStyles.js" as ProfileStyles
import "../Helpers"

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

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: ProfileStyles.fieldHeight
                            color: mouseArea.containsMouse ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            border.color: ProfileStyles.borderColor
                            border.width: 1

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            Text {
                                anchors.fill: parent
                                anchors.margins: ProfileStyles.margins
                                text: userModel.email
                                font.pointSize: ProfileStyles.fieldFontSize
                                color: ProfileStyles.textColor
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.currentField = "email";
                                    root.currentValue = userModel.email;
                                    editPopup.open();
                                }
                            }
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

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: ProfileStyles.fieldHeight
                            color: nameMouseArea.containsMouse ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            border.color: ProfileStyles.borderColor
                            border.width: 1

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            Text {
                                anchors.fill: parent
                                anchors.margins: ProfileStyles.margins
                                text: userModel.name
                                font.pointSize: ProfileStyles.fieldFontSize
                                color: ProfileStyles.textColor
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }

                            MouseArea {
                                id: nameMouseArea
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

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: ProfileStyles.spacing / 2

                            // Month ComboBox
                            ComboBox {
                                id: monthComboBox
                                Layout.preferredWidth: 140
                                Layout.preferredHeight: ProfileStyles.fieldHeight
                                
                                property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                                
                                model: monthNames
                                currentIndex: {
                                    var date = userModel.dateOfBirth
                                    return date ? date.getMonth() : 0
                                }
                                
                                delegate: ItemDelegate {
                                    width: monthComboBox.width
                                    height: 30
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        color: parent.hovered ? ProfileStyles.primaryColor : "transparent"
                                        radius: ProfileStyles.borderRadius
                                    }
                                    
                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.pointSize: ProfileStyles.fieldFontSize - 1
                                        color: parent.hovered ? ProfileStyles.whiteColor : ProfileStyles.textColor
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            monthComboBox.currentIndex = index
                                            monthComboBox.popup.close()
                                            updateDateOfBirth()
                                        }
                                    }
                                }
                                
                                popup: Popup {
                                    y: monthComboBox.height
                                    width: monthComboBox.width
                                    height: Math.min(monthComboBox.count * 30, 180)
                                    padding: 2
                                    
                                    background: Rectangle {
                                        color: ProfileStyles.whiteColor
                                        border.color: ProfileStyles.borderColor
                                        border.width: 1
                                        radius: ProfileStyles.borderRadius
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
                                    color: monthComboBox.activeFocus ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                                    radius: ProfileStyles.borderRadius
                                    border.color: ProfileStyles.borderColor
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: monthComboBox.currentText
                                    font.pointSize: ProfileStyles.fieldFontSize
                                    color: ProfileStyles.textColor
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }

                            // Day ComboBox
                            ComboBox {
                                id: dayComboBox
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: ProfileStyles.fieldHeight
                                
                                property var dayNumbers: {
                                    var days = [];
                                    for (var i = 1; i <= 31; i++) {
                                        days.push(i.toString());
                                    }
                                    return days;
                                }
                                
                                model: dayNumbers
                                currentIndex: {
                                    var date = userModel.dateOfBirth
                                    return date ? date.getDate() - 1 : 0
                                }
                                
                                delegate: ItemDelegate {
                                    width: dayComboBox.width
                                    height: 30
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        color: parent.hovered ? ProfileStyles.primaryColor : "transparent"
                                        radius: ProfileStyles.borderRadius
                                    }
                                    
                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.pointSize: ProfileStyles.fieldFontSize - 1
                                        color: parent.hovered ? ProfileStyles.whiteColor : ProfileStyles.textColor
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            dayComboBox.currentIndex = index
                                            dayComboBox.popup.close()
                                            updateDateOfBirth()
                                        }
                                    }
                                }
                                
                                popup: Popup {
                                    y: dayComboBox.height
                                    width: dayComboBox.width
                                    height: Math.min(dayComboBox.count * 30, 180)
                                    padding: 2
                                    
                                    background: Rectangle {
                                        color: ProfileStyles.whiteColor
                                        border.color: ProfileStyles.borderColor
                                        border.width: 1
                                        radius: ProfileStyles.borderRadius
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
                                    color: dayComboBox.activeFocus ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                                    radius: ProfileStyles.borderRadius
                                    border.color: ProfileStyles.borderColor
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: dayComboBox.currentText
                                    font.pointSize: ProfileStyles.fieldFontSize
                                    color: ProfileStyles.textColor
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }

                            // Year ComboBox
                            ComboBox {
                                id: yearComboBox
                                Layout.preferredWidth: 120
                                Layout.preferredHeight: ProfileStyles.fieldHeight
                                
                                property var yearNumbers: {
                                    var years = [];
                                    var currentYear = new Date().getFullYear();
                                    for (var i = currentYear; i >= currentYear - 100; i--) {
                                        years.push(i.toString());
                                    }
                                    return years;
                                }
                                
                                model: yearNumbers
                                currentIndex: {
                                    var date = userModel.dateOfBirth
                                    if (date) {
                                        var year = date.getFullYear()
                                        var currentYear = new Date().getFullYear()
                                        return currentYear - year
                                    }
                                    return 0
                                }
                                
                                delegate: ItemDelegate {
                                    width: yearComboBox.width
                                    height: 30
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        color: parent.hovered ? ProfileStyles.primaryColor : "transparent"
                                        radius: ProfileStyles.borderRadius
                                    }
                                    
                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        font.pointSize: ProfileStyles.fieldFontSize - 1
                                        color: parent.hovered ? ProfileStyles.whiteColor : ProfileStyles.textColor
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            yearComboBox.currentIndex = index
                                            yearComboBox.popup.close()
                                            updateDateOfBirth()
                                        }
                                    }
                                }
                                
                                popup: Popup {
                                    y: yearComboBox.height
                                    width: yearComboBox.width
                                    height: Math.min(yearComboBox.count * 30, 180)
                                    padding: 2
                                    
                                    background: Rectangle {
                                        color: ProfileStyles.whiteColor
                                        border.color: ProfileStyles.borderColor
                                        border.width: 1
                                        radius: ProfileStyles.borderRadius
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
                                    color: yearComboBox.activeFocus ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                                    radius: ProfileStyles.borderRadius
                                    border.color: ProfileStyles.borderColor
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: yearComboBox.currentText
                                    font.pointSize: ProfileStyles.fieldFontSize
                                    color: ProfileStyles.textColor
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                }
                            }

                            // Calendar icon
                            Rectangle {
                                Layout.preferredWidth: ProfileStyles.fieldHeight
                                Layout.preferredHeight: ProfileStyles.fieldHeight
                                color: ProfileStyles.lightBackgroundColor
                                border.color: ProfileStyles.borderColor
                                border.width: 1
                                radius: ProfileStyles.borderRadius

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
                                onClicked: NavigationManager.navigateTo("qrc:/View/Authentication/LoginView.qml")
                                onEntered: parent.color = ProfileStyles.primaryHoverColor
                                onExited: parent.color = ProfileStyles.primaryColor
                            }
                        }
                    }
                }
            }
        }
    }

    // Function to update date of birth
    function updateDateOfBirth() {
        if (monthComboBox.currentIndex >= 0 && 
            dayComboBox.currentIndex >= 0 && 
            yearComboBox.currentIndex >= 0) {
            
            var selectedMonth = monthComboBox.currentIndex + 1; // Month is 0-based in JS
            var selectedDay = parseInt(dayComboBox.currentText);
            var selectedYear = parseInt(yearComboBox.currentText);
            
            var newDate = new Date(selectedYear, selectedMonth - 1, selectedDay);
            console.log("Updating date:", newDate);
            
            userModel.dateOfBirth = newDate;
        }
    }

    // Popup for editing Name and Email
    Popup {
        id: editPopup
        anchors.centerIn: parent
        width: ProfileStyles.editPopUpFormWidth
        height: ProfileStyles.editPopUpFormHeight
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        visible: root.currentField === "name" || root.currentField === "email"

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
                    text: "Edit " + (root.currentField === "name" ? ProfileStyles.profileNameLabel : ProfileStyles.profileEmailLabel)
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
                        color: editTextField.activeFocus ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                        radius: ProfileStyles.borderRadius
                        border.color: ProfileStyles.borderColor
                        border.width: 1
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                    leftPadding: ProfileStyles.margins
                    verticalAlignment: Text.AlignVCenter
                    validator: RegularExpressionValidator {
                        regularExpression: root.currentField === "email" ? /^[^\s@]+@[^\s@]+\.[^\s@]+$/ : /.*/
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: ProfileStyles.spacing

                    Button {
                        id: saveButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Save Changes"
                        contentItem: Text {
                            text: saveButton.text
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.whiteColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: saveButton.down ? ProfileStyles.primaryPressedColor :
                                   saveButton.hovered ? ProfileStyles.primaryHoverColor :
                                   ProfileStyles.primaryColor
                            radius: ProfileStyles.borderRadius
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        onClicked: {
                            if (root.currentField === "name") {
                                userModel.name = editTextField.text;
                            } else if (root.currentField === "email") {
                                userModel.email = editTextField.text;
                            }
                            editPopup.close();
                        }
                    }

                    Button {
                        id: cancelButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Cancel"
                        contentItem: Text {
                            text: cancelButton.text
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: cancelButton.down ? ProfileStyles.lightGrayColor :
                                   cancelButton.hovered ? ProfileStyles.focusColor :
                                   ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        onClicked: {
                            editPopup.close();
                        }
                    }
                }
            }
        }
    }
}