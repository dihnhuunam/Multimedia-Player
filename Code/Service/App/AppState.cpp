#include "AppState.hpp"
#include <QDebug>
#include <QDateTime>

AppState *AppState::m_instance = nullptr;

AppState::AppState(QObject *parent)
    : QObject(parent),
      m_settings(new QSettings("AppState.ini", QSettings::IniFormat, this)),
      m_userId(-1)
{
    // Init data members
    m_email = m_settings->value("user/email", "").toString();
    m_name = m_settings->value("user/name", "").toString();
    m_dateOfBirth = m_settings->value("user/dateOfBirth", "").toString();
    m_role = m_settings->value("user/role", "").toString();
    m_userId = m_settings->value("user/id", -1).toInt();
    m_token = m_settings->value("jwt_token", "").toString();
}

AppState *AppState::instance()
{
    if (!m_instance)
    {
        m_instance = new AppState();
    }
    return m_instance;
}

void AppState::saveToken(const QString &token)
{
    setToken(token);
}

void AppState::clearToken()
{
    bool changed = false;
    if (!m_token.isEmpty())
    {
        m_token.clear();
        m_settings->remove("jwt_token");
        changed = true;
    }
    if (!m_email.isEmpty())
    {
        m_email.clear();
        m_settings->remove("user/email");
        changed = true;
    }
    if (!m_name.isEmpty())
    {
        m_name.clear();
        m_settings->remove("user/name");
        changed = true;
    }
    if (!m_dateOfBirth.isEmpty())
    {
        m_dateOfBirth.clear();
        m_settings->remove("user/dateOfBirth");
        changed = true;
    }
    if (!m_role.isEmpty())
    {
        m_role.clear();
        m_settings->remove("user/role");
        changed = true;
    }
    if (m_userId != -1)
    {
        m_userId = -1;
        m_settings->remove("user/id");
        changed = true;
    }
    if (changed)
    {
        emit valueChanged();
    }
}

void AppState::saveUserInfo(const QJsonObject &user)
{
    bool changed = false;

    // Handle email
    QString newEmail = user.contains("email") ? user["email"].toString() : m_email;
    if (m_email != newEmail)
    {
        m_email = newEmail;
        m_settings->setValue("user/email", newEmail);
        changed = true;
    }

    // Handle name
    QString newName = user.contains("name") ? user["name"].toString() : m_name;
    if (m_name != newName)
    {
        m_name = newName;
        m_settings->setValue("user/name", newName);
        changed = true;
    }

    // Handle date of birth
    QString newDateOfBirth = user.contains("dateOfBirth") ? user["dateOfBirth"].toString() : m_dateOfBirth;
    if (!newDateOfBirth.isEmpty())
    {
        QDateTime date = QDateTime::fromString(newDateOfBirth, Qt::ISODate);
        if (date.isValid())
        {
            if (m_dateOfBirth != newDateOfBirth)
            {
                m_dateOfBirth = newDateOfBirth;
                m_settings->setValue("user/dateOfBirth", newDateOfBirth);
                changed = true;
            }
        }
        else
        {
            qDebug() << "Invalid ISO 8601 date format for dob in saveUserInfo:" << newDateOfBirth;
            if (!m_dateOfBirth.isEmpty())
            {
                m_dateOfBirth.clear();
                m_settings->setValue("user/dateOfBirth", "");
                changed = true;
            }
        }
    }
    else if (m_dateOfBirth != newDateOfBirth)
    {
        m_dateOfBirth = newDateOfBirth;
        m_settings->setValue("user/dateOfBirth", newDateOfBirth);
        changed = true;
    }

    // Handle role
    QString newRole = user.contains("role") ? user["role"].toString() : m_role;
    if (m_role != newRole)
    {
        m_role = newRole;
        m_settings->setValue("user/role", newRole);
        changed = true;
    }

    // Handle user ID
    int newUserId = user.contains("id") ? user["id"].toInt() : m_userId;
    if (m_userId != newUserId)
    {
        m_userId = newUserId;
        m_settings->setValue("user/id", newUserId);
        changed = true;
    }

    if (changed)
    {
        emit valueChanged();
    }
}

QString AppState::getToken() const
{
    return m_token;
}

QString AppState::getEmail() const
{
    return m_email;
}

QString AppState::getName() const
{
    return m_name;
}

QString AppState::getDateOfBirth() const
{
    return m_dateOfBirth;
}

QString AppState::getRole() const
{
    return m_role;
}

int AppState::getUserId() const
{
    return m_userId;
}

void AppState::setEmail(const QString &email)
{
    if (m_email != email)
    {
        m_email = email;
        m_settings->setValue("user/email", email);
        emit valueChanged();
    }
}

void AppState::setName(const QString &name)
{
    if (m_name != name)
    {
        m_name = name;
        m_settings->setValue("user/name", name);
        emit valueChanged();
    }
}

void AppState::setDateOfBirth(const QString &dateOfBirth)
{
    if (m_dateOfBirth != dateOfBirth)
    {
        m_dateOfBirth = dateOfBirth;
        m_settings->setValue("user/dateOfBirth", dateOfBirth);
        emit valueChanged();
    }
}

void AppState::setRole(const QString &role)
{
    if (m_role != role)
    {
        m_role = role;
        m_settings->setValue("user/role", role);
        emit valueChanged();
    }
}

void AppState::setUserId(int userId)
{
    if (m_userId != userId)
    {
        m_userId = userId;
        m_settings->setValue("user/id", userId);
        emit valueChanged();
    }
}

void AppState::setToken(const QString &token)
{
    if (m_token != token)
    {
        m_token = token;
        m_settings->setValue("jwt_token", token);
        emit valueChanged();
    }
}