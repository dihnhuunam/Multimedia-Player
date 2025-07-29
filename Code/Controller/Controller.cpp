#include "Controller.hpp"

Controller::Controller(Model &model_, QObject *parent)
    : model(model_), QObject(parent)
{
}

QString Controller::getName() const
{
    return model.getName();
}

void Controller::setName(const QString &name)
{
    model.setName(name);
    emit nameChanged();
}