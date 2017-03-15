#ifndef ENTITYHANDLER_H
#define ENTITYHANDLER_H

class Entity;
class FieldEntity;
class MovingEntity;

class EntityHandler
{
public:
    virtual void accept(FieldEntity& entity, const qint64 current_time) = 0;
    virtual void accept(MovingEntity& entity, const qint64 current_time) = 0;
    virtual void accept(Entity& entity, const qint64 current_time) = 0;
    virtual ~EntityHandler() {}
};

#endif // ENTITYHANDLER_H
