#pragma once
#include "APIFactory.hpp"
#include "AppState.hpp"
#include "UserData.hpp"
#include <QObject>
#include <QJsonObject>

class AuthService : public QObject
{
    Q_OBJECT
public:
    explicit AuthService(APIFactory *apiFactory, QObject *parent = nullptr);
    void loginUser(const QString &email, const QString &password);
    void registerUser(const QString &email, const QString &password, const QString &name, const QString &dob);
    void changePassword(const int &userId, const QString &oldPassword, const QString &newPassword);
    void changeName(const int &userId, const QString &name);
    void changeDob(const int &userId, const QString &dob);

signals:
    void loginFinished(bool success, const UserData &userData);
    void registerFinished(bool success, const UserData &userData);
    void changePasswordFinished(bool success, const UserData &userData);
    void changeNameFinished(bool success, const UserData &userData);
    void changeDobFinished(bool success, const UserData &userData);

private slots:
    void onLoginReply();
    void onRegisterReply();
    void onChangePasswordReply();
    void onChangeNameReply();
    void onChangeDobReply();

private:
    RESTful *m_restful;
    AppState *m_appState;
};