#pragma once

#include "config.hpp"
#include "shared_memory_manager.hpp"

#include <QtWidgets/QtWidgets>
#include <argparse/argparse.hpp>

class Launcher : public QWidget {
public:
    Launcher(QApplication&, argparse::ArgumentParser&);
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
    void hideCallback(const Qt::CheckState);
    void unfreeCallback(const Qt::CheckState);
    void quitTimeout();

    std::string buildCommand(const std::string&);
    std::string runCommand(const std::string&);

    LauncherConfig launcherConfig;
    bool hidden;
    bool unfree;

    argparse::ArgumentParser& parser;

    QApplication& app;
    QVBoxLayout mainLayout;
    QLabel mainLabel;

    std::map<QString, QPushButton*> buttons;
    std::map<QString, QAction*> actions;
    QProcess buildProcess;
    QProcess runProcess;
    QVBoxLayout buttonLayout;
    QVBoxLayout optionsLayout;
    QHBoxLayout buttonHLayout;
    QScrollArea scrollArea;
    QWidget scrollWidget;
    QPlainTextEdit commandOutput;
    QLineEdit searchField;
    QCheckBox hideButton;
    QCheckBox unfreeButton;

    QSharedMemory memory;
    QTimer quitTimer;
    SharedQuitFlag quitFlag;
};
