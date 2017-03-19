#include "gamecalc.h"

GameCalc::GameCalc(const QString& map) {
    m_map = new Map(map);
    m_player = new MovingEntity(m_map->player_pos(), 1.5);
    //m_entities.reserve(m_map->enemy_pos().size() + 1 + m_map->size().width() * m_map->size().height());
    m_player->setName("Player");
    m_entities.push_back(m_player);
    connect(m_player, SIGNAL(die(Entity&)), this, SLOT(die(Entity&)));
    emit spawn(*m_player);
    for(auto it = m_map->enemy_pos().begin(); it != m_map->enemy_pos().end(); ++it) {
        EnemyEntity* entity = new EnemyEntity(*it);
        entity->setName("Ghost");
        entity->setDesiredDirection(Direction::getRandom());
        m_entities.push_back(entity);
        emit spawn(*entity);
    }
    m_paused = false;
    m_enemy_num = m_map->enemy_pos().size();
    m_defeated_num = 0;
    m_player_alive = true;
    m_last_update_time = 0;
    qDebug("GameCalc constructor done");
}

Map* GameCalc::map () const {
    return m_map;
}

std::list<Entity*> GameCalc::entities() const {
    return m_entities;
}


QTime GameCalc::playTime() const {
    return m_play_time;
}
int GameCalc::enemyNum() const {
    return m_enemy_num;
}
int GameCalc::defeatedNum() const {
    return m_defeated_num;
}
bool GameCalc::isOver() const {
    return !m_player_alive || m_defeated_num == m_enemy_num;
}
bool GameCalc::won() const {
    return m_player_alive && m_defeated_num == m_enemy_num;
}
bool GameCalc::paused() const {
    return m_paused;
}


/* **********************GAME UPDATE ************************************************** */



void GameCalc::update(const qint64 current_time) {
    if(m_last_update_time == 0) {
        m_last_update_time = current_time;
        m_prev_state = Keyboard::getState();
    }
    if(isOver()) return;
    KeyboardState state = Keyboard::getState();
    if(state.isKeyDown(GameKey::Pause) && !m_prev_state.isKeyDown(GameKey::Pause)) {
        m_paused = !m_paused;
        if(!m_paused) {
            m_last_update_time = current_time;
        }
    }
    if(!m_paused) {
        for(Entity* entity : m_entities) {
            entity->update(current_time);
            entity->visit(*this, current_time);
        }
        for(auto entity = m_entities.begin(); entity != m_entities.end(); /* !!! */) {
            if((*entity)->dead()) {
                delete (*entity);
                entity = m_entities.erase(entity);
            } else {
                ++entity;
            }
        }
        m_play_time = m_play_time.addMSecs(current_time - m_last_update_time);
        m_last_update_time = current_time;
    }
    m_prev_state = state;
}

void GameCalc::accept(FieldEntity&, const qint64) {
    qDebug("GameCalc visited by a FieldEntity");
}

void GameCalc::accept(MovingEntity& entity, const qint64 current_time) {
    const KeyboardState state = Keyboard::getState();
    if(state.isKeyDown(GameKey::Down)) {
        tryMove(entity, Direction::Down, current_time);
    }
    if(state.isKeyDown(GameKey::Up)) {
        tryMove(entity, Direction::Up, current_time);
    }
    if(state.isKeyDown(GameKey::Left)) {
        tryMove(entity, Direction::Left, current_time);
    }
    if(state.isKeyDown(GameKey::Right)) {
        tryMove(entity, Direction::Right, current_time);
    }
    if(state.isKeyDown(GameKey::Fire) && !m_prev_state.isKeyDown(GameKey::Fire)) {
        BombEntity* bomb = new BombEntity(entity.pos(), 5);
        bomb->activate(current_time);
        m_entities.push_back(bomb);
    }
}

void GameCalc::accept(EnemyEntity& entity, const qint64 current_time) {
    if(entity.hitbox().intersects(m_player->hitbox())) {
        this->m_player_alive = false;
        return;
    }
    if(!entity.is_moving() && !canMove(entity, entity.desiredDirection())) {
        entity.setDesiredDirection(Direction::getRandom());
    }
    tryMove(entity, entity.desiredDirection(), current_time);
}

void GameCalc::tryMove(MovingEntity& entity, const QPoint& direction, qint64 current_time) {
    if(canMove(entity, direction)) {
        entity.move(direction, current_time);
    }
}

bool GameCalc::canMove(MovingEntity& entity, const QPoint& direction) {
    return (m_map->contains(entity.pos() + direction) &&
            m_map->field(entity.pos() + direction)->type == FieldType::Ground);
}

void GameCalc::accept(BombEntity& entity, const qint64 current_time) {
    if(entity.detonated()) {
        int bombrange = 3;
        QRectF hitbox(
            QPointF(entity.pos()) - QPointF(bombrange,bombrange),
            QSizeF(2 * bombrange + 1, 2 * bombrange + 1)
        );
        for(auto entity = m_entities.begin(); entity != m_entities.end(); ++entity) {
            if(EnemyEntity* enemy = dynamic_cast<EnemyEntity*>(*entity)) {
                if(enemy->hitbox().intersects(hitbox)) {
                    ++this->m_defeated_num;
                    enemy->kill();
                }
            } else if(*entity == m_player && m_player->hitbox().intersects(hitbox)) {
                m_player_alive = false;
                qDebug("The player has been bombed!");
                (*entity)->kill();
            } else if(BombEntity* bombEntity = dynamic_cast<BombEntity*>(*entity)) {
                if(hitbox.intersects(QRectF(bombEntity->pos(), QSizeF(1,1)))) {
                    (*entity)->kill();
                }
            }
        }
    }
}


void GameCalc::accept(Entity&, const qint64) {
    qDebug("GameCalc visited by an Entity");
}

void GameCalc::die(Entity &entity) {
}

GameCalc::~GameCalc() {
    delete m_map;
    for(auto it = m_entities.begin(); it != m_entities.end(); ++it) {
        delete *it;
    }
}
