#include "RESTful.hpp"
#include <QUrl>
#include <QJsonDocument>

RESTful::RESTful(const QString &baseURL, QObject *parent)
    : m_baseURL(baseURL),
      QObject(parent)
{
    initializeEndpoints();
}

void RESTful::initializeEndpoints()
{
    m_endpoints["login"] = "/auth/login";
    m_endpoints["register"] = "/auth/register";
    m_endpoints["users"] = "/auth/users";
}

QNetworkRequest RESTful::createRequest(const QString &endpointKey, const QString &token)
{
    // Get corresponding enpoint
    QString endpoint = m_endpoints.value(endpointKey, "");
    if(endpoint.isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": Endpoint key not found: " << endpointKey;
        return QNetworkRequest();
    }
    
    // Create request
    QUrl url(m_baseURL + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    // Check the existence of token
    if(!token.isEmpty())
    {
        request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    }
    return request;
}

QNetworkReply *RESTful::get(const QString &endpointKey, const QString token)
{
    QNetworkRequest request = createRequest(endpointKey, token);
    if(request.url().isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": endpoint is empty";
        return nullptr;
    }
    return m_networkManager->get(request);
}

QNetworkReply *RESTful::post(const QString &endpointKey, const QJsonObject &data, const QString token)
{
    QNetworkRequest request = createRequest(endpointKey, token);
    if(request.url().isEmpty())
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
    if(request.url().isEmpty())
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
    if(request.url().isEmpty())
    {
        qDebug() << Q_FUNC_INFO << ": endpoint is empty";
        return nullptr;
    }
    return m_networkManager->deleteResource(request);
}
