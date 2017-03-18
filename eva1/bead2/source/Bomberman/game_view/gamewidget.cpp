#include "gamewidget.h"
#include "game_calc/keyboard/keyboard.h"
#include <QDateTime>

GameWidget::GameWidget(QWidget *parent) : QWidget(parent), m_setup(false)
{
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(updateGame()));
    setFocusPolicy(Qt::StrongFocus);
    if(!m_ground_pixmap.load(":/resources/graphics/map/ground.png")) throw 42;
    if(!m_wall_pixmap.load(":/resources/graphics/map/wall.png")) throw 42;
    if(!m_player_pixmap.load(":/resources/graphics/characters/player/player.png")) throw 42;
    if(!m_ghost_pixmap.load(":/resources/graphics/characters/ghost/ghost0.png")) throw 42;
    m_scale = m_ground_pixmap.size().width();
    m_game = new GameCalc(":/resources/maps/01.map");
    setFixedSize(
        m_game->map()->size().width() * m_scale,
        (m_game->map()->size().height() + 1) * m_scale
    );
    m_timer.setInterval(20);
    m_setup = true;
    m_timer.start();
}

void GameWidget::paintEvent(QPaintEvent *event) {
    if(!m_setup) return;
    qint64 current_time = QDateTime::currentMSecsSinceEpoch();
    m_painter.begin(this);
    auto fields = m_game->map()->fields();
    for(auto row = fields.begin(); row != fields.end(); ++row) {
        for(auto entity = row->begin(); entity != row->end(); ++entity) {
            (*entity)->visit(*this, current_time);
        }
    }
    for(auto entity = m_game->entities().begin(); entity != m_game->entities().end(); ++entity) {
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
        m_painter.drawText(rect(), Qt::AlignCenter, "-- PAUSED --");
    }
    if(m_game->isOver()) {
        if(m_game->won()) {
            m_painter.drawText(rect(), Qt::AlignCenter, "-- YOU WIN! --");
        } else {
            m_painter.drawText(rect(), Qt::AlignCenter, "-- YOU LOST! --");
        }
    }
    m_painter.end();
}


void GameWidget::keyPressEvent(QKeyEvent* event) {
    Keyboard::keyPressEvent(event);
}

void GameWidget::keyReleaseEvent(QKeyEvent* event) {
    Keyboard::keyReleaseEvent(event);
}

QRect GameWidget::scale(const QRectF& hitbox, float scale) const {
    QRect rect;
    rect.setTopLeft((hitbox.topLeft() * scale).toPoint());
    rect.setSize((hitbox.size() * scale).toSize());
    return rect;
}

void GameWidget::accept(FieldEntity& entity, const qint64) {
    QPixmap& pixmap = (entity.type == FieldType::Ground) ? m_ground_pixmap : m_wall_pixmap;
    m_painter.drawPixmap(entity.pos() * m_scale, pixmap);
}

void GameWidget::accept(EnemyEntity& entity, const qint64) {
    m_painter.drawPixmap(
        scale(entity.hitbox(), m_scale),
        m_ghost_pixmap
    );
}


void GameWidget::accept(MovingEntity& entity, const qint64) {
    m_painter.drawPixmap(
        scale(entity.hitbox(), m_scale),
        m_player_pixmap
    );
}

void GameWidget::accept(Entity&, const qint64) {
}

void GameWidget::updateGame() {
    m_game->update(QDateTime::currentMSecsSinceEpoch());
    update();
}

GameWidget::~GameWidget() {
    delete m_game;
}
