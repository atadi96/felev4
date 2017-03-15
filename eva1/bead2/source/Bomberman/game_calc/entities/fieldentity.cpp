#include "fieldentity.h"

FieldEntity::FieldEntity() {}

FieldEntity::FieldEntity(FieldType type) : type(type) {

}

void FieldEntity::visit(EntityHandler& handler, const qint64 current_time) {
    handler.accept(*this, current_time);
}
