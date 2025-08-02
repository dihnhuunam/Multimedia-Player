#pragma once
#include <QObject>
#include <QString>

class IAuthModel : public QObject
{
    Q_OBJECT
public:
    explicit IAuthModel(QObject *parent = nullptr) : QObject(parent) {}
    virtual void loginUser(const QString &username, const QString &password) = 0;
    virtual void registerUser(const QString &username, const QString &password, const QString &name, const QString &dob) = 0;

signals:
    void loginResult(bool success, const QString &message);
    void registerResult(bool success, const QString &message);
};