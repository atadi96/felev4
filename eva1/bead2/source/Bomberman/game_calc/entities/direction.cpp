#include "direction.h"

const QPoint Direction::None = QPoint(0, 0);
const QPoint Direction::Up = QPoint(0, -1);
const QPoint Direction::Down = QPoint(0, 1);
const QPoint Direction::Left = QPoint(-1, 0);
const QPoint Direction::Right = QPoint(1, 0);

std::mt19937 Direction::randEngine(time(nullptr));
std::uniform_int_distribution<int> Direction::dist(0, 3);

QPoint Direction::getRandom() {
    int num = dist(randEngine);
    switch(num) {
    case 0:
        return Direction::Up;
        break;
    case 1:
        return Direction::Down;
        break;
    case 2:
        return Direction::Left;
        break;
    case 3:
        return Direction::Right;
        break;
    default:
        return Direction::None;
        break;
    }
}
