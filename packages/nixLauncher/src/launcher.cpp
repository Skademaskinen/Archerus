#include "launcher.hpp"

#include <cstdlib>
#include <format>
#include <libarcherus/log.hpp>
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

Launcher::Launcher(QApplication& app) :
    shouldHide(true),
    toggleCli("Hide?"),
    app(app),
    buildProcess(this),
    runProcess(this),
    mainLabel("Launch a nix program")
{
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
        buttonLayout.addWidget(ptr);
        QObject::connect(ptr, &QPushButton::clicked, std::bind(&Launcher::launchCallback, this, item));
    }
    scrollArea.setAttribute(Qt::WA_AcceptTouchEvents);
    scrollArea.setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    QScroller::grabGesture(scrollArea.viewport(), QScroller::TouchGesture);

    commandOutput.setReadOnly(true);
    commandOutput.setMaximumHeight(96);

    toggleCli.toggle();
    connect(&toggleCli, &QRadioButton::toggled, std::bind(&Launcher::hideCallback, this, std::placeholders::_1));
    toggleCli.setFont(font);
    toggleCli.setMinimumHeight(48);
    toggleCli.setStyleSheet(QString::fromStdString(std::string(RADIOBUTTON_STYLESHEET)));

    scrollWidget.setLayout(&buttonLayout);
    scrollArea.setWidget(&scrollWidget);
    buttonHLayout.addWidget(&scrollArea);
    buttonHLayout.addWidget(&toggleCli);

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

    show();
    app.exec();
}

void Launcher::launchCallback(QString name) {
    log(WARNING, "Launching {}", name.toStdString());
    auto formattedCommand = std::format("sh -c \"nix build nixpkgs#{0} && echo '{0}'\"", name.toStdString());
    log(INFO, "Command: {}", formattedCommand);
    buildProcess.startCommand(formattedCommand.c_str());
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
    auto formattedCommand = std::format("nix run nixpkgs#{}", name.toStdString());
    runProcess.startCommand(formattedCommand.c_str());
    connect(&runProcess, &QProcess::finished, std::bind(&Launcher::runFinished, this, std::placeholders::_1, std::placeholders::_2));
    if(shouldHide) {
        hide();
    } else {
        connect(&runProcess, &QProcess::readyReadStandardOutput, std::bind(&Launcher::outputCallback, this, &runProcess));
    }
}

void Launcher::runFinished(int exitCode, QProcess::ExitStatus status) {
    if(shouldHide) {
        exit(exitCode);
    }
}

void Launcher::hideCallback(bool toggled) {
    log(DEBUG, "New hide value: {}", toggled);
    shouldHide = toggled;
}
