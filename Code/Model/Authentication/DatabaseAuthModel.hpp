#pragma once
#include "APIFactory.hpp"
#include <QObject>

class DatabaseAuthModel : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseAuthModel(APIFactory *apiFactory, QObject *parent = nullptr);
    Q_INVOKABLE void loginUser(const QString &email, const QString &password);
    Q_INVOKABLE void registerUser(const QString &email, const QString &password, const QString &name, const QString &dob);
    Q_INVOKABLE void changePassword(const int &userId, const QString &oldPassword, const QString &newPassword);

signals:
    void loginResult(bool success, const QString &message);
    void registerResult(bool success, const QString &message);
    void changePasswordResult(bool success, const QString &message);

private slots:
    void onLoginFinished();
    void onRegisterFinished();
    void onChangePasswordFinished();

private:
    RESTful *m_restful;
};