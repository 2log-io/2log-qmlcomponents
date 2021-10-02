#include "DottedLine.h"
#include <QPainter>
#include <cmath>
#include <QDebug>

DottedLine::DottedLine(QQuickItem* parent) : QQuickPaintedItem(parent)
{

}

void DottedLine::paint(QPainter *painter)
{
     QPen pen;
     QVector<qreal> dashes;
     pen.setWidth(_dotSize);
     pen.setCapStyle(Qt::FlatCap);
     dashes << _dotSize << _dotSpacing;
     pen.setDashPattern(dashes);
     pen.setColor(_dotColor);
     painter->setPen(pen);

     QPointF p1, p2;
     if(_orientation == Qt::Horizontal)
     {
         int y = this->height() / 2;
         p1 = QPointF(0, y);
         p2 = QPointF((int)this->width(), y);
     }
     else
     {
         int x = this->width() / 2;
         p1 = QPointF(x, 0);
         p2 = QPointF(x, (int)this->height());
     }

     painter->drawLine(p1,p2);
}

QColor DottedLine::dotColor() const
{
    return _dotColor;
}

void DottedLine::setDotColor(const QColor &dotColor)
{
    if(_dotColor == dotColor)
        return;

    _dotColor = dotColor;
    update();
    Q_EMIT dotColorChanged();
}

int DottedLine::dotSize() const
{
    return _dotSize;
}

void DottedLine::setDotSize(int dotSize)
{
    if(_dotSize == dotSize)
        return;
    _dotSize = dotSize;
    update();
    Q_EMIT dotSizeChanged();
}

int DottedLine::dotSpacing() const
{
    return _dotSpacing;
}

void DottedLine::setDotSpacing(int dotSpacing)
{
    if(_dotSpacing == dotSpacing)
        return;

    _dotSpacing = dotSpacing;
    update();
    Q_EMIT dotSpacingChanged();
}

Qt::Orientation DottedLine::orientation() const
{
    return _orientation;
}

void DottedLine::setOrientation(const Qt::Orientation &orientation)
{
    if(_orientation == orientation)
        return;

    _orientation = orientation;
    Q_EMIT orientationChanged();
}
