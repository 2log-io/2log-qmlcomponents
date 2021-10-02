#ifndef LINECHART_H
#define LINECHART_H

#include <QQuickPaintedItem>
#include <QDateTime>
#include <QTimer>
#include <QPainterPath>
#include <QPen>

#ifdef MULTITHRADING
#include <QReadWriteLock>
#endif

class LineChart : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor lineColor READ getGraphColor WRITE setGraphColor NOTIFY graphColorChanged)
    Q_PROPERTY(float lineThickness READ getThickness WRITE setThickness NOTIFY thicknessChanged)
    Q_PROPERTY (int repaintInterval READ repaintInterval WRITE setRepaintInterval NOTIFY repaintIntervalChanged)
    Q_PROPERTY(double maxVal READ getMax WRITE setMax NOTIFY maxChanged)
    Q_PROPERTY(double minVal READ getMin WRITE setMin NOTIFY minChanged)

    struct DataValue
    {
        double value;
        QDateTime time = QDateTime::currentDateTime();
    };

public:
    Q_INVOKABLE void    addData(double value);
    Q_INVOKABLE void    addData(double value, QDateTime time, bool last = true);
    Q_INVOKABLE double  getValueForY(int yPos) const;
    Q_INVOKABLE double  getYForValue(double value) const;
    Q_INVOKABLE void    clear();


    QPointF             getPointFor(DataValue& value) const;
    double              getXForValue(QDateTime value) const;

    void paint(QPainter *painter) override;
    LineChart(QQuickItem* parent = nullptr);

    QColor  getGraphColor() const;
    void    setGraphColor(const QColor &value);

    int     getThickness() const;
    void    setThickness(int thickness);

    double  getMax() const;
    double  getMin() const;

    void    setMax(double max);
    void    setMin(double min);

    int     repaintInterval() const;
    void    setRepaintInterval(int repaintInteval);

private:
    void                render();
    QPainterPath        makePath();
    QPen                _pen;
    QPainterPath        _path;
    QColor              _graphColor;
    QDateTime           _startTime;
    QDateTime           _endTime;
    QMap<QDateTime,DataValue>    _points;
    int                 _pixelPerSeconds = 20;
    int                 _thickness = 2;
    bool                _maxSet;
    bool                _minSet;
    QTimer*              _timer = nullptr;
    double              _maxVal = 0;
    double              _minVal = 0;
    QTimer              _chartTimer;
    int                 _repaintInteval = 200;

    #ifdef MULTITHRADING
    QReadWriteLock      _lock;
    #endif

private slots:
    void timeout();

signals:
    void graphColorChanged();
    void thicknessChanged();
    void maxChanged();
    void minChanged();
    void repaintIntervalChanged();

};

#endif // LINECHART_H
