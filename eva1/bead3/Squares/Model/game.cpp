#include "game.h"
#include <math.h>
#include <QRect>

Game::Game(int mapSize, GamePersistence*, QObject *parent)
    : QObject(parent), m_mapSize(mapSize), m_currentPlayer(Player::Blue)
{
    m_uncoloredLines = 2 * m_mapSize * (m_mapSize) - 1;
    m_bluePoints = 0;
    m_redPoints = 0;
    m_won = false;
    square_row row;
    row.fill(Player::None, m_mapSize);
    m_squares.fill(row, m_mapSize);
}

Maybe<QLine> Game::highlightedLine(const QPointF& mapPos) const {
    QPoint square(
        (int)floor(mapPos.x()),
        (int)floor(mapPos.y())
    );
    QPointF inSquare(
        mapPos.x() - square.x(),
        mapPos.y() - square.y()
    );
    QVector<QLine> edges = squareEdges();
    auto it = edges.begin();
    QLine nearestLine = *it;
    float minDist = linePointFDistance(*it, inSquare);
    for(; it != edges.end(); ++it) {
        float newMinDist = linePointFDistance(*it, inSquare);
        if(newMinDist < minDist) {
            minDist = newMinDist;
            nearestLine = *it;
        }
    }
    nearestLine.translate(square);
    const QRect map(0, 0, m_mapSize, m_mapSize);
    if(!map.contains(nearestLine.p1()) || !map.contains(nearestLine.p2())) {
        return Maybe<QLine>();
    }
    return Maybe<QLine>(
        m_lines.find(nearestLine) == m_lines.end(),
        nearestLine
    );
}

Game::line_container Game::lines() const {
    return m_lines;
}

Game::square_container Game::squares() const {
    return m_squares;
}

Player Game::currentPlayer() const {
    return m_currentPlayer;
}

void Game::click(const QPointF& mapPos) {
    if(m_won) { return; }
    Maybe<QLine> clicked = highlightedLine(mapPos);
    if(clicked.has_value) {
        --m_uncoloredLines;
        const QLine& line = clicked.value;
        m_lines.insert(line);
        QVector<QPoint> neighbors = nextTo(line);
        bool newScore = false;
        for(auto p : neighbors) {
            if(m_squares[p.x()][p.y()] == Player::None && surrounded(p)) {
                newScore = true;
                stepPlayerPoint();
                m_squares[p.x()][p.y()] = m_currentPlayer;
            }
        }
        m_won = (m_uncoloredLines == 0);
        if(!m_won && !newScore) {
            m_currentPlayer = nextPlayer(m_currentPlayer);
        }
    }
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

QVector<QLine> Game::squareEdges(const QPoint& ofSquare) const {
    QVector<QLine> result;
    result.push_back(QLine(0, 0, 1, 0).translated(ofSquare));
    result.push_back(QLine(0, 0, 0, 1).translated(ofSquare));
    result.push_back(QLine(1, 0, 1, 1).translated(ofSquare));
    result.push_back(QLine(0, 1, 1, 1).translated(ofSquare));
    return result;
}

float Game::linePointFDistance(const QLine& line, const QPointF& point) const { //wikipedia
    float x1 = line.p1().x();
    float y1 = line.p1().y();
    float x2 = line.p2().x();
    float y2 = line.p2().y();
    const float& x0 = point.x();
    const float& y0 = point.y();
    return
        fabs(
            (y2 - y1) * x0 - (x2 - x1) * y0 + x2*y1 - y2*x1
        ) / sqrt(
            pow(y2 - y1, 2) +
            pow(x2 - x1, 2)
        );
}

QVector<QPoint> Game::nextTo(const QLine& line) const { //le van vezetve papíron
    const QPoint translation(
        std::min(line.p1().x(), line.p2().x()),
        std::min(line.p1().y(), line.p2().y())
    );
    QLine dir = line.translated( - translation);
    const QPoint one(0,0);
    const QPoint other(
        1 - std::max(dir.p1().x(), dir.p2().x()),
        1 - std::max(dir.p1().y(), dir.p2().y())
    );
    const QRect map(0, 0, m_mapSize, m_mapSize);
    QVector<QPoint> result;
    if(map.contains(translation + one)) {
        result.push_back(translation + one);
    }
    if(map.contains(translation - other)) {
        result.push_back(translation - other);
    }
    return result;
}
bool Game::surrounded(const QPoint& squareCoord) const {
    QVector<QLine> edges = squareEdges(squareCoord);
    bool result = true;
    for(auto edge : edges) {
        result = result && (m_lines.find(edge) != m_lines.end());
    }
    return result;
}

void Game::stepPlayerPoint() {
    if(m_currentPlayer == Player::Blue) {
        ++m_bluePoints;
    } else if(m_currentPlayer == Player::Red) {
        ++m_redPoints;
    }
}
