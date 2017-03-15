#include "entity.h"

Entity::Entity(){
}

QPoint Entity::pos() const {
    return m_pos;
}

QPoint& Entity::rpos() {
    return m_pos;
}

void Entity::setPos(const QPoint& pos) {
    m_pos = pos;
}

void Entity::visit(EntityHandler& handler, const QTime& current_time) {
    handler.accept(*this, current_time);
}

Entity::~Entity() {
}
