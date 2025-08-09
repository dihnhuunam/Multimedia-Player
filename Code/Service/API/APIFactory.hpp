#pragma once
#include "RESTful.hpp"
#include <QObject>
#include <QString>

class APIFactory : public QObject
{
    Q_OBJECT
public:
    explicit APIFactory(const QString &baseURL, QObject *parent = nullptr);
    RESTful *createRESTful();

private:
    QString m_baseURL;
};