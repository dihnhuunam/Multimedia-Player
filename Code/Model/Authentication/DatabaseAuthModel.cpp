#include "DatabaseAuthModel.hpp"
#include <QDebug>

DatabaseAuthModel::DatabaseAuthModel(APIFactory *apiFactory, QObject *parent)
    : m_restful(apiFactory->createRESTful()), IAuthModel(parent)
{
    qDebug() << "----------";
    qDebug() << Q_FUNC_INFO;
}

void DatabaseAuthModel::loginUser(const QString &username, const QString &password)
{
    qDebug() << "----------";
    qDebug() << Q_FUNC_INFO;
    qDebug() << username << " " << password;
}

void DatabaseAuthModel::registerUser(const QString &username, const QString &password, const QString &name, const QString &dob)
{
    qDebug() << "----------";
    qDebug() << Q_FUNC_INFO;
}

void DatabaseAuthModel::changePassword(const int &userId, const QString &oldPassword, const QString &newPassword)
{
    qDebug() << "----------";
    qDebug() << Q_FUNC_INFO;
}
