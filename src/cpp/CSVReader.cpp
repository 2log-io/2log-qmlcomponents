/*   2log.io
 *   Copyright (C) 2021 - 2log.io | mail@2log.io,  mail@friedemann-metzger.de
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "CSVReader.h"
#include <QDebug>
#include <QDateTime>
#include <QFileDialog>
#include <QTextCodec>
#include <QFile>


CSVReader::CSVReader(QObject *parent) : QObject(parent)
{

    connect(this, &CSVReader::overwriteDataChanged, [=]{read();});
}

CSVReader::CSVReader(QString filename, QObject *parent): QObject(parent),
    _fileName(filename)
{
    qDebug() << readURL(_fileName);
}

QString CSVReader::turnCardID(QString cardID)
{
    if(cardID.count() > 14)
    {
        cardID.resize(14);
    }

    QByteArray array = QByteArray::fromHex(cardID.toLatin1());
    std::reverse(array.begin(), array.end());
    cardID = QString(array.toHex()).toUpper();
    return cardID;
}

int CSVReader::getCount() const
{
    return _items.count();
}

QString CSVReader::getFileName() const
{
    return _fileName;
}

void CSVReader::setFileName(const QString &fileName)
{
    _fileName = fileName;
    if(!_items.isEmpty())
        readURL(_fileName);
}

void CSVReader::componentComplete()
{
    readURL(_fileName);
}

bool CSVReader::read()
{
    int line = 0;
    _items.clear();
    if( _content.isEmpty())
        return false;

    QTextStream stream(_content);
    stream.setCodec(QTextCodec::codecForUtfText(_content));

    while (!stream.atEnd())
    {
        QString lineString = QString(stream.readLine()).simplified();
//        while(!lineString.endsWith(";"))
//        {
//            lineString += QString(stream.readLine()).simplified();
//        }

        QStringList data = lineString.split(";");
        if(data.count() == 1)
            data = lineString.split(",");

        if(line == 0)
        {
            qDebug()<<lineString;
            int column = 0;
            foreach(QString string, data)
            {
                string = string.toLower();
             //   qDebug()<<string<<"  "<<column;
                if(string.toUpper() == "ID"  || string.toLower().contains("card") || string.toLower().contains("karte") || string.toLower().contains("chip"))
                {

                    _cardIndex = column;
                    Q_EMIT cardIndexChanged();
                 //   qDebug()<<"Karte: "<<_cardIndex;
                }

                if(string.contains("permission")  || string.contains("berechtigung"))
                {
                    _permissionIndex = column;
                    Q_EMIT permissionIndexChanged();
                //    qDebug()<<"Berechtigung: "<<column;
                }

              //  qDebug()<<string;

                if(string.contains("balance")  || string.contains("guthaben"))
                {
                    _balanceIndex = column;
                    Q_EMIT balanceIndexChanged();
              //       qDebug()<<"Guthaben: "<<column;
                }

                if(string.contains("vorname")  || (string.contains("name") && lineString.contains("surname")))
                {
                    _nameIndex = column;
               //     qDebug()<<"Vorname: "<<column ;
                    Q_EMIT nameIndexChanged();
                }

                if(string.contains("nachname")  || (string.contains("name") && !string.contains("vorname") && lineString.toLower().contains("vorname")))
                {
                    _surnameIndex = column;
                //    qDebug()<<"Nachname: "<<column ;
                    Q_EMIT surnameIndexChanged();
                }


                if(string.contains("ablauf")  || string.contains("expiration")  || string.contains("datum") )
                {
                    _permissionExpirationIndex = column;
                //    qDebug()<<"Ablaufdatum: "<<column ;
                }

                if(string.contains("mail") )
                {
                    _mailIndex = column;
              //      qDebug()<<"eMail: "<<column ;
                    Q_EMIT mailIndexChanged();
                }

                if(string.contains("rolle")  || string.contains("role")  || string.contains("status") )
                {
                    _roleIndex = column;
              //      qDebug()<<"Rolle: "<<column ;
                    Q_EMIT roleIndexChanged();
                }

                if(string.contains("studiengang")  || string.contains("course") )
                {
                    _courseIndex = column;
              //      qDebug()<<"Studiengang: "<<column ;
                    Q_EMIT courseIndexChanged();
                }

                if(string.contains("gruppe")  || string.contains("group") )
                {
                    _groupIndex = column;
              //      qDebug()<<"Gruppen: "<<column ;
                    Q_EMIT groupIndexChanged();
                }

                column ++;
            }
        }


        QVariantMap user;

        QString eMail;
        QString cardID;

        if(_mailIndex >= 0 && _mailIndex < data.count())
            eMail = data[_mailIndex];

         eMail.remove("\r\n");
         QRegExp mailCheck("\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*");

         bool validMailAddress = mailCheck.exactMatch(eMail);

         if(!validMailAddress)
         {
            // qDebug()<<"invalid eMail Address: "<< eMail;
         }

         if(eMail.isEmpty() || !validMailAddress)
         {
             Log log;
             log.user = user;
             log.lineString = lineString;
             log.errorMsg = "Invalid eMail adress. Skipped line.";
             log.lineNumber = line;

             continue;
         }

         user["mail"] = eMail;

        if(_nameIndex >= 0 && _nameIndex < data.count())
            user["name"] = data[_nameIndex];
        if(_surnameIndex >= 0 && _surnameIndex < data.count())
            user["surname"] = data[_surnameIndex];

        if(_courseIndex >= 0 && _courseIndex < data.count())
            user["course"] = data[_courseIndex];
        else
            user["course"] = _course;

        if(_balanceIndex >= 0 && _balanceIndex < data.count())
        {
            QRegExp regexp("\\d+(?:(?:,|.)\\d\\d*)?");
            int pos = regexp.indexIn(data[_balanceIndex]);
            if(pos >= 0)
            {
                QString match =  regexp.capturedTexts().at(0);
                match = match.replace(",",".");
                int val = static_cast<int>(match.toDouble() * 100);
                user["balance"] = val;
            }
            else
            {
                user["balance"] = 0;
            }

        }
        else
            user["balance"] =  _balance;

        if(_roleIndex >= 0 && _roleIndex < data.count())
            user["role"] = data[_roleIndex];
        else
            user["role"] = _role;

        QVariantMap card;
        card["active"] = true;
        if(_cardIndex >= 0)
            cardID = data[_cardIndex];

        cardID.remove("\r\n");
        cardID = cardID.toUpper();

        if(!cardID.isEmpty())
        {
            if(cardID.count() > 14)
            {
                Log log;
                log.lineString = lineString;
                log.errorMsg = "Card ID has to many characters. Card ID resized.";
                log.user = user;
                _logs << log;
            }

            card["cardID"] = turnCardID(cardID);
       }
       else
       {
            card["cardID"] = "";
       }

        QDateTime expirationDate = QDateTime::currentDateTime();
        bool expires = false;
        if(_permissionExpirationIndex >= 0 && _permissionExpirationIndex < data.count())
        {
            QString expirationDateString = data[_permissionExpirationIndex];
            expirationDate = QDateTime::fromString(expirationDateString, "dd.MM.yy");
            expires = true;
            expirationDate = expirationDate.addYears(100);
        }
        else if (_expiration.isValid())
        {
            expires = true;
            expirationDate = _expiration;
        }



        QVariantMap permissions;
        if(_permissionIndex >= 0 && _permissionIndex < data.count())
        {
            QStringList permissionIDs = data[_permissionIndex].split(",");

            foreach(QString permissionID, permissionIDs)
            {
                permissionID = permissionID.simplified();
              //  qDebug()<<permissionID;
                QVariantMap permission;
                if(expires)
                  permission["expirationDate"] = expirationDate;

                permission["active"] = true;
                permission["expires"] = expires;
                permission["resourceID"] = permissionID;
                permissions[permissionID] = permission;
            }
        }

        QVariantMap groups;
        if(_groupIndex >= 0 && _groupIndex < data.count())
        {

            QStringList groupIDs = data[_groupIndex].split(",");
            foreach(QString groupID, groupIDs)
            {
                groupID = groupID.simplified();
                qDebug()<<groupID;
                QVariantMap group;
                if(expires)
                  group["expirationDate"] = expirationDate;

                group["active"] = true;
                group["expires"] = expires;
                group["groupID"] = groupID;
                groups[groupID] = group;
            }
        }
        else if(!_group.isEmpty())
        {
            QVariantMap group;
            if(expires)
              group["expirationDate"] = expirationDate;

            group["active"] = true;
            group["expires"] = expires;
            group["groupID"] = _group;
            groups[_group] = group;
        }

        QVariantMap item;
        item["permissions"]  = permissions;
        item["card"]         = card;
        item["user"]         = user;
        item["groups"]       = groups;
        _items << item;

        line++;
    }

    Q_EMIT finished();
    return true;
}

bool CSVReader::readURL(QString url)
{
    if(url.isEmpty())
    {
        url = _fileName;
    }

    QFile file(url);
    if(!file.open(QIODevice::ReadOnly))
        return false;

    _content = file.readAll();
    return read();
}


void CSVReader::downloadSampleCSV()
{
    QByteArray content;
    QFile file(":/Assets/2log_example.csv");
    if(file.open(QIODevice::ReadOnly))
    {
        content = file.readAll();
        qDebug()<<content;
        QFileDialog::saveFileContent(content, "2log_example.csv");
    }
    else
        qDebug()<<file.errorString();

}

void CSVReader::readFromDialog()
{

    auto fileOpenCompleted = [=](const QString &fileName, const QByteArray &fileContent) {
        if (fileName.isEmpty()) {
            // No file was selected
        }
        else
        {
            // Use fileName and fileContent
            if(!fileName.toLower().endsWith(".csv"))
            {
                Q_EMIT wrongFileFormat();
                return;
            }
            _content = fileContent;
            Q_EMIT fileLoaded();
            read();
        }
    };

    #ifndef Q_OS_ANDROID
    QFileDialog::getOpenFileContent("CSV Tables (*.csv)",  fileOpenCompleted);
    #endif
}

QVariantMap CSVReader::getIndex(int index)
{
    if(index >= 0 && _items.count() > index)
        return _items.at(index).toMap();

    return QVariantMap();
}

