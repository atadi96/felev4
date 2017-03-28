#ifndef ENTITY_H
#define ENTITY_H

#include <QObject>
#include <QPoint>
#include <QString>
#include "entityhandler.h"

class Entity : public QObject
{
    Q_OBJECT
protected:
    QPoint m_pos;
    QString m_name = "Entity";
    bool m_dead = false;
public:
    Entity();
    Entity(QPoint pos);
    const QString& name() const;
    void setName(const QString& name);
    QPoint pos() const;
    void setPos(const QPoint& pos);
    bool dead() const;
    QPoint& rpos();
    void kill();
    virtual void update(qint64) {}
    virtual void visit(EntityHandler& handler, const qint64 current_time);
    virtual ~Entity();

signals:
    void die(const Entity&) const;
};

#endif // ENTITY_H
