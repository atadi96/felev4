#ifndef MOVINGENTITY_H
#define MOVINGENTITY_H

#include <QPointF>
#include <QRectF>
#include "entity.h"
#include "direction.h"

class MovingEntity : public Entity
{
private:
    float m_speed; // tiles/second
    bool m_moving;
    float m_interpolation;
    qint64 m_start_time;
    QPoint m_direction;
public:
    MovingEntity(QPoint pos, float speed);
    float speed() const;
    virtual void visit(EntityHandler& handler, const qint64 current_time) override;
    void move(const QPoint& direction, const qint64 current_time);
    void face(const QPoint& direction);
    bool is_moving() const;
    QRectF hitbox() const;
    const QPoint& direction() const;
};

#endif // MOVINGENTITY_H
