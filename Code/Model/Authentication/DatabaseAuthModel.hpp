#pragma once
#include "IAuthModel.hpp"
#include "APIFactory.hpp"

class DatabaseAuthModel : public IAuthModel
{
    Q_OBJECT
public:
    explicit DatabaseAuthModel(APIFactory *apiFactory, QObject *parent = nullptr);
    void loginUser(const QString &username, const QString &password) override;
    void registerUser(const QString &username, const QString &password, const QString &name, const QString &dob) override;
    void changePassword(const int &userId, const QString &oldPassword, const QString &newPassword);

signals:
    void changePasswordResult(bool success, const QString &message);

private:
    RESTful *m_restful;

private:
    void handleNetworkReply(QNetworkReply *reply, bool isLogin, bool isChangePassword = false);
};