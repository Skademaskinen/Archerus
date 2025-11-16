#include "launcher_button.hpp"

#include <format>
#include <libarcherus/log.hpp>

constexpr std::string_view BUTTON_STYLESHEET = R"(
    QPushButton {
        min-width: 100%;
        min-height: 48px;
        font-size: 20px;
        padding: 12px 24px;
        border-radius: 12px;
        background-color: #444;
        color: white;
    }
    QPushButton:pressed {
        background-color: #2980b9;
    }
)";

LauncherButton::LauncherButton(const QString& name, QPlainTextEdit& commandOutput, Options& options) :
    options(options),
    buildProcess(name, commandOutput, options),
    QPushButton(name),
    name(name)
{
    setStyleSheet(QString::fromStdString(std::string(BUTTON_STYLESHEET)));
    //setIcon(QIcon::fromTheme(name, QIcon::fromTheme("application-x-executable")));
    setIcon(QIcon::fromTheme("application-x-executable"));
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Fixed);
    connect(this, &QPushButton::clicked, std::bind(&LauncherButton::callback, this));
}

void LauncherButton::callback() {
    log(WARNING, "Launching {}", name.toStdString());

    buildProcess.run();
}

