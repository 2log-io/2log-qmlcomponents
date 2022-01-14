#ifndef NFCREADER_H
#define NFCREADER_H

#include <QObject>
#include <QNearFieldManager>

class NFCReader : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)

public:
    explicit NFCReader(QObject *parent = nullptr);
    Q_INVOKABLE void startRead();
    bool ready();

private:
    QNearFieldManager* _manager;

signals:
    void uidRead(QString uid);

private slots:
    void targetDetected(QNearFieldTarget *target);
    void targetLost(QNearFieldTarget *target);
    void handleAdapterStateChange(QNearFieldManager::AdapterState state);
    void errSlot(QNearFieldTarget::Error error, const QNearFieldTarget::RequestId &id);

signals:
    void readyChanged();

};

#endif // NFCREADER_H
