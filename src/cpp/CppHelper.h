#ifndef KEYHANDLER_H
#define KEYHANDLER_H

#include <QObject>
#include <QVariant>
#include <QTime>


class CppHelper : public QObject
{
    Q_OBJECT

public:
    explicit CppHelper(QObject *parent = nullptr);
    Q_INVOKABLE void openUrl(QString url);

    Q_INVOKABLE QVariantMap today();
    Q_INVOKABLE QVariantMap yesterday();
    Q_INVOKABLE QVariantMap thisWeek();
    Q_INVOKABLE QVariantMap thisMonth();
    Q_INVOKABLE QVariantMap lastMonth();
    Q_INVOKABLE QDateTime toDate(QVariant obj);
    Q_INVOKABLE QString createUUID() const;
    Q_INVOKABLE QString createShortID() const;



protected:
     bool eventFilter(QObject *obj, QEvent *event) override;

signals:
     void back();

public slots:
};

#endif // KEYHANDLER_H
