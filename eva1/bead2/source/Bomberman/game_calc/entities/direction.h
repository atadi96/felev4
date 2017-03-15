#ifndef DIRECTION_H
#define DIRECTION_H

#include <QPoint>

class Direction
{
private:
    Direction() {}
public:
    static const QPoint None;
    static const QPoint Up;
    static const QPoint Down;
    static const QPoint Left;
    static const QPoint Right;
};

#endif // DIRECTION_H
