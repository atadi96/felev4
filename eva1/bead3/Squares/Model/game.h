#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <QVector>
#include <QLine>
#include <QPointF>
#include <QMap>
#include <unordered_set>

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
    typedef QVector<QVector<Player>> square_container;
    typedef std::unordered_set<QLine> line_container;
private:
    int m_mapSize;
    Player m_currentPlayer;
    square_container m_squares;
    line_container m_lines;
public:
    explicit Game(QObject *parent = 0, int mapSize);

    Maybe<QLine> highlightedLine(const QPointF& cursorPos) const;
    line_container lines() const;
    square_container squares() const;

    void click(const QPointF& cursorPos);

private:
    Player nextPlayer(Player player) const;
    QVector squareEdges() const;
    float linePointFDistance(const QLine& line, const QPointF& point);

signals:
    void redraw(const Game&);
};

#endif // GAME_H
