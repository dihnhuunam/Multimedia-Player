#include "DatabaseAuthModel.hpp"
#include "AppState.hpp"
#include <QDebug>
#include <QJsonObject>
#include <QNetworkReply>
#include <QDateTime>

DatabaseAuthModel::DatabaseAuthModel(APIFactory *apiFactory, QObject *parent)
    : m_restful(apiFactory->createRESTful()), QObject(parent)
{
}

void DatabaseAuthModel::loginUser(const QString &email, const QString &password)
{
    // Handle invalid input
    if (email.isEmpty() && password.isEmpty())
    {
        emit loginResult(false, "email or password are requiered");
        return;
    }

    // Handle valid input
    QJsonObject json;
    json["email"] = email;
    json["password"] = password;

    // Handle login reply
    QNetworkReply *reply = m_restful->post("login", json);
    if (!reply)
    {
        emit loginResult(false, "Invalid endpoint for login");
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &DatabaseAuthModel::onLoginFinished);
}

void DatabaseAuthModel::registerUser(const QString &email, const QString &password, const QString &name, const QString &dob)
{
    // Handle invalid input
    if (email.isEmpty() || password.isEmpty() || name.isEmpty() || dob.isEmpty())
    {
        emit registerResult(false, "Email, password, name, and date of birth are required");
        return;
    }

    // Handle valid input
    QJsonObject json;
    json["email"] = email;
    json["password"] = password;
    json["name"] = name;
    QString formattedDob = dob;
    if (!formattedDob.isEmpty())
    {
        QDateTime date = QDateTime::fromString(dob, "yyyy-MM-dd");
        if (!date.isValid())
        {
            date = QDateTime::fromString(dob, Qt::ISODate);
        }
        if (date.isValid())
        {
            formattedDob = date.toUTC().toString(Qt::ISODate);
        }
        else
        {
            emit registerResult(false, "Invalid dateOfBirth format");
            return;
        }
    }
    json["dateOfBirth"] = formattedDob;

    // Handle register reply
    QNetworkReply *reply = m_restful->post("register", json);
    if (!reply)
    {
        emit registerResult(false, "Invalid endpoint for register");
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &DatabaseAuthModel::onRegisterFinished);
}

void DatabaseAuthModel::changePassword(const int &userId, const QString &oldPassword, const QString &newPassword)
{
    // Handle invalid input
    if (userId <= 0)
    {
        emit changePasswordResult(false, "Invalid User ID");
        return;
    }

    if (oldPassword.isEmpty() || newPassword.isEmpty())
    {
        emit changePasswordResult(false, "Both current and new password are required");
        return;
    }

    // Handle valid input
    QString endpoint = QString("update").arg(userId);
    QJsonObject json;
    json["password"] = newPassword;

    // Handle reply reply
    QNetworkReply *reply = m_restful->put(endpoint, json, AppState::instance()->getToken());
    if (!reply)
    {
        emit changePasswordResult(false, "Invalid endpoint for update");
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &DatabaseAuthModel::onChangePasswordFinished);
}

void DatabaseAuthModel::onLoginFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
    {
        emit loginResult(false, "Invalid reply object");
        return;
    }

    bool success = false;
    QString message;

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            message = obj["message"].toString();
            success = !message.contains("error", Qt::CaseInsensitive);

            if (success)
            {
                if (obj.contains("token") && obj.contains("user"))
                {
                    QString token = obj["token"].toString();
                    QJsonObject user = obj["user"].toObject();
                    AppState::instance()->saveToken(token);
                    AppState::instance()->saveUserInfo(user);
                }
                else
                {
                    success = false;
                    message = "Invalid login response from server";
                }
            }
        }
        else
        {
            success = false;
            message = "Invalid response from server";
        }
    }
    else
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            message = obj["message"].toString();
            if (message.isEmpty())
            {
                message = reply->errorString();
            }
        }
        else
        {
            message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (message.isEmpty())
                message = "Bad request: Invalid input data";
            break;
        case 401:
            if (message.isEmpty())
                message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (message.isEmpty())
                message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (message.isEmpty())
                message = "Resource not found";
            break;
        case 409:
            if (message.isEmpty())
                message = "Conflict: Resource already exists";
            break;
        case 500:
            if (message.isEmpty())
                message = "Internal server error";
            break;
        default:
            if (message.isEmpty())
                message = "Unknown error occurred";
            break;
        }
    }

    emit loginResult(success, message);
    reply->deleteLater();
}

void DatabaseAuthModel::onRegisterFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
    {
        emit registerResult(false, "Invalid reply object");
        return;
    }

    bool success = false;
    QString message;

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            message = obj["message"].toString();
            success = !message.contains("error", Qt::CaseInsensitive);
        }
        else
        {
            success = false;
            message = "Invalid response from server";
        }
    }
    else
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            message = obj["message"].toString();
            if (message.isEmpty())
            {
                message = reply->errorString();
            }
        }
        else
        {
            message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (message.isEmpty())
                message = "Bad request: Invalid input data";
            break;
        case 401:
            if (message.isEmpty())
                message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (message.isEmpty())
                message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (message.isEmpty())
                message = "Resource not found";
            break;
        case 409:
            if (message.isEmpty())
                message = "Conflict: Resource already exists";
            break;
        case 500:
            if (message.isEmpty())
                message = "Internal server error";
            break;
        default:
            if (message.isEmpty())
                message = "Unknown error occurred";
            break;
        }
    }

    emit registerResult(success, message);
    reply->deleteLater();
}

void DatabaseAuthModel::onChangePasswordFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
    {
        emit changePasswordResult(false, "Invalid reply object");
        return;
    }

    bool success = false;
    QString message;

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            message = obj["message"].toString();
            success = !message.contains("error", Qt::CaseInsensitive);

            if (success && obj.contains("user"))
            {
                QJsonObject user = obj["user"].toObject();
                AppState::instance()->saveUserInfo(user);
            }
        }
        else
        {
            success = false;
            message = "Invalid response from server";
        }
    }
    else
    {
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            message = obj["message"].toString();
            if (message.isEmpty())
            {
                message = reply->errorString();
            }
        }
        else
        {
            message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (message.isEmpty())
                message = "Bad request: Invalid input data";
            break;
        case 401:
            if (message.isEmpty())
                message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (message.isEmpty())
                message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (message.isEmpty())
                message = "Resource not found";
            break;
        case 409:
            if (message.isEmpty())
                message = "Conflict: Resource already exists";
            break;
        case 500:
            if (message.isEmpty())
                message = "Internal server error";
            break;
        default:
            if (message.isEmpty())
                message = "Unknown error occurred";
            break;
        }
    }

    emit changePasswordResult(success, message);
    reply->deleteLater();
}
