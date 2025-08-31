#pragma once
#include <QObject>
#include <QSettings>
#include <QString>
#include "UserData.hpp"

class AppState : public QObject
{
    Q_OBJECT
public:
    static AppState *instance();

    void saveToken(const QString &token);
    void clearToken();
    void saveUserInfo(const UserData &userData);
    QString getToken() const;

    QString getEmail() const;
    QString getName() const;
    QString getDateOfBirth() const;
    QString getRole() const;
    int getUserId() const;

    void setEmail(const QString &email);
    void setName(const QString &name);
    void setDateOfBirth(const QString &dateOfBirth);
    void setRole(const QString &role);
    void setToken(const QString &token);

signals:
    void valueChanged();

private:
    AppState(QObject *parent = nullptr);
    static AppState *m_instance;
    QSettings *m_settings;
    QString m_email;
    QString m_name;
    QString m_dateOfBirth;
    QString m_role;
    int m_userId;
    QString m_token;
};