#ifndef DRAWABLE_H
#define DRAWABLE_H

#include <QPainter>

struct Drawable
{
    virtual void draw(QPainter& painter, qint64 time) = 0;
    virtual ~Drawable() {}
};

struct Sprite : public Drawable
{
    virtual void draw(QPainter& painter, qint64 time) = 0;
    virtual void update(qint64 time) = 0;
    virtual bool finished() const = 0;
    virtual ~Sprite() {}
};

#endif // DRAWABLE_H
