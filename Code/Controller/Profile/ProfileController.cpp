#include "ProfileController.hpp"
#include <QDate>

ProfileController::ProfileController(AuthService *authService, AppState *appState, UserModel *userModel, QObject *parent)
    : QObject(parent), authService(authService), appState(appState), userModel(userModel)
{
    // Handle Change Password
    connect(authService, &AuthService::changePasswordFinished, this, &ProfileController::onChangePasswordFinished);

    // Handle Change Name
    connect(authService, &AuthService::changeNameFinished, this, &ProfileController::onChangeNameFinished);

    // Handle Change Date of Birth
    connect(authService, &AuthService::changeDobFinished, this, &ProfileController::onChangeDobFinished);
}

void ProfileController::changePassword(const int &userId, const QString &oldPassword, const QString &newPassword)
{
    authService->changePassword(userId, oldPassword, newPassword);
}

void ProfileController::changeName(const int &userId, const QString &newName)
{
    authService->changeName(userId, newName);
}

void ProfileController::changeDob(const int &userId, const QString &newDob)
{
    authService->changeDob(userId, newDob);
}

void ProfileController::onChangePasswordFinished(bool success, const UserData &userData)
{
    if (success)
    {
        // Save to local
        appState->saveUserInfo(userData);

        // Save to UserModel
        QDate dateOfBirth = userData.dob.isEmpty() ? QDate() : QDate::fromString(userData.dob, Qt::ISODate);
        userModel->setEmail(userData.email);
        userModel->setName(userData.name);
        userModel->setDateOfBirth(dateOfBirth);

        emit changePasswordSuccess(userData.message);
    }
    else
    {
        emit changePasswordFailed(userData.message);
    }
}

void ProfileController::onChangeNameFinished(bool success, const UserData &userData)
{
    if (success)
    {
        // Save to local
        appState->saveUserInfo(userData);

        // Save to UserModel
        QDate dateOfBirth = userData.dob.isEmpty() ? QDate() : QDate::fromString(userData.dob, Qt::ISODate);
        userModel->setEmail(userData.email);
        userModel->setName(userData.name);
        userModel->setDateOfBirth(dateOfBirth);

        emit changeNameSuccess(userData.message);
    }
    else
    {
        emit changeNameFailed(userData.message);
    }
}

void ProfileController::onChangeDobFinished(bool success, const UserData &userData)
{
    if (success)
    {
        // Save to local
        appState->saveUserInfo(userData);

        // Save to UserModel
        QDate dateOfBirth = userData.dob.isEmpty() ? QDate() : QDate::fromString(userData.dob, Qt::ISODate);
        userModel->setEmail(userData.email);
        userModel->setName(userData.name);
        userModel->setDateOfBirth(dateOfBirth);

        emit changeDobSuccess(userData.message);
    }
    else
    {
        emit changeDobFailed(userData.message);
    }
}