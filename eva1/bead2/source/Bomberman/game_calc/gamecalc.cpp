#include "gamecalc.h"

GameCalc::GameCalc() {
}

Map* GameCalc::map () const {
    return m_map;
}

QVector<Entity*> GameCalc::entities() const {
    return m_entities;
}

void GameCalc::update(const QTime& current_time) {
    for(Entity* entity : m_entities) {
        entity->visit(*this, current_time);
    }
}

void GameCalc::accept(FieldEntity& entity, const QTime& current_time) {
    qDebug("GameCalc visited by a FieldEntity");
}

void GameCalc::accept(Entity& entity, const QTime& current_time) {
    qDebug("GameCalc visited by an Entity");
}

GameCalc::~GameCalc() {
}
