#include "launcher_option.hpp"

#include <libarcherus/log.hpp>

constexpr std::string_view OPTION_STYLESHEET = R"(
    QCheckBox {
        padding: 12px;
    }
)";

LauncherOption::LauncherOption(const std::string& name, const bool& initialValue) :
    QCheckBox(QString::fromStdString(name)),
    initiallyToggled(initialValue),
    value(initialValue)
{
    if(initiallyToggled) {
        toggle();
    }
    setStyleSheet(QString::fromStdString(std::string(OPTION_STYLESHEET)));
    connect(this, &QCheckBox::checkStateChanged, std::bind(&LauncherOption::callback, this, std::placeholders::_1));
}

void LauncherOption::callback(Qt::CheckState state) {
    log(DEBUG, "Changing state... {}", state != Qt::CheckState::Unchecked);
    value = state != Qt::CheckState::Unchecked;
}

LauncherOption::operator bool() {
    return value;
}
