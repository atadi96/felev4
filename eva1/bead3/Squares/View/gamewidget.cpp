#include "gamewidget.h"

GameWidget::GameWidget(QWidget *parent) : QWidget(parent)
{

}

void GameWidget::paintEvent(QPaintEvent* ) {
    m_painter.begin(this);
    //paint background
    //paint squares
    //paint lines
    //paint line under mouse
    m_painter.end();
}

QLine GameWidget::toWorld(const QLine& line) const {
    line *= m_unit;
    line.translate(m_brushWidth / 2, m_brushWidth / 2);
}
QRect GameWidget::toWorld(const QPoint& coord) const {
    return QRect(
        worldPoint(coord.x(), coord.y()),
        QSize(m_unit, m_unit)
    );
}

QPoint GameWidget::worldPoint(int x, int y) const {
    return QPoint(
        x * m_unit + m_brushWidth / 2,
        y * m_unit + m_brushWidth / 2,
    );
}

QColor GameWidget::toColor(Player player) const {
    switch(player) {
    case Player::Blue:
        return Qt::blue;
    case Player::Red:
        return Qt::red;
    case Player::None:
        return Qt::black;
    }
}
