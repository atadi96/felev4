#ifndef GAMEWIDGET_H
#define GAMEWIDGET_H

#include <QWidget>
#include <QTimer>
#include <QPainter>
#include <QPixmap>

#include "../game_calc/gamecalc.h"
#include "../game_calc/map.h"
#include "../game_calc/entities/entityhandler.h"

class GameWidget : public QWidget, public EntityHandler
{
    Q_OBJECT
private:
    QTimer m_timer;
    QPainter m_painter;
    QPixmap m_ground_pixmap;
    QPixmap m_wall_pixmap;
    Map* m_map;
    GameCalc* m_game;
public:
    explicit GameWidget(QWidget *parent = 0);
    virtual void accept(FieldEntity& entity, const QTime& current_time) override;
    virtual void accept(Entity& entity, const QTime& current_time) override;
    virtual void accept(MovingEntity& entity, const QTime& current_time) override {}
    ~GameWidget();

protected:
    void paintEvent(QPaintEvent* );

signals:

private slots:
    void updateGame();
};

#endif // GAMEWIDGET_H
