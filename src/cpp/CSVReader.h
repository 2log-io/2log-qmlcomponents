#ifndef CSVREADER_H
#define CSVREADER_H

#include <QObject>
#include <QFile>
#include <QQmlParserStatus>
#include <QVariant>
#include <QTextStream>
#include <QDate>

class CSVReader : public QObject,  public QQmlParserStatus
{
    Q_OBJECT

    Q_PROPERTY(int mailIndex MEMBER _mailIndex NOTIFY mailIndexChanged)
    Q_PROPERTY(int nameIndex MEMBER _nameIndex NOTIFY nameIndexChanged)
    Q_PROPERTY(int surnameIndex MEMBER _surnameIndex NOTIFY surnameIndexChanged)
    Q_PROPERTY(int cardIndex MEMBER _cardIndex NOTIFY cardIndexChanged)
    Q_PROPERTY(int permissionIndex MEMBER _permissionIndex NOTIFY permissionIndexChanged)
    Q_PROPERTY(int roleIndex MEMBER _roleIndex NOTIFY roleIndexChanged)
    Q_PROPERTY(int courseIndex MEMBER _courseIndex NOTIFY courseIndexChanged)
    Q_PROPERTY(int balanceIndex MEMBER _balanceIndex NOTIFY balanceIndexChanged)
    Q_PROPERTY(int groupIndex MEMBER _groupIndex NOTIFY groupIndexChanged)
    Q_PROPERTY(int permissionExpirationIndex MEMBER _permissionExpirationIndex NOTIFY permissionExpirationIndexChanged)

    Q_PROPERTY(int count READ getCount NOTIFY finished)
    Q_PROPERTY(QString filename READ getFileName WRITE setFileName NOTIFY fileNameChanged)

    Q_PROPERTY(QString overwriteCourse  MEMBER _course NOTIFY overwriteDataChanged)
    Q_PROPERTY(QString overwriteRole    MEMBER _role NOTIFY overwriteDataChanged)
    Q_PROPERTY(QString overwriteGroup   MEMBER _group NOTIFY overwriteDataChanged)
    Q_PROPERTY(QDateTime overwriteDate   MEMBER _expiration NOTIFY overwriteDataChanged)
    Q_PROPERTY(int overwriteBalance MEMBER _balance NOTIFY overwriteDataChanged)

    Q_INTERFACES(QQmlParserStatus)

public:
    struct Log
    {
        QVariantMap user;
        QString errorMsg;
        QString lineString;
        int lineNumber;
    };

    explicit CSVReader(QObject *parent = nullptr);
    explicit CSVReader(QString filename, QObject *parent = nullptr);
    Q_INVOKABLE QString turnCardID(QString cardID);
    Q_INVOKABLE bool readURL(QString url = "");
    Q_INVOKABLE void readFromDialog();
    Q_INVOKABLE bool read();
    Q_INVOKABLE void downloadSampleCSV();
    Q_INVOKABLE QVariantMap getIndex(int index);
    int getCount() const;

    QString getFileName() const;
    void setFileName(const QString &fileName);

    virtual void componentComplete() override;
    virtual void classBegin() override {}


private:
    int             _mailIndex = -1;
    int             _nameIndex = -1 ;
    int             _surnameIndex = -1;
    int             _cardIndex = -1;
    int             _permissionIndex = -1;
    int             _roleIndex = -1;
    int             _courseIndex = -1;
    int             _balanceIndex = -1;
    int             _groupIndex = -1;
    int             _permissionExpirationIndex = -1;
    QByteArray      _content;
    QString         _fileName;
    QVariantList    _items;
    QList<Log>      _logs;

    QString         _course;
    QString         _role;
    QString         _group;
    QDateTime       _expiration;
    int             _balance;


signals:
    void mailIndexChanged();
    void nameIndexChanged();
    void cardIndexChanged();
    void surnameIndexChanged();
    void finished();
    void fileNameChanged();
    void balanceIndexChanged();
    void courseIndexChanged();
    void roleIndexChanged();
    void permissionIndexChanged();
    void groupIndexChanged();
    void permissionExpirationIndexChanged();
    void balanceChanged();
    void groupChanged();
    void courseChanged();
    void expirationChanged();
    void overwriteDataChanged();
    void wrongFileFormat();
    void fileLoaded();


signals:

public slots:
};

#endif // CSVREADER_H
