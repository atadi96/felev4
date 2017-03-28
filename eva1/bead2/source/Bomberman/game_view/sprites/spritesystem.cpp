#include "spritesystem.h"

SpriteSystem::SpriteSystem(QObject *parent) : QObject(parent)
{

}

void SpriteSystem::draw(QPainter& painter, qint64 time) {
    for(auto it = m_sprites.begin(); it != m_sprites.end(); ++it) {
        (*it)->draw(painter, time);
    }
}
void SpriteSystem::accept(FieldEntity& entity, const qint64 current_time) {}
void SpriteSystem::accept(MovingEntity& entity, const qint64 current_time) {}
void SpriteSystem::accept(EnemyEntity& entity, const qint64 current_time) {}
void SpriteSystem::accept(BombEntity& entity, const qint64 current_time) {}
void SpriteSystem::accept(Entity& entity, const qint64 current_time) {}
