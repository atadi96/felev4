#ifndef GAMECALC_H
#define GAMECALC_H

#include <QObject>
#include <QString>
#include <QVector>
#include <QTime>
#include "entities/entity.h"
#include "entities/entityhandler.h"
#include "entities/movingentity.h"
#include "entities/enemyentity.h"
#include "keyboard/keyboard.h"
#include "map.h"

class GameCalc : public QObject, public EntityHandler
{
    Q_OBJECT
private:
    MovingEntity* m_player;
    QVector<Entity*> m_entities;
    Map* m_map;
    QTime m_play_time;
    int m_enemy_num;
    int m_defeated_num;
    bool m_player_alive;
    bool m_paused;
    KeyboardState m_prev_state;
    qint64 m_last_update_time;
public:
    GameCalc(const QString& map);
    Map* map () const;
    QVector<Entity*> entities() const;
    QTime playTime() const;
    int defeatedNum() const;
    int enemyNum() const;
    bool isOver() const;
    bool won() const;
    bool paused() const;
    void update(const qint64 time);
    virtual void accept(FieldEntity& entity, const qint64 current_time) override;
    virtual void accept(Entity& entity, const qint64 current_time) override;
    virtual void accept(MovingEntity& entity, const qint64 current_time) override;
    virtual void accept(EnemyEntity& entity, const qint64 current_time) override;
    ~GameCalc();

signals:
    void spawn(Entity& entity);

private:
    void tryMove(MovingEntity& entity, const QPoint& direction, qint64 current_time);
    bool canMove(MovingEntity& entity, const QPoint& direction);

};

#endif // GAMECALC_H
