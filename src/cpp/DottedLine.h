#ifndef DOTTEDLINE_H
#define DOTTEDLINE_H

#include <QObject>
#include <QQuickPaintedItem>

class DottedLine : public QQuickPaintedItem
{

    Q_OBJECT

    Q_PROPERTY(int dotSize READ dotSize WRITE setDotSize NOTIFY dotSizeChanged)
    Q_PROPERTY(int dotSpacing READ dotSpacing WRITE setDotSpacing NOTIFY dotSpacingChanged)
    Q_PROPERTY(QColor dotColor READ dotColor WRITE setDotColor NOTIFY dotColorChanged)
    Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation NOTIFY orientationChanged)


public:
    DottedLine(QQuickItem* parent = 0);
    void paint(QPainter *painter);

    QColor dotColor() const;
    void setDotColor(const QColor &dotColor);

    int dotSize() const;
    void setDotSize(int dotSize);

    int dotSpacing() const;
    void setDotSpacing(int dotSpacing);

    Qt::Orientation orientation() const;
    void setOrientation(const Qt::Orientation &orientation);

private:
    QColor          _dotColor;
    int             _dotSize;
    int             _dotSpacing;
    Qt::Orientation _orientation = Qt::Horizontal;

signals:
    void dotColorChanged();
    void dotSpacingChanged();
    void dotSizeChanged();
    void orientationChanged();

};

#endif // DOTTEDLINE_H
