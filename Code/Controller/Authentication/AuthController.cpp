#include "AuthController.hpp"
#include "APIFactory.hpp"

AuthController::AuthController(AuthService *authService, AppState *appState, UserModel *userModel, QObject *parent)
    : QObject(parent), authService(authService), appState(appState), userModel(userModel)
{
    Q_ASSERT(authService != nullptr);
    Q_ASSERT(appState != nullptr);
    Q_ASSERT(userModel != nullptr);
    qDebug() << "AuthService pointer:" << authService;

    // Handle Login
    connect(authService, &AuthService::loginSuccessed, this, &AuthController::onLoginSuccessed);
    connect(authService, &AuthService::loginFailed, this, &AuthController::onLoginFailed);

    // Handle Register
    connect(authService, &AuthService::registerSuccess, this, &AuthController::onRegisterSuccess);
    connect(authService, &AuthService::registerFailed, this, &AuthController::onRegisterFailed);

    // Handle Change Password
    connect(authService, &AuthService::changePasswordSuccess, this, &AuthController::onChangePasswordSuccess);
    connect(authService, &AuthService::changePasswordFailed, this, &AuthController::onChangePasswordFailed);
}

void AuthController::loginUser(const QString &email, const QString &password)
{
    authService->loginUser(email, password);
}

void AuthController::registerUser(const QString &email, const QString &password, const QString &name, const QString &dob)
{
    authService->registerUser(email, password, name, dob);
}

void AuthController::changePassword(const int &userId, const QString &oldPassword, const QString &newPassword)
{
    authService->changePassword(userId, oldPassword, newPassword);
}

UserModel *AuthController::getUserModel()
{
    return userModel;
}

void AuthController::onLoginSuccessed(const QString &message)
{
    QString email = appState->getEmail();
    QString name = appState->getName();
    QString dob = appState->getDateOfBirth();
    QDate dateOfBirth = dob.isEmpty() ? QDate() : QDate::fromString(dob, Qt::ISODate);

    userModel->setEmail(email);
    userModel->setName(name);
    userModel->setDateOfBirth(dateOfBirth);

    emit loginSuccessed(message);
}

void AuthController::onLoginFailed(const QString &message)
{
    emit loginFailed(message);
}

void AuthController::onRegisterSuccess(const QString &message)
{
    emit registerSuccess(message);
}

void AuthController::onRegisterFailed(const QString &message)
{
    emit registerFailed(message);
}

void AuthController::onChangePasswordSuccess(const QString &message)
{
    QString email = appState->getEmail();
    QString name = appState->getName();
    QString dob = appState->getDateOfBirth();
    QDate dateOfBirth = dob.isEmpty() ? QDate() : QDate::fromString(dob, Qt::ISODate);

    userModel->setEmail(email);
    userModel->setName(name);
    userModel->setDateOfBirth(dateOfBirth);

    emit changePasswordSuccess(message);
}

void AuthController::onChangePasswordFailed(const QString &message)
{
    emit changePasswordFailed(message);
}