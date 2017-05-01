#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <QVector>
#include <QLine>
#include <QPointF>
#include <QMap>
#include <unordered_set>

class GamePersistence;

namespace std
{
    template <>
    struct hash<QLine>
    {
        size_t operator()(QLine const & x) const noexcept
        {
            return (
               std::hash<int>()(x.p1().x()) * 51 * 51 * 51
             + std::hash<int>()(x.p1().y()) * 51 * 51
             + std::hash<int>()(x.p2().x()) * 51
             + std::hash<int>()(x.p2().y())
             + 51
            );
        }
    };
}

template<typename T>
struct Maybe
{
    Maybe() : has_value(false) {}
    Maybe(T value)
        : has_value(true), value(value) {}
    Maybe(bool has_value, T value)
        : has_value(has_value), value(value) {}
    const bool has_value;
    const T value;
};

enum class Player
{
    Red,
    Blue,
    None
};


class Game : public QObject
{
    Q_OBJECT
public:
    typedef QVector<Player> square_row;
    typedef QVector<square_row> square_container;
    typedef std::unordered_set<QLine> line_container;
private:
    int m_mapSize;
    Player m_currentPlayer;
    square_container m_squares;
    line_container m_lines;
    int m_uncoloredLines;
    int m_bluePoints;
    int m_redPoints;
    bool m_won;
    GamePersistence* persistence;
public:
    explicit Game(GamePersistence* pers, QObject *parent = 0);
    explicit Game(int mapSize, GamePersistence* pers, QObject *parent = 0);

    Maybe<QLine> highlightedLine(const QPointF& cursorPos) const;
    line_container lines() const;
    square_container squares() const;
    Player currentPlayer() const;
    int mapSize() const;
    bool won() const;

    void click(const QPointF& cursorPos);
    void save();

private:
    Player nextPlayer(Player player) const;
    QVector<QLine> squareEdges(const QPoint& ofSquare = QPoint(0, 0)) const;
    float linePointFDistance(const QLine& line, const QPointF& point) const;

    QVector<QPoint> nextTo(const QLine& line) const;
    bool surrounded(const QPoint& squareCoord) const;

    void stepPlayerPoint();

    void load();

signals:
    void redraw(const Game&);
    void win(const Player);
};

#endif // GAME_H
