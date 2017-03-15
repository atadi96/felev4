#ifndef ENTITY_H
#define ENTITY_H

#include <QPoint>
#include <QTime>
#include <QString>
#include "entityhandler.h"

class Entity
{
protected:
    QPoint m_pos;
public:
    Entity();
    QPoint pos() const;
    void setPos(const QPoint& pos);
    QPoint& rpos();
    virtual void visit(EntityHandler& handler, const QTime& current_time);
    virtual ~Entity();
};

#endif // ENTITY_H
