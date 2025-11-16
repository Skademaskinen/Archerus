#include "run_process.hpp"

#include <format>
#include <libarcherus/log.hpp>
#include <qplaintextedit.h>

RunProcess::RunProcess(const QString& name, QPlainTextEdit& commandOutput, Options& options) :
    name(name),
    commandOutput(commandOutput),
    options(options)
{

}

void RunProcess::run() {
    auto command = build();
    connect(this, &QProcess::finished, std::bind(&RunProcess::finishedCallback, this, std::placeholders::_1, std::placeholders::_2));
    if(options.hidden) {
        options.callback();
    } else {
        connect(this, &QProcess::readyReadStandardOutput, std::bind(&RunProcess::outputCallback, this));
    }
    startCommand(command.c_str());
}

void RunProcess::finishedCallback(int exitCode, QProcess::ExitStatus status) {
    if(options.hidden) {
        exit(exitCode);
    }
}

void RunProcess::outputCallback()
{
    log(DEBUG, "output callback");
    auto output = readAllStandardOutput();
    commandOutput.appendPlainText(output);
}

std::string RunProcess::build() {
    if(options.unfree) {
        setenv("NIXPKGS_ALLOW_UNFREE", "1", 1);
        return std::format("nix run nixpkgs#{} --impure", name.toStdString());
    }
    unsetenv("NIXPKGS_ALLOW_UNFREE");
    return std::format("nix run nixpkgs#{}", name.toStdString());
}
