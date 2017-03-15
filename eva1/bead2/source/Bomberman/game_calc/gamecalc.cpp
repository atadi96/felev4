#include "gamecalc.h"

GameCalc::GameCalc() {
    MovingEntity* entity = new MovingEntity(QPoint(0,0), 1);
    m_entities.push_back(entity);
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

void GameCalc::accept(MovingEntity& entity, const QTime& current_time) {
    entity.move(Direction::Right, current_time);
    qDebug(
        (QString("She's moving! ") +
        QString::number(entity.pos().x()) +
        QString(", ") +
        QString::number(entity.pos().y())).toStdString().c_str()
    );
}


void GameCalc::accept(Entity& entity, const QTime& current_time) {
    qDebug("GameCalc visited by an Entity");
}

GameCalc::~GameCalc() {
    for(auto it = m_entities.begin(); it != m_entities.end(); ++it) {
        delete *it;
    }
}
