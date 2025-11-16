#pragma once

#include "config.hpp"
#include "shared_memory_manager.hpp"
#include "options.hpp"
#include "launcher_button.hpp"

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
    Options options;

    argparse::ArgumentParser& parser;

    QApplication& app;
    QVBoxLayout mainLayout;
    QLabel mainLabel;

    QList<LauncherButton*> buttons;
    QVBoxLayout buttonLayout;
    QVBoxLayout optionsLayout;
    QHBoxLayout buttonHLayout;
    QScrollArea scrollArea;
    QWidget scrollWidget;
    QPlainTextEdit commandOutput;
    QLineEdit searchField;

    QLockFile lock;
    QTimer quitTimer;
    SharedQuitFlag quitFlag;
};
