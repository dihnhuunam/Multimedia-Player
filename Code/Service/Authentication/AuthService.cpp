#include "AuthService.hpp"
#include <QDebug>
#include <QJsonObject>
#include <QNetworkReply>
#include <QDateTime>

AuthService::AuthService(APIFactory *apiFactory, QObject *parent)
    : m_restful(apiFactory->createRESTful()),
      QObject(parent)
{
    m_appState = AppState::instance();
}

void AuthService::loginUser(const QString &email, const QString &password)
{
    // Handle invalid input
    if (email.isEmpty() || password.isEmpty())
    {
        UserData userData;
        userData.message = "Email or password are required";
        userData.id = -1;
        emit loginFinished(false, userData);
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
        UserData userData;
        userData.message = "Invalid endpoint for login";
        userData.id = -1;
        emit loginFinished(false, userData);
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onLoginReply);
}

void AuthService::registerUser(const QString &email, const QString &password, const QString &name, const QString &dob)
{
    // Handle invalid input
    if (email.isEmpty() || password.isEmpty() || name.isEmpty() || dob.isEmpty())
    {
        UserData userData;
        userData.message = "Email, password, name, and date of birth are required";
        userData.id = -1;
        emit registerFinished(false, userData);
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
            UserData userData;
            userData.message = "Invalid dateOfBirth format";
            userData.id = -1;
            emit registerFinished(false, userData);
            return;
        }
    }
    json["dateOfBirth"] = formattedDob;

    // Handle register reply
    QNetworkReply *reply = m_restful->post("register", json);
    if (!reply)
    {
        UserData userData;
        userData.message = "Invalid endpoint for register";
        userData.id = -1;
        emit registerFinished(false, userData);
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onRegisterReply);
}

void AuthService::changePassword(const int &userId, const QString &oldPassword, const QString &newPassword)
{
    // Handle invalid input
    if (userId <= 0)
    {
        UserData userData;
        userData.message = "Invalid User ID";
        userData.id = -1;
        emit changePasswordFinished(false, userData);
        return;
    }

    if (oldPassword.isEmpty() || newPassword.isEmpty())
    {
        UserData userData;
        userData.message = "Both current and new password are required";
        userData.id = -1;
        emit changePasswordFinished(false, userData);
        return;
    }

    // Handle valid input
    QString endpoint = QString("users/%1").arg(userId);
    QJsonObject json;
    json["password"] = newPassword;

    // Handle reply
    QNetworkReply *reply = m_restful->put(endpoint, json, m_appState->getToken());
    if (!reply)
    {
        UserData userData;
        userData.message = "Invalid endpoint for update";
        userData.id = -1;
        emit changePasswordFinished(false, userData);
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onChangePasswordReply);
}

void AuthService::changeName(const int &userId, const QString &name)
{
    // Handle invalid input
    if (userId <= 0)
    {
        UserData userData;
        userData.message = "Invalid User ID";
        userData.id = -1;
        emit changeNameFinished(false, userData);
        return;
    }

    if (name.isEmpty())
    {
        UserData userData;
        userData.message = "Name is required";
        userData.id = -1;
        emit changeNameFinished(false, userData);
        return;
    }

    // Handle valid input
    QString endpoint = QString("users/%1").arg(userId);
    QJsonObject json;
    json["name"] = name;

    // Handle reply
    QNetworkReply *reply = m_restful->put(endpoint, json, m_appState->getToken());
    if (!reply)
    {
        UserData userData;
        userData.message = "Invalid endpoint for update";
        userData.id = -1;
        emit changeNameFinished(false, userData);
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onChangeNameReply);
}

void AuthService::changeDob(const int &userId, const QString &dob)
{
    // Handle invalid input
    if (userId <= 0)
    {
        UserData userData;
        userData.message = "Invalid User ID";
        userData.id = -1;
        emit changeDobFinished(false, userData);
        return;
    }

    if (dob.isEmpty())
    {
        UserData userData;
        userData.message = "Date of birth is required";
        userData.id = -1;
        emit changeDobFinished(false, userData);
        return;
    }

    // Validate date of birth
    QString formattedDob = dob;
    QDateTime date = QDateTime::fromString(dob, "yyyy-MM-dd");
    if (!date.isValid())
    {
        date = QDateTime::fromString(dob, Qt::ISODate);
    }
    if (!date.isValid())
    {
        UserData userData;
        userData.message = "Invalid dateOfBirth format";
        userData.id = -1;
        emit changeDobFinished(false, userData);
        return;
    }
    formattedDob = date.toUTC().toString(Qt::ISODate);

    // Handle valid input
    QString endpoint = QString("users/%1").arg(userId);
    QJsonObject json;
    json["dateOfBirth"] = formattedDob;

    // Handle reply
    QNetworkReply *reply = m_restful->put(endpoint, json, m_appState->getToken());
    if (!reply)
    {
        UserData userData;
        userData.message = "Invalid endpoint for update";
        userData.id = -1;
        emit changeDobFinished(false, userData);
        return;
    }
    connect(reply, &QNetworkReply::finished, this, &AuthService::onChangeDobReply);
}

