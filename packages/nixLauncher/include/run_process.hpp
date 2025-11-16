#pragma once

#include "options.hpp"

#include <QtWidgets/QtWidgets>

class RunProcess : public QProcess {
public:
    RunProcess(const QString&, QPlainTextEdit&, Options&);
    void run();
private:
    void finishedCallback(int exitCode, QProcess::ExitStatus status);
    void outputCallback();
    std::string build();

    Options& options;
    QString name;
    QPlainTextEdit& commandOutput;
};
