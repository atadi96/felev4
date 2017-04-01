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
public:
    virtual void draw(QPainter& painter, qint64 time) = 0;
    virtual void update(qint64 time) = 0;
    virtual bool finished() const = 0;
    virtual int layer() const { return 0; }
    virtual ~Sprite() {}

    struct draw_order
    {
        bool operator()(const Sprite& lhs, const Sprite& rhs) const {
            return lhs.layer() > rhs.layer();
        }
    };
};

#endif // DRAWABLE_H
