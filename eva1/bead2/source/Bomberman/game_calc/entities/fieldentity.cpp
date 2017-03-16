#include "fieldentity.h"

FieldEntity::FieldEntity() {
    m_name = "FieldEntity";
}

FieldEntity::FieldEntity(FieldType type) : type(type) {
    m_name = "FieldEntity";
}

void FieldEntity::visit(EntityHandler& handler, const qint64 current_time) {
    handler.accept(*this, current_time);
}
