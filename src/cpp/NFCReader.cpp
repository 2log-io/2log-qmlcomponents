#include "NFCReader.h"
#include <QNearFieldTarget>
#include <QDebug>


NFCReader::NFCReader(QObject *parent) : QObject(parent),
    _manager(new QNearFieldManager(this))
{
    connect(_manager, SIGNAL(targetDetected(QNearFieldTarget*)), this, SLOT(targetDetected(QNearFieldTarget*)));
    connect(_manager, SIGNAL(targetLost(QNearFieldTarget*)), this, SLOT(targetLost(QNearFieldTarget*)));
  //  connect(_manager, &QNearFieldManager::error, this, &NFCReader::errSlot);
    connect(_manager, &QNearFieldManager::adapterStateChanged,
            this, &NFCReader::handleAdapterStateChange);
}

void NFCReader::startRead()
{
    qDebug()<< Q_FUNC_INFO;
    qDebug()<<_manager->startTargetDetection(QNearFieldTarget::AnyAccess);

}

bool NFCReader::ready()
{
    qDebug()<< Q_FUNC_INFO;
    return _manager->isEnabled();
}

void NFCReader::targetDetected(QNearFieldTarget *target)
{
    qDebug()<< Q_FUNC_INFO;
    QString uid = target->uid().toHex().toUpper();
    qDebug()<< uid;
    Q_EMIT uidRead(uid);
}

void NFCReader::targetLost(QNearFieldTarget *target)
{
    qDebug()<< Q_FUNC_INFO;
    target->deleteLater();
}

void NFCReader::handleAdapterStateChange(QNearFieldManager::AdapterState state)
{
    qDebug()<< Q_FUNC_INFO;

    if (state == QNearFieldManager::AdapterState::Online) {
        qDebug()<<"ONLINE";
    } else if (state == QNearFieldManager::AdapterState::Offline) {
        qDebug()<<"OFFLINE";
    }
}

void NFCReader::errSlot(QNearFieldTarget::Error error, const QNearFieldTarget::RequestId &id)
{
    qDebug()<<error;

}
