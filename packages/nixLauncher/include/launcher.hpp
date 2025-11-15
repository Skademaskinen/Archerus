#pragma once

#include "config.hpp"

#include <QtWidgets/QtWidgets>

class Launcher : public QWidget {
public:
    Launcher(QApplication&);
    ~Launcher();
    void run();

private:
    void launchCallback(QString name);
    void monitorCallback(int, QProcess::ExitStatus);
    void outputCallback(QProcess*);
    void errorCallback(QProcess*);
    void filterCallback();
    void buildFinished(int, QProcess::ExitStatus);
    void runFinished(int, QProcess::ExitStatus);
    void hideCallback(bool);

    LauncherConfig launcherConfig;
    bool shouldHide;

    QApplication& app;
    QVBoxLayout mainLayout;
    QLabel mainLabel;

    std::map<QString, QPushButton*> buttons;
    std::map<QString, QAction*> actions;
    QProcess buildProcess;
    QProcess runProcess;
    QVBoxLayout buttonLayout;
    QHBoxLayout buttonHLayout;
    QScrollArea scrollArea;
    QWidget scrollWidget;
    QPlainTextEdit commandOutput;
    QLineEdit searchField;
    QRadioButton toggleCli;
};
