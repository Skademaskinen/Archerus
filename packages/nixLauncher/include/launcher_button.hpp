#pragma once

#include "build_process.hpp"
#include "options.hpp"

#include <QtWidgets/QtWidgets>

class LauncherButton : public QPushButton {
public:
    LauncherButton(const QString& name, QPlainTextEdit&, Options& options);
private:
    void callback();

    Options& options;

    const QString name;

    BuildProcess buildProcess;
};
