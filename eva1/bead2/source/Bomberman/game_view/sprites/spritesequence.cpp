#include "spritesequence.h"

SpriteSequence::SpriteSequence(
        QPixmap& pixmap,
        QSize frame_size,
        int fps,
        int start_frame,
        int frame_count
    ) : m_pixmap(pixmap)
      , m_frame_size(frame_size)
      , m_fps(fps)
      , m_start_frame(start_frame)
      , m_frame_count(frame_count)
{

}

void SpriteSequence::start(qint64 time) {
    m_start_time = time;
    m_current_time = time;
}

qint64 SpriteSequence::remaining() const {
    return (m_frame_count * 1000 / m_fps) + m_start_time - m_current_time;
}
void SpriteSequence::update(qint64 time) {
    m_current_time = time;
}

void SpriteSequence::draw(QPainter& painter, qint64 time) {
    painter.drawPixmap(targetRect(), m_pixmap, sourceRect());
}

bool SpriteSequence::finished() const {
    return remaining() <= 0;
}

QRect SpriteSequence::sourceRect() const {
    int current_frame = m_start_frame + m_fps * (m_current_time - m_start_time) / 1000;
    return QRect(
        QPoint(
            current_frame % (m_pixmap.size().width() / m_frame_size.width()),
            current_frame / (m_pixmap.size().height() / m_frame_size.height())
        ),
        m_frame_size
    );
}

SpriteSequence::~SpriteSequence() {
}
