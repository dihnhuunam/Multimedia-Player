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
    Q_INVOKABLE UserModel *getUserModel();
signals:
    void loginSuccessed(const QString &message);
    void loginFailed(const QString &message);
    void registerSuccess(const QString &message);
    void registerFailed(const QString &message);
    void changePasswordSuccess(const QString &message);
    void changePasswordFailed(const QString &message);

private slots:
    void onLoginSuccessed(const QString &message);
    void onLoginFailed(const QString &message);
    void onRegisterSuccess(const QString &message);
    void onRegisterFailed(const QString &message);
    void onChangePasswordSuccess(const QString &message);
    void onChangePasswordFailed(const QString &message);

private:
    AuthService *authService;
    AppState *appState;
    UserModel *userModel;
};