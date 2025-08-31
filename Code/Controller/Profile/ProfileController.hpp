#pragma once
#include <QObject>
#include <QString>
#include "AuthService.hpp"
#include "AppState.hpp"
#include "UserModel.hpp"

class ProfileController : public QObject
{
    Q_OBJECT
public:
    explicit ProfileController(AuthService *authService, AppState *appState, UserModel *userModel, QObject *parent = nullptr);

    Q_INVOKABLE void changePassword(const int &userId, const QString &oldPassword, const QString &newPassword);
    Q_INVOKABLE void changeName(const int &userId, const QString &newName);
    Q_INVOKABLE void changeDob(const int &userId, const QString &newDob);

signals:
    void changePasswordSuccess(const QString &message);
    void changePasswordFailed(const QString &message);
    void changeNameSuccess(const QString &message);
    void changeNameFailed(const QString &message);
    void changeDobSuccess(const QString &message);
    void changeDobFailed(const QString &message);

private slots:
    void onChangePasswordFinished(bool success, const UserData &userData);
    void onChangeNameFinished(bool success, const UserData &userData);
    void onChangeDobFinished(bool success, const UserData &userData);

private:
    AuthService *authService;
    AppState *appState;
    UserModel *userModel;
};