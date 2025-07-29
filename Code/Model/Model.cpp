#include "Model.hpp"
#include <iostream>

Model::Model()
    : name(" ")
{
}

void Model::setName(const QString &name_)
{
    name = name_;
}

QString Model::getName() const
{
    return name;
}