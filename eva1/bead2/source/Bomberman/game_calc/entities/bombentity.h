#ifndef BOMBENTITY_H
#define BOMBENTITY_H

#include "entity.h"

class BombEntity : public Entity
{
private:
    qint64 m_fuse_time;
    qint64 m_activated_time;
    bool m_detonated;
    bool m_activated;
public:
    BombEntity(const QPoint& pos, qint64 fuseTime);
    void activate(qint64 current_time);
    virtual void update(qint64 current_time) override;
    virtual void visit(EntityHandler& handler, qint64 current_time) override;
    bool detonated() const;
};

#endif // BOMBENTITY_H
