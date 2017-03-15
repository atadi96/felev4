#include "gamecalc.h"
#include "keyboard/keyboard.h"

GameCalc::GameCalc() {
    MovingEntity* entity = new MovingEntity(QPoint(2,2), 1);
    m_entities.push_back(entity);
}

Map* GameCalc::map () const {
    return m_map;
}

QVector<Entity*> GameCalc::entities() const {
    return m_entities;
}

void GameCalc::update(const qint64 current_time) {
    for(Entity* entity : m_entities) {
        entity->visit(*this, current_time);
    }
}

void GameCalc::accept(FieldEntity& entity, const qint64 current_time) {
    qDebug("GameCalc visited by a FieldEntity");
}

void GameCalc::accept(MovingEntity& entity, const qint64 current_time) {
    const KeyboardState state = Keyboard::getState();
    if(state.isKeyDown(GameKey::Down)) {
        entity.move(Direction::Down, current_time);
    }
    if(state.isKeyDown(GameKey::Up)) {
        entity.move(Direction::Up, current_time);
    }
    if(state.isKeyDown(GameKey::Left)) {
        entity.move(Direction::Left, current_time);
    }
    if(state.isKeyDown(GameKey::Right)) {
        entity.move(Direction::Right, current_time);
    }
    //entity.move(Direction::Right, current_time);
}


void GameCalc::accept(Entity& entity, const qint64 current_time) {
    qDebug("GameCalc visited by an Entity");
}

GameCalc::~GameCalc() {
    for(auto it = m_entities.begin(); it != m_entities.end(); ++it) {
        delete *it;
    }
}
