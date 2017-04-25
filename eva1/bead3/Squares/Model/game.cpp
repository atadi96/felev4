#include "game.h"
#include <math.h>

Game::Game(QObject *parent, int mapSize)
    : QObject(parent), m_mapSize(mapSize), m_currentPlayer(Player::Blue)
{

}

Maybe<QLine> Game::highlightedLine(const QPointF& cursorPos) const {
    QPoint square(
        (int)floor(cursorPos.x()),
        (int)floor(cursorPos.y())
    );
    QPointF inSquare(
        cursorPos.x() - square.x(),
        cursorPos.y() - square.y()
    );
    QVector<QLine> squareEdges = squareEdges();
    auto it = squareEdges.begin();
    QLine nearestLine = *it;
    float minDist = linePointFDistance(*it, inSquare);
    for(; it != squareEdges.end(); ++it) {
        float newMinDist = linePointFDistance(*it, inSquare);
        if(newMinDist < minDist) {
            minDist = newMinDist;
            nearestLine = *it;
        }
    }
    nearestLine.translate(square);
    return Maybe<QLine>(
        m_lines.find(nearestLine) != m_lines.end(),
        nearestLine
    );
}

Game::line_container Game::lines() const {
    return m_lines;
}

Game::square_container Game::squares() const {
    return m_squares;
}

void Game::click(const QPointF& cursorPos) {
    Maybe<QLine> clicked = highlightedLine(cursorPos);
    if(clicked.has_value) {
        m_lines.insert(clicked.value);
    }
    m_currentPlayer = nextPlayer(m_currentPlayer);
    emit redraw(*this);
}

Player Game::nextPlayer(Player player) const {
    if(player == Player::Blue) {
        return Player::Red;
    } else if(player == Player::Red) {
        return Player::Blue;
    } else {
        return Player::None;
    }
}

QVector<QLine> Game::squareEdges() const {
    QVector<QLine> result;
    result.push_back(QLine(0, 0, 1, 0));
    result.push_back(QLine(0, 0, 0, 1));
    result.push_back(QLine(1, 0, 1, 1));
    result.push_back(QLine(0, 1, 1, 1));
    return result;
}

float Game::linePointFDistance(const QLine& line, const QPointF& point) {
    return sqrt(
        pow((line.center().x() - point.x()), 2) +
        pow((line.center().y() - point.y()), 2)
    );
}
