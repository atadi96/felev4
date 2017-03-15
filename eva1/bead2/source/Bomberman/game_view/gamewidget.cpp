#include "gamewidget.h"

GameWidget::GameWidget(QWidget *parent) : QWidget(parent)
{
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(updateGame()));
    if(!m_ground_pixmap.load(":/resources/graphics/map/ground.png")) throw 42;
    if(!m_wall_pixmap.load(":/resources/graphics/map/wall.png")) throw 42;
    m_map = new Map(20, 15);
    setFixedSize(
        m_map->size().width() * m_ground_pixmap.size().width(),
        m_map->size().height() * m_ground_pixmap.size().height()
    );
    m_game = new GameCalc();
    m_timer.setInterval(20);
    m_timer.start();
}

void GameWidget::paintEvent(QPaintEvent *event) {
    m_painter.begin(this);
    for(auto row = m_map->fields().begin(); row != m_map->fields().end(); ++row) {
        for(auto entity = row->begin(); entity != row->end(); ++entity) {
            (*entity)->visit(*this, QTime::currentTime());
        }
    }

    m_painter.setPen(Qt::blue);
    m_painter.setFont(QFont("Arial", 30));
    m_painter.drawText(rect(), Qt::AlignCenter, "Qt");

    m_painter.end();
}

void GameWidget::accept(FieldEntity& entity, const QTime& current_time) {
    QPixmap& pixmap = (entity.type == FieldType::Ground) ? m_ground_pixmap : m_wall_pixmap;
    m_painter.drawPixmap(entity.pos() * 50, pixmap);
}
void GameWidget::accept(Entity& entity, const QTime& current_time) {

}

void GameWidget::updateGame() {
    m_game->update(QTime::currentTime());
    update();
}

GameWidget::~GameWidget() {
    delete m_map;
    delete m_game;
}
