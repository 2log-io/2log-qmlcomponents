#include "LineChart.h"
#include <QPainter>

#ifdef MULTITHRADING
#include <QtConcurrent>
#endif

LineChart::LineChart(QQuickItem *parent) : QQuickPaintedItem(parent),
    _pen(_graphColor),
    _timer(new QTimer(this))
{
    _pen.setWidth(_thickness);
    this->setRenderTarget(QQuickPaintedItem::FramebufferObject);
    connect(_timer, &QTimer::timeout, this, &LineChart::timeout);
    setRepaintInterval(_repaintInteval);
}

void LineChart::addData(double value, QDateTime time, bool last)
{
    if(_points.isEmpty() || time.toMSecsSinceEpoch() > _endTime.toMSecsSinceEpoch())
        _endTime = time;


    if(_points.isEmpty() || time < _startTime)
        _startTime = time;

    DataValue point;
    point.value = value;
    point.time = time;

    _points.insert(time, point);

    setMin(qMin(_minVal, value));
    setMax(qMax(_maxVal, value));

    if(last)
    {
        render();
    }
}


void LineChart::addData(double value)
{
    if(_points.isEmpty())
        _startTime = QDateTime::currentDateTime();

    _endTime = QDateTime::currentDateTime();

    DataValue point;
    point.value = value;
    _points.insert(_endTime, point);

    setMin(qMin(_minVal, value));
    setMax(qMax(_maxVal, value));
    render();
}

double LineChart::getValueForY(int yPos) const
{
    double range = _maxVal - _minVal;
    double invertedY = this->height() - yPos;
    return (invertedY / this->height()) * range;
}

void LineChart::paint(QPainter *painter)
{
   painter->setPen(_pen);
#ifdef MULTITHRADING
    _lock.lockForRead();
    QPainterPath path = _path;
    _lock.unlock();
    painter->drawPath(path);
#else
   painter->drawPath(_path);
#endif
}

QColor LineChart::getGraphColor() const
{
    return _graphColor;
}

void LineChart::setGraphColor(const QColor &value)
{
    if(_graphColor != _graphColor)
        return;

    _graphColor = value;
    _pen.setColor(_graphColor);
    render();
    Q_EMIT graphColorChanged();
}

int LineChart::getThickness() const
{
    return _thickness;
}

void LineChart::setThickness(int thickness)
{
    _thickness = thickness;
    _pen.setWidth(_thickness);
    render();
}

double LineChart::getMax() const
{
    return _maxVal;
}

double LineChart::getMin() const
{
    return _minVal;
}

void LineChart::setMax(double max)
{
    if (qAbs(_maxVal - max)  < 0.0001)
        return;

    _maxVal = max;
    Q_EMIT maxChanged();
}

void LineChart::setMin(double min)
{
    if (qAbs(_minVal - min)  < 0.0001)

    _minVal = min;
    Q_EMIT minChanged();
}

int LineChart::repaintInterval() const
{
    return _repaintInteval;
}

void LineChart::setRepaintInterval(int repaintInteval)
{
    _repaintInteval = repaintInteval;
    if(repaintInteval <= 0)
    {
        _timer->stop();
        return;
    }

    _timer->setInterval(repaintInteval);
//    _timer->start();
}

void LineChart::render()
{
    if(_points.count() <= 1 )
        return;
#ifdef MULTITHRADING
    QtConcurrent::run(this, &LineChart::makePath);
#else
    makePath();
#endif
    update();
}

QPainterPath LineChart::makePath()
{
    QPainterPath path;

    path.moveTo(QPointF(this->width(), getYForValue(_points.last().value)));
    path.lineTo(getPointFor(_points.last()));

    QList<DataValue> points = _points.values();
    QList<DataValue>::iterator i;

    for (i = points.end()-1; i != points.begin(); --i)
    {
        // graph is painted from newest to latest...

        QPointF b(getXForValue((*i).time), getYForValue((*(i-1)).value));
        QPointF a(getXForValue((*i).time), getYForValue((*i).value));
        path.lineTo(a);
        path.lineTo(b);
    }

    //_lock.lockForWrite();
    _path = path;
    //_lock.unlock();
    return path;
}

void LineChart::timeout()
{
    _endTime = QDateTime::currentDateTime();
    render();
}

QPointF LineChart::getPointFor(LineChart::DataValue &value) const
{
    return QPointF(getXForValue(value.time), getYForValue(value.value));
}

double LineChart::getYForValue(double value) const
{
    double height = this->height() - (_thickness);
    double valRange = _maxVal - _minVal;
    return (float) (_thickness)/2 + (height - ((height / valRange) * (value-_minVal)));
}

void LineChart::clear()
{
    _points.clear();
    _startTime = QDateTime();
    _endTime = QDateTime();
    render();
}

double LineChart::getXForValue(QDateTime value) const
{
    int delta = static_cast<int> (value.toMSecsSinceEpoch() - _startTime.toMSecsSinceEpoch());

    double pixelPerMilliSeconds = this->width() / (_endTime.toMSecsSinceEpoch() - _startTime.toMSecsSinceEpoch());
    double val = ((double) (delta)) *  pixelPerMilliSeconds;
    return val;
}
