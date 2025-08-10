#pragma once
#include "APIFactory.hpp"
#include <QObject>
#include <QJsonObject>

struct UserData
{
    QString message;
    QString token;
    QJsonObject user;
};

class AuthService : public QObject
{
    Q_OBJECT
public:
    explicit AuthService(APIFactory *apiFactory, QObject *parent = nullptr);
    Q_INVOKABLE void loginUser(const QString &email, const QString &password);
    Q_INVOKABLE void registerUser(const QString &email, const QString &password, const QString &name, const QString &dob);
    Q_INVOKABLE void changePassword(const int &userId, const QString &oldPassword, const QString &newPassword);

signals:
    void loginFinished(bool success, const UserData &userData);
    void registerFinished(bool success, const UserData &userData);
    void changePasswordFinished(bool success, const UserData &userData);

private slots:
    void onLoginReply();
    void onRegisterReply();
    void onChangePasswordReply();

private:
    RESTful *m_restful;
};