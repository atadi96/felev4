#ifndef SPRITESEQUENCE_H
#define SPRITESEQUENCE_H

#include <QPixmap>
#include <QSize>
#include <QRect>
#include "drawable.h"

class SpriteSequence : public Sprite
{
protected:
    QPixmap& m_pixmap;
    QSize m_frame_size;
    int m_fps;
    int m_start_frame;
    int m_frame_count;
    bool m_finished;
    qint64 m_start_time;
    qint64 m_current_time;
    qint64 m_remaining_time;
public:
    SpriteSequence(QPixmap& pixmap, QSize frame_size, int fps, int start_frame = 0, int frame_count = 0);
    void start(qint64 time);
    qint64 remaining() const;
    virtual void update(qint64 time) override;
    virtual void draw(QPainter& painter, qint64 time) override;
    virtual bool finished() const override;
    ~SpriteSequence();
protected:
    QRect sourceRect() const;
    virtual QRect targetRect() = 0;

};

#endif // SPRITESEQUENCE_H
