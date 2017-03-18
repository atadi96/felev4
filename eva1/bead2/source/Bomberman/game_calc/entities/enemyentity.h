#ifndef ENEMYENTITY_H
#define ENEMYENTITY_H

#include "movingentity.h"

class EnemyEntity : public MovingEntity
{
private:
    QPoint m_desired_direction;
public:
    EnemyEntity(const QPoint& pos);
    virtual void visit(EntityHandler& handler, const qint64 current_time);
    virtual void update(qint64 current_time) override;
    const QPoint& desiredDirection() const;
    void setDesiredDirection(const QPoint& dir);
    ~EnemyEntity() {}
};

#endif // ENEMYENTITY_H
