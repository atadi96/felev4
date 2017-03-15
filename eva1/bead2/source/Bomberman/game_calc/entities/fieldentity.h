#ifndef FIELDENTITY_H
#define FIELDENTITY_H

#include "entity.h"

enum class FieldType
{
    Ground,
    Wall
};

class FieldEntity : public Entity
{
public:
    FieldType type = FieldType::Ground;
    FieldEntity();
    FieldEntity(FieldType type);
    virtual void visit(EntityHandler& handler, const qint64 current_time);
    ~FieldEntity() = default;
};

#endif // FIELDENTITY_H
