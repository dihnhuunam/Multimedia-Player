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
    property bool isLoading: false
    
    // Add user ID property for easier access
    property int userId: userModel ? userModel.id || 0 : 0

    // Connect to ProfileController signals
    Component.onCompleted: {
        profileController.changeNameSuccess.connect(onChangeNameSuccess)
        profileController.changeNameFailed.connect(onChangeNameFailed)
        profileController.changeDobSuccess.connect(onChangeDobSuccess)
        profileController.changeDobFailed.connect(onChangeDobFailed)
        profileController.changePasswordSuccess.connect(onChangePasswordSuccess)
        profileController.changePasswordFailed.connect(onChangePasswordFailed)
        console.log(userId)
        console.log(userModel.id)
    }

    // Signal handlers
    function onChangeNameSuccess(message) {
        root.isLoading = false
        showMessage(message, true)
        editPopup.close()
    }

    function onChangeNameFailed(message) {
        root.isLoading = false
        showMessage(message, false)
    }

    function onChangeDobSuccess(message) {
        root.isLoading = false
        showMessage(message, true)
    }

    function onChangeDobFailed(message) {
        root.isLoading = false
        showMessage(message, false)
    }

    function onChangePasswordSuccess(message) {
        root.isLoading = false
        showMessage(message, true)
        passwordPopup.close()
    }

    function onChangePasswordFailed(message) {
        root.isLoading = false
        showMessage(message, false)
    }

    function showMessage(message, isSuccess) {
        messageText.text = message
        messageText.color = isSuccess ? ProfileStyles.successColor : ProfileStyles.errorColor
        messageTimer.start()
    }

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

            // Message display
            Text {
                id: messageText
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                font.pointSize: ProfileStyles.fieldFontSize
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                visible: text.length > 0
                wrapMode: Text.Wrap
            }

            Timer {
                id: messageTimer
                interval: 3000
                onTriggered: messageText.text = ""
            }

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

                    // Email Address (Read-only display)
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
                            color: ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            border.color: ProfileStyles.borderColor
                            border.width: 1

                            Text {
                                anchors.fill: parent
                                anchors.margins: ProfileStyles.margins
                                text: userModel.email
                                font.pointSize: ProfileStyles.fieldFontSize
                                color: ProfileStyles.textColor
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
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

                    // Change Password Button
                    Button {
                        id: changePasswordButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Change Password"
                        enabled: !isLoading
                        
                        contentItem: Text {
                            text: changePasswordButton.text
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.whiteColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        background: Rectangle {
                            color: changePasswordButton.down ? ProfileStyles.primaryPressedColor :
                                   changePasswordButton.hovered ? ProfileStyles.primaryHoverColor :
                                   ProfileStyles.primaryColor
                            radius: ProfileStyles.borderRadius
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        
                        onClicked: passwordPopup.open()
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
            
            // Format date as ISO string (YYYY-MM-DD)
            var formattedDate = selectedYear + "-" + 
                               (selectedMonth < 10 ? "0" : "") + selectedMonth + "-" +
                               (selectedDay < 10 ? "0" : "") + selectedDay;
            
            console.log("Updating date:", formattedDate);
            root.isLoading = true;
            
            // Call ProfileController to update DOB on server
            profileController.changeDob(root.userId, formattedDate);
        }
    }

    // Popup for editing Name
    Popup {
        id: editPopup
        anchors.centerIn: parent
        width: ProfileStyles.editPopUpFormWidth
        height: ProfileStyles.editPopUpFormHeight
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        visible: root.currentField === "name"

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
                    text: "Edit " + ProfileStyles.profileNameLabel
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
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: ProfileStyles.spacing

                    Button {
                        id: saveButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Save Changes"
                        enabled: !root.isLoading && editTextField.text.trim().length > 0
                        
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
                            opacity: saveButton.enabled ? 1.0 : 0.5
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        onClicked: {
                            if (editTextField.text.trim().length > 0) {
                                root.isLoading = true;
                                profileController.changeName(root.userId, editTextField.text.trim());
                            }
                        }
                    }

                    Button {
                        id: cancelButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Cancel"
                        enabled: !root.isLoading
                        
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
                            opacity: cancelButton.enabled ? 1.0 : 0.5
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

    // Password Change Popup
    Popup {
        id: passwordPopup
        anchors.centerIn: parent
        width: ProfileStyles.editPopUpFormWidth
        height: ProfileStyles.editPopUpFormHeight + 230
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

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
                    text: "Change Password"
                    font.pointSize: ProfileStyles.fieldFontSize
                    font.bold: true
                    color: ProfileStyles.textColor
                    Layout.alignment: Qt.AlignHCenter
                }

                // Current Password
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: ProfileStyles.spacing / 2

                    Text {
                        text: "Current Password"
                        font.pointSize: ProfileStyles.fieldFontSize - 1
                        color: ProfileStyles.textColor
                    }

                    TextField {
                        id: currentPasswordField
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        echoMode: TextInput.Password
                        font.pointSize: ProfileStyles.fieldFontSize
                        color: ProfileStyles.textColor
                        background: Rectangle {
                            color: currentPasswordField.activeFocus ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            border.color: ProfileStyles.borderColor
                            border.width: 1
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        leftPadding: ProfileStyles.margins
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // New Password
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: ProfileStyles.spacing / 2

                    Text {
                        text: "New Password"
                        font.pointSize: ProfileStyles.fieldFontSize - 1
                        color: ProfileStyles.textColor
                    }

                    TextField {
                        id: newPasswordField
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        echoMode: TextInput.Password
                        font.pointSize: ProfileStyles.fieldFontSize
                        color: ProfileStyles.textColor
                        background: Rectangle {
                            color: newPasswordField.activeFocus ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            border.color: ProfileStyles.borderColor
                            border.width: 1
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        leftPadding: ProfileStyles.margins
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // Confirm Password
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: ProfileStyles.spacing / 2

                    Text {
                        text: "Confirm New Password"
                        font.pointSize: ProfileStyles.fieldFontSize - 1
                        color: ProfileStyles.textColor
                    }

                    TextField {
                        id: confirmPasswordField
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        echoMode: TextInput.Password
                        font.pointSize: ProfileStyles.fieldFontSize
                        color: ProfileStyles.textColor
                        background: Rectangle {
                            color: confirmPasswordField.activeFocus ? ProfileStyles.focusColor : ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            border.color: ProfileStyles.borderColor
                            border.width: 1
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        leftPadding: ProfileStyles.margins
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: ProfileStyles.spacing

                    Button {
                        id: savePasswordButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Change Password"
                        enabled: !root.isLoading && 
                                currentPasswordField.text.length > 0 && 
                                newPasswordField.text.length > 0 && 
                                confirmPasswordField.text.length > 0 &&
                                newPasswordField.text === confirmPasswordField.text
                        
                        contentItem: Text {
                            text: savePasswordButton.text
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.whiteColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: savePasswordButton.down ? ProfileStyles.primaryPressedColor :
                                   savePasswordButton.hovered ? ProfileStyles.primaryHoverColor :
                                   ProfileStyles.primaryColor
                            radius: ProfileStyles.borderRadius
                            opacity: savePasswordButton.enabled ? 1.0 : 0.5
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        onClicked: {
                            if (newPasswordField.text === confirmPasswordField.text) {
                                root.isLoading = true;
                                profileController.changePassword(root.userId, currentPasswordField.text, newPasswordField.text);
                            } else {
                                showMessage("Passwords do not match", false);
                            }
                        }
                    }

                    Button {
                        id: cancelPasswordButton
                        Layout.fillWidth: true
                        Layout.preferredHeight: ProfileStyles.fieldHeight
                        text: "Cancel"
                        enabled: !root.isLoading
                        
                        contentItem: Text {
                            text: cancelPasswordButton.text
                            font.pointSize: ProfileStyles.fieldFontSize
                            font.bold: true
                            color: ProfileStyles.textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: cancelPasswordButton.down ? ProfileStyles.lightGrayColor :
                                   cancelPasswordButton.hovered ? ProfileStyles.focusColor :
                                   ProfileStyles.lightGrayColor
                            radius: ProfileStyles.borderRadius
                            opacity: cancelPasswordButton.enabled ? 1.0 : 0.5
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                        onClicked: {
                            currentPasswordField.text = "";
                            newPasswordField.text = "";
                            confirmPasswordField.text = "";
                            passwordPopup.close();
                        }
                    }
                }
            }
        }
    }

    // Loading overlay
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        visible: root.isLoading

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.3
        }

        Rectangle {
            anchors.centerIn: parent
            width: 200
            height: 100
            color: ProfileStyles.whiteColor
            radius: ProfileStyles.borderRadius
            border.color: ProfileStyles.borderColor
            border.width: 1

            ColumnLayout {
                anchors.centerIn: parent
                spacing: ProfileStyles.spacing

                BusyIndicator {
                    Layout.alignment: Qt.AlignHCenter
                    running: root.isLoading
                }

                Text {
                    text: "Updating..."
                    font.pointSize: ProfileStyles.fieldFontSize
                    color: ProfileStyles.textColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}