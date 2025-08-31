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

void AppState::saveUserInfo(const UserData &userData)
{
    bool changed = false;

    // Handle email
    if (m_email != userData.email)
    {
        m_email = userData.email;
        m_settings->setValue("user/email", userData.email);
        changed = true;
    }

    // Handle name
    if (m_name != userData.name)
    {
        m_name = userData.name;
        m_settings->setValue("user/name", userData.name);
        changed = true;
    }

    // Handle date of birth
    QString newDateOfBirth = userData.dob;
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
    if (m_role != userData.role)
    {
        m_role = userData.role;
        m_settings->setValue("user/role", userData.role);
        changed = true;
    }

    // Handle user ID
    if (m_userId != userData.id)
    {
        m_userId = userData.id;
        m_settings->setValue("user/id", userData.id);
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

void AppState::setToken(const QString &token)
{
    if (m_token != token)
    {
        m_token = token;
        m_settings->setValue("jwt_token", token);
        emit valueChanged();
    }
}