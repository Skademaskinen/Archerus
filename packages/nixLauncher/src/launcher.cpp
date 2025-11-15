#include "launcher.hpp"

#include <cstdlib>
#include <format>
#include <libarcherus/log.hpp>
#include <qnamespace.h>
#include <string_view>

constexpr std::string_view SEARCH_STYLESHEET = R"(
    QLineEdit {
        padding: 12px;
    }
)";
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
constexpr std::string_view RADIOBUTTON_STYLESHEET = R"(
    QRadioButton {
        padding: 12px;
    }
)";
constexpr std::string_view MAIN_STYLESHEET = R"(
    background: rgba(0, 0, 0, 128);
    border: none;
)";

Launcher::Launcher(QApplication& app, argparse::ArgumentParser& parser) :
    hidden(true),
    unfree(false),
    hideButton("Hide overlay"),
    unfreeButton("Allow Unfree"),
    parser(parser),
    app(app),
    buildProcess(this),
    runProcess(this),
    mainLabel("Launch a nix program"),
    memory("nix-launcher")
{
    if(!memory.create(1) && !parser.get<bool>("--force")) {
        log(WARNING, "Another instance is already running, toggling it");
        quitFlag.signalQuit();
        exit(0);
    }

    quitTimer.setInterval(500);
    connect(&quitTimer, &QTimer::timeout, std::bind(&Launcher::quitTimeout, this));
    quitTimer.start();

    mainLayout.setAlignment(Qt::AlignmentFlag::AlignTop);

    searchField.setPlaceholderText("Filter packages");
    auto font = searchField.font();
    font.setPointSize(18);
    searchField.setFont(font);
    searchField.setMinimumHeight(48);
    searchField.setStyleSheet(QString::fromStdString(std::string(SEARCH_STYLESHEET)));
    connect(&searchField, &QLineEdit::returnPressed, std::bind(&Launcher::filterCallback, this));
    QList<QString> names;
    for(const auto& item : launcherConfig.get()) {
        names.push_back(item.get<std::string>().c_str());
    }
    auto placeholderIcon = QIcon::fromTheme("application-x-executable");
    for(const auto& item : names) {
        auto ptr = new QPushButton(item);
        buttons[item] = ptr;
        ptr->setStyleSheet(QString::fromStdString(std::string(BUTTON_STYLESHEET)));
        ptr->setIcon(placeholderIcon);
        ptr->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Fixed);
        buttonLayout.addWidget(ptr);
        QObject::connect(ptr, &QPushButton::clicked, std::bind(&Launcher::launchCallback, this, item));
    }
    scrollArea.setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    scrollWidget.setMinimumWidth(scrollArea.width());
    scrollWidget.setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Fixed);
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Fixed);
    buttonLayout.setAlignment(Qt::AlignTop | Qt::AlignLeft);

    scrollArea.setAttribute(Qt::WA_AcceptTouchEvents);
    scrollArea.setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    QScroller::grabGesture(scrollArea.viewport(), QScroller::TouchGesture);

    commandOutput.setReadOnly(true);
    commandOutput.setMaximumHeight(96);

    hideButton.toggle();
    connect(&hideButton, &QCheckBox::checkStateChanged, std::bind(&Launcher::hideCallback, this, std::placeholders::_1));
    hideButton.setFont(font);
    hideButton.setMinimumHeight(48);
    hideButton.setStyleSheet(QString::fromStdString(std::string(RADIOBUTTON_STYLESHEET)));

    connect(&unfreeButton, &QCheckBox::checkStateChanged, std::bind(&Launcher::unfreeCallback, this, std::placeholders::_1));
    unfreeButton.setFont(font);
    unfreeButton.setMinimumHeight(48);
    unfreeButton.setStyleSheet(QString::fromStdString(std::string(RADIOBUTTON_STYLESHEET)));

    optionsLayout.addWidget(&hideButton);
    optionsLayout.addWidget(&unfreeButton);
    optionsLayout.setAlignment(Qt::AlignmentFlag::AlignTop);

    scrollWidget.setLayout(&buttonLayout);
    scrollArea.setWidget(&scrollWidget);
    buttonHLayout.addWidget(&scrollArea);
    buttonHLayout.addLayout(&optionsLayout);

    mainLayout.addWidget(&mainLabel);
    mainLayout.addWidget(&searchField);
    mainLayout.addLayout(&buttonHLayout);
    mainLayout.addWidget(&commandOutput);

    setLayout(&mainLayout);
    setAttribute(Qt::WA_TranslucentBackground);
    setStyleSheet(QString::fromStdString(std::string(MAIN_STYLESHEET)));

    log(DEBUG, "Constructed Launcher");
}

