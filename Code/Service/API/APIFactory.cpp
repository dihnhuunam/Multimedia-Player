#include "APIFactory.hpp"

APIFactory::APIFactory(const QString &baseURL, QObject *parent)
    : m_baseURL(baseURL), QObject(parent)
{
}

RESTful *APIFactory::createRESTful()
{
    return new RESTful(m_baseURL, const_cast<APIFactory *>(this));
}