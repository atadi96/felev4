#ifndef ENTITY_H
#define ENTITY_H

#include <QPoint>
#include "gamecalc.h"

class Entity
{
public:
    class EntityAccepter
    {
    public:
        virtual void accept(Entity& e);
    }
    Entity();
    QPoint map_pos;
    float transition;
    virtual string name() const;
    virtual void visit(EntityAccepter& accepter) { accepter.accept(*this); }
    virtual ~Entity();
};

#endif // ENTITY_H
