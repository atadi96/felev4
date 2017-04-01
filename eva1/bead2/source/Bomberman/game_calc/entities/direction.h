#ifndef DIRECTION_H
#define DIRECTION_H

#include <QPoint>
#include <random>

class Direction
{
private:
    Direction() {}
    static std::mt19937 randEngine;
    static std::uniform_int_distribution<int> dist;
public:
    static const QPoint None;
    static const QPoint Up;
    static const QPoint Down;
    static const QPoint Left;
    static const QPoint Right;
    static QPoint getRandom();
};

#endif // DIRECTION_H
