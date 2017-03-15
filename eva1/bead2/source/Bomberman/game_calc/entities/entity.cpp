#include "entity.h"

Entity::Entity(){
}

Entity::Entity(QPoint pos){
    m_pos = pos;
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

void Entity::visit(EntityHandler& handler, const qint64 current_time) {
    handler.accept(*this, current_time);
}

Entity::~Entity() {
}