void AuthService::onLoginReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    UserData userData;
    bool success = false;
    userData.id = -1; // Default ID

    if (!reply)
    {
        userData.message = "Invalid reply object";
        emit loginFinished(false, userData);
        return;
    }

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (obj.contains("user") && obj.contains("token"))
            {
                QJsonObject userObj = obj["user"].toObject();
                userData.email = userObj["email"].toString();
                userData.name = userObj["name"].toString();
                userData.dob = userObj["dateOfBirth"].toString();
                userData.role = userObj["role"].toString();
                userData.id = userObj.contains("id") ? userObj["id"].toInt() : -1;
                userData.token = obj["token"].toString();
                success = true;
            }
            else
            {
                userData.message = "Invalid response from server";
            }
        }
        else
        {
            userData.message = "Invalid response from server";
        }
    }
    else
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (userData.message.isEmpty())
            {
                userData.message = reply->errorString();
            }
        }
        else
        {
            userData.message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (userData.message.isEmpty())
                userData.message = "Bad request: Invalid input data";
            break;
        case 401:
            if (userData.message.isEmpty())
                userData.message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (userData.message.isEmpty())
                userData.message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (userData.message.isEmpty())
                userData.message = "Resource not found";
            break;
        case 409:
            if (userData.message.isEmpty())
                userData.message = "Conflict: Resource already exists";
            break;
        case 500:
            if (userData.message.isEmpty())
                userData.message = "Internal server error";
            break;
        default:
            if (userData.message.isEmpty())
                userData.message = "Unknown error occurred";
            break;
        }
    }

    emit loginFinished(success, userData);
    reply->deleteLater();
}

void AuthService::onRegisterReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    UserData userData;
    bool success = false;
    userData.id = -1; // Default ID

    if (!reply)
    {
        userData.message = "Invalid reply object";
        emit registerFinished(false, userData);
        return;
    }

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (!userData.message.isEmpty())
            {
                success = true;
            }
            else
            {
                userData.message = "Invalid response from server";
            }
        }
        else
        {
            userData.message = "Invalid response from server";
        }
    }
    else
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (userData.message.isEmpty())
            {
                userData.message = reply->errorString();
            }
        }
        else
        {
            userData.message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (userData.message.isEmpty())
                userData.message = "Bad request: Invalid input data";
            break;
        case 401:
            if (userData.message.isEmpty())
                userData.message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (userData.message.isEmpty())
                userData.message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (userData.message.isEmpty())
                userData.message = "Resource not found";
            break;
        case 409:
            if (userData.message.isEmpty())
                userData.message = "Conflict: Resource already exists";
            break;
        case 500:
            if (userData.message.isEmpty())
                userData.message = "Internal server error";
            break;
        default:
            if (userData.message.isEmpty())
                userData.message = "Unknown error occurred";
            break;
        }
    }

    emit registerFinished(success, userData);
    reply->deleteLater();
}

void AuthService::onChangePasswordReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    UserData userData;
    bool success = false;
    userData.id = -1; // Default ID

    if (!reply)
    {
        userData.message = "Invalid reply object";
        emit changePasswordFinished(false, userData);
        return;
    }

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (obj.contains("user"))
            {
                QJsonObject userObj = obj["user"].toObject();
                userData.email = userObj["email"].toString();
                userData.name = userObj["name"].toString();
                userData.dob = userObj["dateOfBirth"].toString();
                userData.role = userObj["role"].toString();
                userData.id = userObj.contains("id") ? userObj["id"].toInt() : -1;
                success = true;
            }
            else
            {
                userData.message = "Invalid response from server";
            }
        }
        else
        {
            userData.message = "Invalid response from server";
        }
    }
    else
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (userData.message.isEmpty())
            {
                userData.message = reply->errorString();
            }
        }
        else
        {
            userData.message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (userData.message.isEmpty())
                userData.message = "Bad request: Invalid input data";
            break;
        case 401:
            if (userData.message.isEmpty())
                userData.message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (userData.message.isEmpty())
                userData.message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (userData.message.isEmpty())
                userData.message = "Resource not found";
            break;
        case 409:
            if (userData.message.isEmpty())
                userData.message = "Conflict: Resource already exists";
            break;
        case 500:
            if (userData.message.isEmpty())
                userData.message = "Internal server error";
            break;
        default:
            if (userData.message.isEmpty())
                userData.message = "Unknown error occurred";
            break;
        }
    }

    emit changePasswordFinished(success, userData);
    reply->deleteLater();
}

