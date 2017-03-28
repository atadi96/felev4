#ifndef GAMEWIDGET_H
#define GAMEWIDGET_H

#include <QWidget>
#include <QTimer>
#include <QPainter>
#include <QPixmap>
#include <QKeyEvent>

#include "../game_calc/gamecalc.h"
#include "../game_calc/map.h"
#include "../game_calc/entities/entityhandler.h"
#include "directionalpixmap.h"

class GameWidget : public QWidget, public EntityHandler
{
    Q_OBJECT
private:
    QTimer m_timer;
    QPainter m_painter;
    QPixmap m_ground_pixmap;
    QPixmap m_wall_pixmap;
    QPixmap m_player_pixmap;
    QPixmap m_ghost_pixmap;
    QPixmap m_bomb_pixmap;
    DirectionalPixmap m_ghost_sprite_sheet;
    DirectionalPixmap m_player_sprite_sheet;

    float m_scale;
    bool m_setup;
    GameCalc* m_game;
public:
    explicit GameWidget(QWidget *parent = 0);
    virtual void accept(FieldEntity& entity, const qint64 current_time) override;
    virtual void accept(Entity& entity, const qint64 current_time) override;
    virtual void accept(MovingEntity& entity, const qint64 current_time) override;
    virtual void accept(EnemyEntity& entity, const qint64 current_time) override;
    virtual void accept(BombEntity& entity, const qint64 current_time) override;
    ~GameWidget();

private:
    QRect scale(const QRectF& hitbox, float scale) const;

protected:
    void paintEvent(QPaintEvent* );
    void keyPressEvent(QKeyEvent* event);
    void keyReleaseEvent(QKeyEvent* event);

signals:

private slots:
    void updateGame();
};

#endif // GAMEWIDGET_H
