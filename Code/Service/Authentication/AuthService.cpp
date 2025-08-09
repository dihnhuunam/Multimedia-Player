#include "AuthService.hpp"
#include "AppState.hpp"
#include <QDebug>
#include <QJsonObject>
#include <QNetworkReply>
#include <QDateTime>

AuthService::AuthService(APIFactory *apiFactory, QObject *parent)
    : m_restful(apiFactory->createRESTful()), QObject(parent)
{
}

void AuthService::loginUser(const QString &email, const QString &password)
{
    // Handle invalid input
    if (email.isEmpty() || password.isEmpty())
    {
        emit loginFailed("email or password are required");
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
        emit loginFailed("Invalid endpoint for login");
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onLoginFinished);
}

void AuthService::registerUser(const QString &email, const QString &password, const QString &name, const QString &dob)
{
    // Handle invalid input
    if (email.isEmpty() || password.isEmpty() || name.isEmpty() || dob.isEmpty())
    {
        emit registerFailed("Email, password, name, and date of birth are required");
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
            emit registerFailed("Invalid dateOfBirth format");
            return;
        }
    }
    json["dateOfBirth"] = formattedDob;

    // Handle register reply
    QNetworkReply *reply = m_restful->post("register", json);
    if (!reply)
    {
        emit registerFailed("Invalid endpoint for register");
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onRegisterFinished);
}

void AuthService::changePassword(const int &userId, const QString &oldPassword, const QString &newPassword)
{
    // Handle invalid input
    if (userId <= 0)
    {
        emit changePasswordFailed("Invalid User ID");
        return;
    }

    if (oldPassword.isEmpty() || newPassword.isEmpty())
    {
        emit changePasswordFailed("Both current and new password are required");
        return;
    }

    // Handle valid input
    QString endpoint = QString("update").arg(userId);
    QJsonObject json;
    json["password"] = newPassword;

    // Handle reply
    QNetworkReply *reply = m_restful->put(endpoint, json, AppState::instance()->getToken());
    if (!reply)
    {
        emit changePasswordFailed("Invalid endpoint for update");
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onChangePasswordFinished);
}

void AuthService::onLoginFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
    {
        emit loginFailed("Invalid reply object");
        return;
    }

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
            bool success = !message.contains("error", Qt::CaseInsensitive);

            if (success)
            {
                if (obj.contains("token") && obj.contains("user"))
                {
                    QString token = obj["token"].toString();
                    QJsonObject user = obj["user"].toObject();
                    AppState::instance()->saveToken(token);
                    AppState::instance()->saveUserInfo(user);
                    emit loginSuccessed(message);
                }
                else
                {
                    emit loginFailed("Invalid login response from server");
                }
            }
            else
            {
                emit loginFailed(message);
            }
        }
        else
        {
            emit loginFailed("Invalid response from server");
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
        emit loginFailed(message);
    }

    reply->deleteLater();
}

void AuthService::onRegisterFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
    {
        emit registerFailed("Invalid reply object");
        return;
    }

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
            emit registerSuccess(message);
        }
        else
        {
            emit registerFailed("Invalid response from server");
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
        emit registerFailed(message);
    }

    reply->deleteLater();
}

void AuthService::onChangePasswordFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (!reply)
    {
        emit changePasswordFailed("Invalid reply object");
        return;
    }

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
            if (obj.contains("user"))
            {
                QJsonObject user = obj["user"].toObject();
                AppState::instance()->saveUserInfo(user);
            }
            emit changePasswordSuccess(message);
        }
        else
        {
            emit changePasswordFailed("Invalid response from server");
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
        emit changePasswordFailed(message);
    }

    reply->deleteLater();
}