#pragma once
#include <QObject>
#include <QString>
#include <QDate>

class UserModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString email READ getEmail WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDate dateOfBirth READ getDateOfBirth WRITE setDateOfBirth NOTIFY dateOfBirthChanged)

public:
    explicit UserModel(QObject *parent = nullptr);

    QString getEmail() const;
    QString getName() const;
    QDate getDateOfBirth() const;

    void setEmail(const QString &email);
    void setName(const QString &name);
    void setDateOfBirth(const QDate &dateOfBirth);

signals:
    void emailChanged();
    void nameChanged();
    void dateOfBirthChanged();

private:
    QString m_email;
    QString m_name;
    QDate m_dateOfBirth;
};