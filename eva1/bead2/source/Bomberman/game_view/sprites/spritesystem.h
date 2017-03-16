#ifndef SPRITESYSTEM_H
#define SPRITESYSTEM_H

#include <QObject>
#include "drawable.h"
#include "../../game_calc/entities/entityhandler.h"

class SpriteSystem : public QObject, public Drawable, public EntityHandler
{
    Q_OBJECT
protected:
class SpriteQueueItem
{

};

public:
    explicit SpriteSystem(QObject *parent = 0);
    virtual void draw(QPainter&, qint64) override {}
    virtual void accept(FieldEntity& entity, const qint64 current_time) {}
    virtual void accept(MovingEntity& entity, const qint64 current_time) {}
    virtual void accept(Entity& entity, const qint64 current_time) {}

signals:

public slots:
    void spawn(Entity& entity) {}
};

#endif // SPRITESYSTEM_H