void AuthService::onChangeNameReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    UserData userData;
    bool success = false;
    userData.id = -1; // Default ID

    if (!reply)
    {
        userData.message = "Invalid reply object";
        emit changeNameFinished(false, userData);
        return;
    }

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (obj.contains("user"))
            {
                QJsonObject userObj = obj["user"].toObject();
                userData.email = userObj["email"].toString();
                userData.name = userObj["name"].toString();
                userData.dob = userObj["dateOfBirth"].toString();
                userData.role = userObj["role"].toString();
                userData.id = userObj.contains("id") ? userObj["id"].toInt() : -1;
                success = true;
            }
            else
            {
                userData.message = "Invalid response from server";
            }
        }
        else
        {
            userData.message = "Invalid response from server";
        }
    }
    else
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (userData.message.isEmpty())
            {
                userData.message = reply->errorString();
            }
        }
        else
        {
            userData.message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (userData.message.isEmpty())
                userData.message = "Bad request: Invalid input data";
            break;
        case 401:
            if (userData.message.isEmpty())
                userData.message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (userData.message.isEmpty())
                userData.message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (userData.message.isEmpty())
                userData.message = "Resource not found";
            break;
        case 409:
            if (userData.message.isEmpty())
                userData.message = "Conflict: Resource already exists";
            break;
        case 500:
            if (userData.message.isEmpty())
                userData.message = "Internal server error";
            break;
        default:
            if (userData.message.isEmpty())
                userData.message = "Unknown error occurred";
            break;
        }
    }

    emit changeNameFinished(success, userData);
    reply->deleteLater();
}

void AuthService::onChangeDobReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    UserData userData;
    bool success = false;
    userData.id = -1; // Default ID

    if (!reply)
    {
        userData.message = "Invalid reply object";
        emit changeDobFinished(false, userData);
        return;
    }

    int httpStatus = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QByteArray responseData = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(responseData);

    if (reply->error() == QNetworkReply::NoError && (httpStatus >= 200 && httpStatus < 300))
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (obj.contains("user"))
            {
                QJsonObject userObj = obj["user"].toObject();
                userData.email = userObj["email"].toString();
                userData.name = userObj["name"].toString();
                userData.dob = userObj["dateOfBirth"].toString();
                userData.role = userObj["role"].toString();
                userData.id = userObj.contains("id") ? userObj["id"].toInt() : -1;
                success = true;
            }
            else
            {
                userData.message = "Invalid response from server";
            }
        }
        else
        {
            userData.message = "Invalid response from server";
        }
    }
    else
    {
        if (!doc.isNull() && doc.isObject())
        {
            QJsonObject obj = doc.object();
            userData.message = obj["message"].toString();
            if (userData.message.isEmpty())
            {
                userData.message = reply->errorString();
            }
        }
        else
        {
            userData.message = reply->errorString();
        }

        switch (httpStatus)
        {
        case 400:
            if (userData.message.isEmpty())
                userData.message = "Bad request: Invalid input data";
            break;
        case 401:
            if (userData.message.isEmpty())
                userData.message = "Unauthorized: Invalid credentials";
            break;
        case 403:
            if (userData.message.isEmpty())
                userData.message = "Forbidden: Insufficient permissions";
            break;
        case 404:
            if (userData.message.isEmpty())
                userData.message = "Resource not found";
            break;
        case 409:
            if (userData.message.isEmpty())
                userData.message = "Conflict: Resource already exists";
            break;
        case 500:
            if (userData.message.isEmpty())
                userData.message = "Internal server error";
            break;
        default:
            if (userData.message.isEmpty())
                userData.message = "Unknown error occurred";
            break;
        }
    }

    emit changeDobFinished(success, userData);
    reply->deleteLater();
}