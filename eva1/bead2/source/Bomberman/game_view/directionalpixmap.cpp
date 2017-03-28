#include "directionalpixmap.h"
#include "game_calc/entities/direction.h"

DirectionalPixmap::DirectionalPixmap(QPixmap* spriteSheet) : m_sprite_sheet(spriteSheet) {
}

QRect DirectionalPixmap::sourceRectForDirection(const QPoint& direction) {
    QRect first(0, 0, m_sprite_sheet->size().width() / 4, m_sprite_sheet->size().height());
    int offset;
    if (direction == Direction::Up) {
        offset = 0;
    } else if (direction == Direction::Left) {
        offset = 1;
    } else if (direction == Direction::Down) {
        offset = 2;
    } else if (direction == Direction::Right) {
        offset = 3;
    } else {
        offset = 2;
    }
    return QRect(
        offset * m_sprite_sheet->size().width() / 4,
        0,
        m_sprite_sheet->size().width() / 4,
        m_sprite_sheet->size().height()
    );
}
