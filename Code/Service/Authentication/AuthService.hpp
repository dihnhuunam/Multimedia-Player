#pragma once
#include "APIFactory.hpp"
#include <QObject>

class AuthService : public QObject
{
    Q_OBJECT
public:
    explicit AuthService(APIFactory *apiFactory, QObject *parent = nullptr);
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
    void onLoginFinished();
    void onRegisterFinished();
    void onChangePasswordFinished();

private:
    RESTful *m_restful;
};