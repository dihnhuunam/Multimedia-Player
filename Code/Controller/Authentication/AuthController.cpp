#include "AuthController.hpp"
#include "APIFactory.hpp"
#include <QJsonObject>
#include <QDate>

AuthController::AuthController(AuthService *authService, AppState *appState, UserModel *userModel, QObject *parent)
    : QObject(parent), authService(authService), appState(appState), userModel(userModel)
{
    // Handle Login
    connect(authService, &AuthService::loginFinished, this, &AuthController::onLoginFinished);

    // Handle Register
    connect(authService, &AuthService::registerFinished, this, &AuthController::onRegisterFinished);

    // Handle Change Password
    connect(authService, &AuthService::changePasswordFinished, this, &AuthController::onChangePasswordFinished);
}

void AuthController::loginUser(const QString &email, const QString &password)
{
    authService->loginUser(email, password);
}

void AuthController::registerUser(const QString &email, const QString &password, const QString &name, const QString &dob)
{
    authService->registerUser(email, password, name, dob);
}

void AuthController::changePassword(const int &userId, const QString &oldPassword, const QString &newPassword)
{
    authService->changePassword(userId, oldPassword, newPassword);
}

void AuthController::onLoginFinished(bool success, const UserData &userData)
{
    if (success)
    {
        // Save to local
        appState->saveToken(userData.token);
        appState->saveUserInfo(userData);

        // Save to UserModel
        QDate dateOfBirth = userData.dob.isEmpty() ? QDate() : QDate::fromString(userData.dob, Qt::ISODate);
        userModel->setEmail(userData.email);
        userModel->setName(userData.name);
        userModel->setDateOfBirth(dateOfBirth);

        emit loginSuccess(userData.message);
    }
    else
    {
        emit loginFailed(userData.message);
    }
}

void AuthController::onRegisterFinished(bool success, const UserData &userData)
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

        emit registerSuccess(userData.message);
    }
    else
    {
        emit registerFailed(userData.message);
    }
}

void AuthController::onChangePasswordFinished(bool success, const UserData &userData)
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