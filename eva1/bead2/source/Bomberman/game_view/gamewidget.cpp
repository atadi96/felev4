#include "gamewidget.h"
#include "game_calc/keyboard/keyboard.h"
#include <QDateTime>

GameDialog::GameDialog(QString map, QWidget *parent) : QDialog(parent), m_ghost_sprite_sheet(&m_ghost_pixmap), m_player_sprite_sheet(&m_player_pixmap), m_setup(false)
{
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(updateGame()));
    setFocusPolicy(Qt::StrongFocus);
    if(!m_ground_pixmap.load(":/resources/graphics/map/ground.png")) throw 42;
    if(!m_wall_pixmap.load(":/resources/graphics/map/wall.png")) throw 42;
    if(!m_player_pixmap.load(":/resources/graphics/characters/player/player_sheet.png")) throw 42;
    if(!m_ghost_pixmap.load(":/resources/graphics/characters/ghost/ghost_sheet.png")) throw 42;
    if(!m_bomb_pixmap.load(":/resources/graphics/seal.png")) throw 42;
    m_scale = m_ground_pixmap.size().width();
    m_game = new GameCalc(map);
    setWindowTitle(m_game->map()->name());
    setFixedSize(
        m_game->map()->size().width() * m_scale,
        (m_game->map()->size().height() + 1) * m_scale
    );
    m_timer.setInterval(20);
    m_setup = true;
    m_timer.start();
    qDebug("GameWidget contructor done");
}

void GameDialog::paintEvent(QPaintEvent *event) {
    if(!m_setup) return;
    qint64 current_time = QDateTime::currentMSecsSinceEpoch();
    m_painter.begin(this);
    auto fields = m_game->map()->fields();
    for(auto row = fields.begin(); row != fields.end(); ++row) {
        for(auto entity = row->begin(); entity != row->end(); ++entity) {
            (*entity)->visit(*this, current_time);
        }
    }
    std::list<Entity*> entites(m_game->entities());
    for(auto entity = entites.begin(); entity != entites.end(); ++entity) {
        (*entity)->visit(*this, current_time);
    }

    m_painter.setPen(Qt::black);
    m_painter.setFont(QFont("Arial", 30));
    QRect textRect(
        QPoint(0, rect().size().height() - m_scale),
        QSize(rect().width(), m_scale)
    );
    m_painter.drawText(textRect, Qt::AlignLeft, QString::fromUtf8("Time: ") + m_game->playTime().toString("mm:ss"));
    m_painter.drawText(textRect, Qt::AlignRight, "Enemies: " + QString::number(m_game->enemyNum() - m_game->defeatedNum()));
    if(m_game->paused()) {
        m_painter.drawText(rect(), Qt::AlignCenter, "-- PAUSED --\nClose the window to\nreturn to the menu");
    }
    if(m_game->isOver()) {
        if(m_game->won()) {
            m_painter.drawText(rect(), Qt::AlignCenter, "-- YOU WIN! --\nClose the window to\nreturn to the menu");
        } else {
            m_painter.drawText(rect(), Qt::AlignCenter, QString::fromUtf8("-- YOU LOST! --\nClose the window to\nreturn to the menu"));
        }
    }
    m_painter.end();
}


void GameDialog::keyPressEvent(QKeyEvent* event) {
    Keyboard::keyPressEvent(event);
}

void GameDialog::keyReleaseEvent(QKeyEvent* event) {
    Keyboard::keyReleaseEvent(event);
}

QRect GameDialog::scale(const QRectF& hitbox, float scale) const {
    QRect rect;
    rect.setTopLeft((hitbox.topLeft() * scale).toPoint());
    rect.setSize((hitbox.size() * scale).toSize());
    return rect;
}

void GameDialog::accept(FieldEntity& entity, const qint64) {
    QPixmap& pixmap = (entity.type == FieldType::Ground) ? m_ground_pixmap : m_wall_pixmap;
    m_painter.drawPixmap(entity.pos() * m_scale, pixmap);
}

void GameDialog::accept(EnemyEntity& entity, const qint64) {
    m_painter.drawPixmap(
        scale(entity.hitbox(), m_scale),
        m_ghost_pixmap,
        m_ghost_sprite_sheet.sourceRectForDirection(entity.direction())
    );
}


void GameDialog::accept(MovingEntity& entity, const qint64) {
    m_painter.drawPixmap(
        scale(entity.hitbox(), m_scale),
        m_player_pixmap,
        m_player_sprite_sheet.sourceRectForDirection(entity.direction())
    );
}

void GameDialog::accept(BombEntity& entity, const qint64) {
    m_painter.drawPixmap(
        scale(
            QRectF(entity.pos(), QSizeF(1, 1) ),
            m_scale
        ),
        m_bomb_pixmap
    );
}

void GameDialog::accept(Entity&, const qint64) {
}

void GameDialog::updateGame() {
    m_game->update(QDateTime::currentMSecsSinceEpoch());
    update();
}

GameDialog::~GameDialog() {
    delete m_game;
}
