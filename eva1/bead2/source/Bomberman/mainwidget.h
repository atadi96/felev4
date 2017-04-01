#ifndef MAINWIDGET_H
#define MAINWIDGET_H

#include <QWidget>
#include <QPushButton>
#include <QLabel>
#include <QVBoxLayout>
#include "game_view/gamewidget.h"

namespace Ui {
class MainWidget;
}

class MainWidget : public QWidget
{
    Q_OBJECT

public:
    explicit MainWidget(QWidget *parent = 0);
    ~MainWidget();

private:
    QLabel* label;
    QPushButton* storageButton;
    QPushButton* meadowButton;
    QPushButton* ruinsButton;
    QVBoxLayout* vBoxLayout;
    Ui::MainWidget *ui;

    void setupButton(QPushButton*& button, const char* text);
    void clearWidget(QWidget* widget);

private slots:
    void storageClick(bool);
    void meadowClick(bool);
    void ruinsClick(bool);
};

#endif // MAINWIDGET_H
