#ifndef INITAPPCOMPONENTS_H
#define INITAPPCOMPONENTS_H

#include <QQmlApplicationEngine>
#include "LineChart.h"
#include "DottedLine.h"
#include "CSVReader.h"

namespace Init2logQMLComponents
{

    void registerTypes(const char *uri, QQmlApplicationEngine* engine = nullptr)
    {
        qmlRegisterType<LineChart>(uri, 1, 0, "LineChart");
        qmlRegisterType<DottedLine>(uri, 1, 0, "DottedLine");
        qmlRegisterType<CSVReader>(uri, 1, 0, "CSVReader");

        if(engine)
            engine->addImportPath(":/");
    }

};
#endif // INITAPPCOMPONENTS_H
