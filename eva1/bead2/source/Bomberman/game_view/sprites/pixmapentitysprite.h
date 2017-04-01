#ifndef PIXMAPENTITYSPRITE_H
#define PIXMAPENTITYSPRITE_H

#include <QPixmap>
#include "drawable.h"
#include "game_calc/entities/entity.h"

class PixmapEntitySprite : public QObject, public Sprite
{
    Q_OBJECT
protected:
    QPixmap* m_pixmap;
    Entity* m_entity;
    int m_layer;
    bool m_dead;
public:
    PixmapEntitySprite(QPixmap* pixmap, Entity* entity, int layer);
    virtual void draw(QPainter& painter, qint64 time) override;
    virtual void update(qint64 time) override;
    virtual bool finished() const override;
    virtual int layer() const override;
    virtual ~PixmapEntitySprite() {}

public slots:
    void sourceDead(const Entity&);

};

#endif // PIXMAPENTITYSPRITE_H
