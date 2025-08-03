#include "AppState.hpp"
#include <QDebug>
#include <QDateTime>

AppState *AppState::m_instance = nullptr;

AppState::AppState(QObject *parent)
    : QObject(parent),
      //   m_settings(new QSettings("MediaPlayer", "AppState", this)),
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
    setEmail(user.contains("email") ? user["email"].toString() : m_email);
    setName(user.contains("name") ? user["name"].toString() : m_name);

    QString dateOfBirth = user.contains("dateOfBirth") ? user["dateOfBirth"].toString() : m_dateOfBirth;
    if (!dateOfBirth.isEmpty())
    {
        QDateTime date = QDateTime::fromString(dateOfBirth, Qt::ISODate);
        if (!date.isValid())
        {
            qDebug() << "Invalid ISO 8601 date format for dob in saveUserInfo:" << dateOfBirth;
        }
        else
        {
            setDateOfBirth(dateOfBirth);
        }
    }

    setRole(user.contains("role") ? user["role"].toString() : m_role);
    setUserId(user.contains("id") ? user["id"].toInt() : m_userId);
}

QString AppState::getToken() const
{
    return m_token;
}

QString AppState::email() const
{
    return m_email;
}

QString AppState::name() const
{
    return m_name;
}

QString AppState::dateOfBirth() const
{
    return m_dateOfBirth;
}

QString AppState::role() const
{
    return m_role;
}

int AppState::userId() const
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