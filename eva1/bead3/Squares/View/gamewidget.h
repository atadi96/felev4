#ifndef GAMEWIDGET_H
#define GAMEWIDGET_H

#include <QWidget>
#include <QPainter>
#include <QRect>
#include <QLine>
#include <QColor>

#include "Model/game.h"

class GameWidget : public QWidget
{
    Q_OBJECT
private:
    QPainter m_painter;

    int m_mapSize = 9;
    int m_brushWidth = 3;
    int m_unit = 16;

public:
    explicit GameWidget(QWidget *parent = 0);

protected:
    void paintEvent(QPaintEvent* );

private:
    QLine toWorld(const QLine&) const;
    QRect toWorld(const QPoint&) const;
    QPoint worldPoint(int x, int y) const;
    QColor toColor(Player) const;

public slots:

};

#endif // GAMEWIDGET_H
