#ifndef GAMEWIDGET_H
#define GAMEWIDGET_H

#include <QWidget>
#include <QPainter>
#include <QRect>
#include <QLine>
#include <QColor>

#include "Model/game.h"
#include "Persistence/filepersistence.h"

class GameWidget : public QWidget
{
    Q_OBJECT
private:
    QPainter m_painter;

    int m_mapSize;
    int m_brushWidth = 4;
    int m_unit = 64;

    FilePersistence* filePersistence;

    Game m_game;

public:
    explicit GameWidget(int mapSize, QWidget *parent = 0);
    explicit GameWidget(QWidget *parent = 0);
    QSize sizeHint() const override;
    void save();

protected:
    void paintEvent(QPaintEvent* );
    void mouseMoveEvent(QMouseEvent*);
    void mousePressEvent(QMouseEvent*);

private:
    QLine toWorld(const QLine&) const;
    QRect toWorld(const QPoint&) const;
    QPoint worldPoint(int x, int y) const;
    QPoint worldPoint(const QPoint&) const;
    QColor toColor(Player) const;
    QPointF globalToCoord(const QPoint& global) const;

    void drawPoint(const QPoint& coords);
    void drawSquare(const QPoint& coords, Player player);
    void drawLine(const QLine& line, Player player = Player::None);
private slots:
    void win(Player player);
    void redraw(const Game&);

};

#endif // GAMEWIDGET_H
