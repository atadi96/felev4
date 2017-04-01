#include "bombentity.h"

BombEntity::BombEntity(const QPoint& pos, qint64 fuseTime) : Entity(pos) {
    m_fuse_time = fuseTime * 1000;
    m_activated_time = 0;
    m_detonated = false;
    m_activated = false;
}

void BombEntity::activate(qint64 current_time) {
   m_activated_time = current_time;
   m_activated = true;
   m_detonated = false;
}

void BombEntity::update(qint64 current_time) {
    m_detonated = m_activated && (current_time >= m_activated_time + m_fuse_time);
}
void BombEntity::visit(EntityHandler& handler, qint64 current_time) {
    handler.accept(*this, current_time);
}
bool BombEntity::detonated() const {
    return m_detonated;
}
