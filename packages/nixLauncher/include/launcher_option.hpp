#pragma once

#include <QtWidgets/QtWidgets>

class LauncherOption : public QCheckBox {
public:
    LauncherOption(const std::string&, const bool& = false);

    operator bool();

private:
    void callback(Qt::CheckState);

    bool initiallyToggled;
    const std::string name;
    bool value;
};
