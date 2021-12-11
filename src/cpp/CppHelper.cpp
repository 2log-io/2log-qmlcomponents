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

#include "CppHelper.h"
#include <QEvent>
#include <QKeyEvent>
#include <QDebug>
#include <QDesktopServices>
#include <QDateTime>
#include <QUuid>

CppHelper::CppHelper(QObject *parent) : QObject(parent)
{

}

void CppHelper::openUrl(QString url)
{
    QDesktopServices::openUrl(url);
}

QVariantMap CppHelper::today()
{
    QVariantMap result;
    QDateTime to = QDateTime::currentDateTime();
  //  to = to.addDays(-30);
    result["to"]  = to;
    to.setTime(QTime());
    result["from"]  = to.date().startOfDay();
    qDebug()<<result;
    return result;
}

QVariantMap CppHelper::yesterday()
{

    QVariantMap result;
    QDateTime to = QDateTime::currentDateTime();
    to = to.addDays(-1);
    result["to"]  = to.date().endOfDay();
    result["from"]  = to.date().startOfDay();
    qDebug()<<result;
    return result;
}

QVariantMap CppHelper::thisWeek()
{
    QVariantMap result;
    QDateTime to = QDateTime::currentDateTime();
  //  to = to.addDays(-30);
    result["to"]  = to;
    QDateTime fromDate = to.addDays(-1 * to.date().dayOfWeek() + 1);
    fromDate = fromDate.date().startOfDay();
    result["from"]  = fromDate;
    qDebug()<<result;
    return result;
}

QVariantMap CppHelper::thisMonth()
{
    QVariantMap result;
    QDateTime to = QDateTime::currentDateTime();
   // to = to.addDays(-30);
    result["to"]  = to;
    QDateTime fromDate = to.addDays(-1 * to.date().day() + 1);
    fromDate = fromDate.date().startOfDay();
    result["from"]  = fromDate;
    qDebug()<<result;
    return result;
}

QVariantMap CppHelper::lastMonth()
{
    QVariantMap result;
    QDateTime to = QDateTime::currentDateTime();
    QDateTime from = to.addDays(-28);
    result["to"]  = to;
    result["from"]  = from;
    qDebug()<<result;
    return result;
}

QDateTime CppHelper::toDate(QVariant obj)
{
    return QDateTime::fromMSecsSinceEpoch(obj.toMap()["$date"].toLongLong());
}


QString CppHelper::createUUID() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}


QString CppHelper::createShortID() const
{
   const QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
   const int randomStringLength = 4; // assuming you want random strings of 12 characters

   QString randomString;
   for(int i=0; i<randomStringLength; ++i)
   {
       int index = qrand() % possibleCharacters.length();
       QChar nextChar = possibleCharacters.at(index);
       randomString.append(nextChar);
   }
   return randomString;
}

bool CppHelper::eventFilter(QObject *obj, QEvent *event)
{
    Q_UNUSED(obj)
    if(event->type() == QEvent::KeyRelease)
    {
        QKeyEvent* ev = static_cast<QKeyEvent*>(event);
        if(ev->key() == Qt::Key_Back)
        {
            qDebug()<<"BACK";
            Q_EMIT back();
            return true;
        }
    }
    return false;
}
