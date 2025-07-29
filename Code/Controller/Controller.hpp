#pragma once
#include "Model.hpp"
#include <QObject>
#include <QString>

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)

public:
    explicit Controller(Model &model_, QObject *parent = nullptr);
    QString getName() const;
    void setName(const QString &name);

signals:
    void nameChanged();

private:
    Model model;
};