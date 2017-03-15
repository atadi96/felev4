#ifndef GAMECALC_H
#define GAMECALC_H

#include <QString>
#include <QVector>
#include <QTime>
#include "entities/entity.h"
#include "entities/entityhandler.h"
#include "map.h"

class GameCalc : public EntityHandler
{
private:
    Entity* m_player;
    QVector<Entity*> m_entities;
    Map* m_map;

public:
    GameCalc();
    Map* map () const;
    QVector<Entity*> entities() const;
    void update(const QTime& time);
    virtual void accept(FieldEntity& entity, const QTime& current_time) override;
    virtual void accept(Entity& entity, const QTime& current_time) override;
    ~GameCalc();

private:

};

#endif // GAMECALC_H
