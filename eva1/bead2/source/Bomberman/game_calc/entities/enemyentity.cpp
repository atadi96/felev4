#include "enemyentity.h"

EnemyEntity::EnemyEntity(const QPoint& pos) : MovingEntity(pos, 1.5) {
}

void EnemyEntity::visit(EntityHandler& handler, const qint64 current_time) {
    handler.accept(*this, current_time);
}

void EnemyEntity::update(qint64 current_time) {
    MovingEntity::update(current_time);
}

const QPoint& EnemyEntity::desiredDirection() const {
    return m_desired_direction;
}
void EnemyEntity::setDesiredDirection(const QPoint& dir) {
    m_desired_direction = dir;
}
