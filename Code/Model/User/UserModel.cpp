#include "UserModel.hpp"

UserModel::UserModel(QObject *parent)
    : QObject(parent)
{
}

QString UserModel::getEmail() const
{
    return m_email;
}

QString UserModel::getName() const
{
    return m_name;
}

QDate UserModel::getDateOfBirth() const
{
    return m_dateOfBirth;
}

int UserModel::getId() const
{
    return m_id;
}

void UserModel::setEmail(const QString &email)
{
    if (m_email != email)
    {
        m_email = email;
        emit emailChanged();
    }
}

void UserModel::setName(const QString &name)
{
    if (m_name != name)
    {
        m_name = name;
        emit nameChanged();
    }
}

void UserModel::setDateOfBirth(const QDate &dateOfBirth)
{
    if (m_dateOfBirth != dateOfBirth)
    {
        m_dateOfBirth = dateOfBirth;
        emit dateOfBirthChanged();
    }
}

void UserModel::setId(const int &id)
{
    if (m_id != id)
    {
        m_id = id;
        emit idChanged();
    }
}
