#include <QString>
#include <QtTest>
#include "/home/ripseiko/Dokumentumok/Egyetem/felev4/eva1/bead2/source/Bomberman/game_calc/entities/bombentity.h"
#include "/home/ripseiko/Dokumentumok/Egyetem/felev4/eva1/bead2/source/Bomberman/game_calc/entities/movingentity.h"
#include "/home/ripseiko/Dokumentumok/Egyetem/felev4/eva1/bead2/source/Bomberman/game_calc/entities/direction.h"

class Unit_testTest : public QObject
{
    Q_OBJECT

public:
    Unit_testTest() : player(QPoint(0, 0), 1), bomb(QPoint(0, 0), 1) {}

private:
    MovingEntity player;
    QRectF hitbox;
    BombEntity bomb;

private Q_SLOTS:
    void MovePlayer();
    void PlayerStopped();
    void PlayerMoved();

    void BombActivated();
    void BombDetonated();
};

void Unit_testTest::MovePlayer() {
    hitbox = player.hitbox();
    player.move(Direction::Right, 0);
    player.update(500);
    QCOMPARE(player.pos(), QPoint(0,0));
    QVERIFY(hitbox != player.hitbox());
    QVERIFY(player.is_moving());

}

void Unit_testTest::PlayerStopped() {
    player.update(1200);
    QVERIFY(!player.is_moving());
}

void Unit_testTest::PlayerMoved() {
    QCOMPARE(player.pos(), QPoint(0,0) + Direction::Right);
    QVERIFY(hitbox != player.hitbox());
}

void Unit_testTest::BombActivated() {
    bomb.update(500);
    QVERIFY(!bomb.detonated());
    bomb.activate(1000);
    bomb.update(1500);
    QVERIFY(!bomb.detonated());
}

void Unit_testTest::BombDetonated() {
    bomb.update(2100);
    QVERIFY(bomb.detonated());
}

QTEST_APPLESS_MAIN(Unit_testTest)

#include "tst_unit_testtest.moc"