Launcher::~Launcher()
{
    log(DEBUG, "Destroying Launcher");
}

void Launcher::run()
{
    log(INFO, "Running Launcher");

    showFullScreen();
    app.exec();
}

void Launcher::launchCallback(QString name) {
    log(WARNING, "Launching {}", name.toStdString());
    //auto formattedCommand = std::format("sh -c \"nix build nixpkgs#{0} && echo '{0}'\"", name.toStdString());
    auto command = buildCommand(name.toStdString());
    log(INFO, "Command: {}", command);

    buildProcess.startCommand(command.c_str());
    connect(&buildProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), std::bind(&Launcher::monitorCallback, this, std::placeholders::_1, std::placeholders::_2));
    connect(&buildProcess, &QProcess::readyReadStandardError, std::bind(&Launcher::errorCallback, this, &buildProcess));
    connect(&buildProcess, &QProcess::finished, std::bind(&Launcher::buildFinished, this, std::placeholders::_1, std::placeholders::_2));
}

void Launcher::monitorCallback(int exitCode, QProcess::ExitStatus status) {
    log(WARNING, "Exit code: {}, status: {}", exitCode, (int)status);
}

void Launcher::outputCallback(QProcess* process)
{
    log(DEBUG, "output callback");
    auto output = process->readAllStandardOutput();
    commandOutput.appendPlainText(output);
}

void Launcher::errorCallback(QProcess* process)
{
    log(DEBUG, "output callback");
    auto output = process->readAllStandardError();
    commandOutput.appendPlainText(output);
}

void Launcher::filterCallback() {
    log(DEBUG, "Filter callback");
    auto text = searchField.text();
    log(DEBUG, "Text: {}", text.toStdString());
    if(text == "") {
        for(const auto& [_, ptr] : buttons) {
            ptr->setVisible(true);
        }
    }
    else {
        for(const auto& [name, ptr] : buttons) {
            auto visible = name.contains(text);
            ptr->setVisible(visible);
        }
    }
    scrollWidget.adjustSize();
    scrollWidget.updateGeometry();
    log(DEBUG, "Finished filter callback");
}

void Launcher::buildFinished(int exitCode, QProcess::ExitStatus status) {
    if (exitCode != 0) {
        log(ERROR, "Error, build command exited: {}", exitCode);
        return;
    }
    auto name = buildProcess.readAllStandardOutput();
    auto command = runCommand(name.toStdString());
    runProcess.startCommand(command.c_str());
    log(INFO, "Command: {}", command);
    connect(&runProcess, &QProcess::finished, std::bind(&Launcher::runFinished, this, std::placeholders::_1, std::placeholders::_2));
    if(hidden) {
        hide();
    } else {
        connect(&runProcess, &QProcess::readyReadStandardOutput, std::bind(&Launcher::outputCallback, this, &runProcess));
    }
}

void Launcher::runFinished(int exitCode, QProcess::ExitStatus status) {
    if(hidden) {
        exit(exitCode);
    }
}

void Launcher::hideCallback(const Qt::CheckState toggled) {
    log(DEBUG, "New toggle value: {}", toggled != Qt::Unchecked);
    hidden = toggled != Qt::Unchecked;
}

void Launcher::unfreeCallback(const Qt::CheckState toggled) {
    log(DEBUG, "New toggle value: {}", toggled != Qt::Unchecked);
    unfree = toggled != Qt::Unchecked;
}

std::string Launcher::buildCommand(const std::string& name) {
    if (unfree) {
        return std::format("sh -c \"NIXPKGS_ALLOW_UNFREE=1 nix build nixpkgs#{0} --impure && echo '{0}'\"", name);
    } else {
        return std::format("sh -c \"nix build nixpkgs#{0} && echo '{0}'\"", name);
    }
}

std::string Launcher::runCommand(const std::string& name) {
    if (unfree) {
        return std::format("NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#{} --impure", name);
    } else {
        return std::format("nix run nixpkgs#{}", name);
    }
}

void Launcher::quitTimeout() {
    if(quitFlag.shouldQuit()) {
        app.quit();
    }
}
