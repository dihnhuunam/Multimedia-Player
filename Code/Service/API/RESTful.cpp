#include "RESTful.hpp"
#include <QUrl>
#include <QJsonDocument>

RESTful::RESTful(const QString &baseURL, QObject *parent)
    : m_baseURL(baseURL),
      QObject(parent),
      m_networkManager(new QNetworkAccessManager(this))
{
    initializeEndpoints();
}

void RESTful::initializeEndpoints()
{
    m_endpoints["login"] = "/auth/login";
    m_endpoints["register"] = "/auth/register";
    m_endpoints["users"] = "/auth/users";
    m_endpoints["users/{id}"] = "/auth/users/%1";
}

QNetworkRequest RESTful::createRequest(const QString &endpointKey, const QString &token)
{
    // Get corresponding endpoint (direct lookup first)
    QString endpoint = m_endpoints.value(endpointKey, "");
    QString formattedEndpoint;

    if (!endpoint.isEmpty())
    {
        // Direct match (static endpoint)
        formattedEndpoint = endpoint;
    }
    else
    {
        // Handle dynamic endpoints (e.g., "users/3")
        QStringList parts = endpointKey.split("/");
        if (parts.size() == 2 && parts[0] == "users")
        {
            QString dynamicKey = "users/{id}";
            endpoint = m_endpoints.value(dynamicKey, "");
            if (!endpoint.isEmpty())
            {
                formattedEndpoint = endpoint.arg(parts[1]); // Substitute ID into %1
            }
        }
    }

    if (formattedEndpoint.isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": Endpoint key not found: " << endpointKey;
        return QNetworkRequest();
    }

    // Create request
    QUrl url(m_baseURL + formattedEndpoint);
    qDebug() << url;
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    if (!token.isEmpty())
    {
        request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    }
    return request;
}

QNetworkReply *RESTful::get(const QString &endpointKey, const QString token)
{
    QNetworkRequest request = createRequest(endpointKey, token);
    if (request.url().isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": endpoint is empty";
        return nullptr;
    }
    return m_networkManager->get(request);
}

QNetworkReply *RESTful::post(const QString &endpointKey, const QJsonObject &data, const QString token)
{
    QNetworkRequest request = createRequest(endpointKey, token);
    if (request.url().isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": endpoint is empty";
        return nullptr;
    }
    QJsonDocument doc(data);
    return m_networkManager->post(request, doc.toJson());
}

QNetworkReply *RESTful::put(const QString &endpointKey, const QJsonObject &data, const QString token)
{
    QNetworkRequest request = createRequest(endpointKey, token);
    if (request.url().isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": endpoint is empty";
        return nullptr;
    }
    QJsonDocument doc(data);
    return m_networkManager->put(request, doc.toJson());
}

QNetworkReply *RESTful::del(const QString &endpointKey, const QString token)
{
    QNetworkRequest request = createRequest(endpointKey, token);
    if (request.url().isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": endpoint is empty";
        return nullptr;
    }
    return m_networkManager->deleteResource(request);
}