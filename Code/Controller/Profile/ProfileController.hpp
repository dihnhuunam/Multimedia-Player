#pragma once
#include <QObject>

class ProfileController : public QObject
{
    Q_OBJECT
public:
    explicit ProfileController(QObject *parent = nullptr)
    {
    }

    ~ProfileController() {}
};