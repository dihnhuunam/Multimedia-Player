#pragma once
#include <QString>

class Model
{
public:
    Model();
    QString getName() const;
    void setName(const QString &name_);

private:
    QString name;
};