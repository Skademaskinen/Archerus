#pragma once

#include "options.hpp"
#include "run_process.hpp"

#include <QtWidgets/QtWidgets>

class BuildProcess : public QProcess {
public:
    BuildProcess(const QString&, QPlainTextEdit&, Options&);
    void run();
private:

    void monitorCallback(int, QProcess::ExitStatus);
    void errorCallback();
    void finishedCallback(int, QProcess::ExitStatus);

    std::string build();

    QString name;
    QPlainTextEdit& commandOutput;

    Options& options;
    RunProcess runProcess;
};
