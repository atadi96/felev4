#ifndef SPRITESYSTEM_H
#define SPRITESYSTEM_H

#include <QObject>
#include <list>
#include "drawable.h"
#include "../../game_calc/entities/entityhandler.h"

class SpriteSystem : public QObject, public Drawable, public EntityHandler
{
    Q_OBJECT
private:
    std::list<Sprite*> m_sprites;

public:
    explicit SpriteSystem(QObject *parent = 0);
    virtual void draw(QPainter&, qint64) override;
    virtual void accept(FieldEntity& entity, const qint64 current_time) override;
    virtual void accept(MovingEntity& entity, const qint64 current_time) override;
    virtual void accept(EnemyEntity& entity, const qint64 current_time) override;
    virtual void accept(BombEntity& entity, const qint64 current_time) override;
    virtual void accept(Entity& entity, const qint64 current_time) override;
    virtual ~SpriteSystem() {}

signals:

public slots:
    void spawn(Entity&) {}
};

#endif // SPRITESYSTEM_H
