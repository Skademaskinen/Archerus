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
constexpr std::string_view MAIN_STYLESHEET = R"(
    background: rgba(0, 0, 0, 128);
    border: none;
)";

Launcher::Launcher(QApplication& app, argparse::ArgumentParser& parser) :
    parser(parser),
    app(app),
    options(std::bind(&Launcher::hide, this)),
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
    for(const auto& item : names) {
        buttons.push_back(new LauncherButton(item, commandOutput, options));
        buttonLayout.addWidget(buttons.back());
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

    optionsLayout.addWidget(&options.hidden);
    optionsLayout.addWidget(&options.unfree);
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

void Launcher::filterCallback() {
    log(DEBUG, "Filter callback");
    auto text = searchField.text();
    log(DEBUG, "Text: {}", text.toStdString());
    if(text == "") {
        for(auto& button : buttons) {
            button->setVisible(true);
        }
    }
    else {
        for(auto& button : buttons) {
            auto visible = button->text().contains(text);
            button->setVisible(visible);
        }
    }
    scrollWidget.adjustSize();
    scrollWidget.updateGeometry();
    log(DEBUG, "Finished filter callback");
}

void Launcher::quitTimeout() {
    if(quitFlag.shouldQuit()) {
        app.quit();
    }
}
