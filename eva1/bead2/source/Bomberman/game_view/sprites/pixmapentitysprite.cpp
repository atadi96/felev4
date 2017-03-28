#include "pixmapentitysprite.h"

PixmapEntitySprite::PixmapEntitySprite(QPixmap* pixmap, Entity* entity, int layer = 0)
    : m_pixmap(pixmap), m_entity(entity), m_layer(layer)
{
    connect(entity, SIGNAL(die(Entity)), this, SLOT(sourceDead(Entity)));
    m_dead = m_entity->dead();
}

void PixmapEntitySprite::draw(QPainter& painter, qint64) {
    if(m_dead) return;
    QRect targetRect;
    targetRect.setTopLeft(QPoint(
        m_entity->pos().x() * m_pixmap->size().width(),
        m_entity->pos().y() * m_pixmap->size().height()
    ));
    targetRect.setSize(m_pixmap->size());
    painter.drawPixmap(
        targetRect,
        *m_pixmap
    );
}

void PixmapEntitySprite::update(qint64) {
}

bool PixmapEntitySprite::finished() const {
    return m_dead;
}
int PixmapEntitySprite::layer() const {
    return m_layer;
}

void PixmapEntitySprite::sourceDead(const Entity&) {
    m_dead = true;
}
