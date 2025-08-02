#pragma once
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonObject>
#include <QString>
#include <QHash>

class RESTful : public QObject
{
    Q_OBJECT
public:
    explicit RESTful(const QString &baseURL, QObject *parent = nullptr);
    QNetworkReply *get(const QString &endpointKey, const QString token = "");
    QNetworkReply *post(const QString &endpointKey, const QJsonObject &data, const QString token = "");
    QNetworkReply *put(const QString &endpointKey, const QJsonObject &data, const QString token = "");
    QNetworkReply *del(const QString &endpointKey, const QString token = "");

private:
    QNetworkAccessManager *m_networkManager;
    QString m_baseURL;
    QHash<QString, QString> m_endpoints;

private:
    void initializeEndpoints();
    QNetworkRequest createRequest(const QString &endpointKey, const QString &token = "");
};
