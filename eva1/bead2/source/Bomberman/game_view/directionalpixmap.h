#ifndef DIRECTIONALPIXMAP_H
#define DIRECTIONALPIXMAP_H

#include <QPixmap>

class DirectionalPixmap
{
private:
    QPixmap* m_sprite_sheet;
public:
    DirectionalPixmap(QPixmap* spriteSheet);
    QRect sourceRectForDirection(const QPoint& direction);
};

#endif // DIRECTIONALPIXMAP_H
