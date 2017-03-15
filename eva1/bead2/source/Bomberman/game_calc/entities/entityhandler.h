#ifndef ENTITYHANDLER_H
#define ENTITYHANDLER_H

#include <QTime>

class Entity;
class FieldEntity;

class EntityHandler
{
public:
    virtual void accept(FieldEntity& entity, const QTime& current_time) = 0;
    virtual void accept(Entity& entity, const QTime& current_time) = 0;
    virtual ~EntityHandler() {}
};

#endif // ENTITYHANDLER_H
