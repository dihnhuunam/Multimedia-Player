#pragma once
#include <QObject>
#include <QString>
#include "AuthService.hpp"
#include "AppState.hpp"
#include "UserModel.hpp"

class AuthController : public QObject
{
    Q_OBJECT
public:
    explicit AuthController(AuthService *authService, AppState *appState, UserModel *userModel, QObject *parent = nullptr);

    Q_INVOKABLE void loginUser(const QString &email, const QString &password);
    Q_INVOKABLE void registerUser(const QString &email, const QString &password, const QString &name, const QString &dob);
    Q_INVOKABLE void changePassword(const int &userId, const QString &oldPassword, const QString &newPassword);

signals:
    void loginSuccessed(const QString &message);
    void loginFailed(const QString &message);
    void registerSuccess(const QString &message);
    void registerFailed(const QString &message);
    void changePasswordSuccess(const QString &message);
    void changePasswordFailed(const QString &message);

private slots:
    void onLoginFinished(bool success, const UserData &userData);
    void onRegisterFinished(bool success, const UserData &userData);
    void onChangePasswordFinished(bool success, const UserData &userData);

private:
    AuthService *authService;
    AppState *appState;
    UserModel *userModel;
};
