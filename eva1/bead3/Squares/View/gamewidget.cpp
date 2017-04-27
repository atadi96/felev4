#include "gamewidget.h"

GameWidget::GameWidget(QWidget *parent)
    : QWidget(parent), m_game(m_mapSize)
{
    setMouseTracking(true);
    QSizePolicy policy(QSizePolicy::Fixed, QSizePolicy::Fixed);
    policy.setHeightForWidth(true);
    setSizePolicy(policy);
}

QSize GameWidget::sizeHint() const {
    return QSize(
        m_unit * (m_mapSize - 1) + m_brushWidth,
        m_unit * (m_mapSize - 1) + m_brushWidth
    );
}

void GameWidget::paintEvent(QPaintEvent* ) {
    m_painter.begin(this);
    //paint background
    m_painter.setBackground(QBrush(Qt::white));
    m_painter.eraseRect(QRect(QPoint(0,0), this->size()));
    //paint squares
    for(int x = 0; x < m_mapSize; ++x) {
        for(int y = 0; y < m_mapSize; ++y) {
            drawSquare(QPoint(x, y), m_game.squares()[x][y]);
        }
    }
    //paint dots
    for(int y = 0; y < m_mapSize; ++y) {
        for(int x = 0; x < m_mapSize; ++x) {
            drawPoint(QPoint(x, y));
        }
    }
    //paint lines
    for(auto line : m_game.lines()) {
        drawLine(line);
    }
    //paint line under mouse
    Maybe<QLine> line = m_game.highlightedLine(globalToCoord(QCursor::pos()));
    if(line.has_value) {
        drawLine(line.value, m_game.currentPlayer());
    }
    m_painter.end();
}

void GameWidget::mouseMoveEvent(QMouseEvent*) {
    update();
}

void GameWidget::mousePressEvent(QMouseEvent*) {
    m_game.click(globalToCoord(QCursor::pos()));
    update();
}

QLine GameWidget::toWorld(const QLine& line) const {
    QLine result(line.p1() * m_unit, line.p2() * m_unit);
    result.translate(m_brushWidth / 2, m_brushWidth / 2);
    return result;
}

QRect GameWidget::toWorld(const QPoint& coord) const {
    return QRect(
        worldPoint(coord.x(), coord.y()),
        QSize(m_unit, m_unit)
    );
}

QPointF GameWidget::globalToCoord(const QPoint& global) const {
    QPointF result(mapFromGlobal(global));
    result.rx() /= m_unit;
    result.ry() /= m_unit;
    return result;
}

QPoint GameWidget::worldPoint(const QPoint& coords) const {
    return worldPoint(coords.x(), coords.y());
}

QPoint GameWidget::worldPoint(int x, int y) const {
    return QPoint(
        x * m_unit + m_brushWidth / 2,
        y * m_unit + m_brushWidth / 2
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
    default:
        throw 42;
    }
}

void GameWidget::drawPoint(const QPoint& coords) {
    m_painter.save();
    m_painter.setBrush(QBrush(Qt::black));
    m_painter.drawEllipse(worldPoint(coords), m_brushWidth / 2, m_brushWidth / 2);
    m_painter.restore();
}

void GameWidget::drawSquare(const QPoint& coords, Player player) {
    if(player == Player::None) {
        return;
    }
    m_painter.save();
    m_painter.setBrush(QBrush(toColor(player)));
    m_painter.drawRect(toWorld(coords));
    m_painter.restore();
}

void GameWidget::drawLine(const QLine& line, Player player) {
    m_painter.save();
    m_painter.setBrush(QBrush(toColor(player)));
    m_painter.setPen(QPen(
        QBrush(toColor(player)),
        m_brushWidth
    ));
    m_painter.drawLine(toWorld(line));
    m_painter.restore();
}
