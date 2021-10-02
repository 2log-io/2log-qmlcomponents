#include "NFCReader.h"
#include <QNearFieldTarget>
#include <QDebug>


NFCReader::NFCReader(QObject *parent) : QObject(parent),
    _manager(new QNearFieldManager(this))
{
    connect(_manager, SIGNAL(targetDetected(QNearFieldTarget*)), this, SLOT(targetDetected(QNearFieldTarget*)));
    connect(_manager, SIGNAL(targetLost(QNearFieldTarget*)), this, SLOT(targetLost(QNearFieldTarget*)));
}

void NFCReader::startRead()
{
    _manager->setTargetAccessModes(QNearFieldManager::NdefReadTargetAccess);
    _manager->startTargetDetection();
}

bool NFCReader::ready()
{
    return _manager->isAvailable();
}



void NFCReader::targetDetected(QNearFieldTarget *target)
{
    QString uid = target->uid().toHex().toUpper();
    qDebug()<< uid;
    Q_EMIT uidRead(uid);
}

void NFCReader::targetLost(QNearFieldTarget *target)
{
    target->deleteLater();
}
