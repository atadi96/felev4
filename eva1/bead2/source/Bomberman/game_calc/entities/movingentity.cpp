#include "movingentity.h"
#include <math.h>

MovingEntity::MovingEntity(QPoint pos, float speed) : m_pos(pos), m_speed(speed), m_moving(false), m_direction(Direction::None) {
}

float MovingEntity::speed() const {
    return m_speed;
}
void MovingEntity::visit(EntityHandler& handler, const QTime& current_time) {
    if(m_moving) {
        QTime end_time = m_start_time;
        end_time.addMSecs(round(1000 / m_speed));
        if(current_time.msecsTo(end_time) <= 0) {
            m_interpolation = 0;
            m_pos += m_direction;
            m_direction = Direction::None;
            m_moving = false;
        } else {
            m_interpolation = m_speed * m_start_time.msecsTo(end_time) / 1000.0;
        }
    }

    handler.accept(*this, current_time);
}

QRectF MovingEntity::hitbox() const {
    return QRectF(
        QPointF(m_pos) + m_interpolation * QPointF(m_direction),
        QSize(1, 1)
    );
}
const QPoint& MovingEntity::direction() const {
    return m_direction;
}

void MovingEntity::move(const QPoint& direction, const QTime& current_time) {
    if(m_moving) return;
    m_interpolation = 0;
    m_direction = direction;
    m_start_time = current_time;
    m_moving = true;
}

void MovingEntity::face(const QPoint& direction) {
    if(!m_moving) {
        m_direction = direction;
    }
}

bool MovingEntity::is_moving() const {
    return m_moving;
}
