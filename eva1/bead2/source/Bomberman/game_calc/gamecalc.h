#ifndef GAMECALC_H
#define GAMECALC_H

#include <QObject>
#include <QString>
#include <QVector>
#include "entities/entity.h"
#include "entities/entityhandler.h"
#include "entities/movingentity.h"
#include "map.h"

class GameCalc : public QObject, public EntityHandler
{
    Q_OBJECT
private:
    Entity* m_player;
    QVector<Entity*> m_entities;
    Map* m_map;

public:
    GameCalc();
    Map* map () const;
    QVector<Entity*> entities() const;
    void update(const qint64 time);
    virtual void accept(FieldEntity& entity, const qint64 current_time) override;
    virtual void accept(Entity& entity, const qint64 current_time) override;
    virtual void accept(MovingEntity& entity, const qint64 current_time) override;
    ~GameCalc();

signals:
    void spawn(Entity& entity);

private:

};

#endif // GAMECALC_H
