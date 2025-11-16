#include "build_process.hpp"

#include <libarcherus/log.hpp>

BuildProcess::BuildProcess(const QString& name, QPlainTextEdit& commandOutput, Options& options) :
    name(name),
    commandOutput(commandOutput),
    options(options),
    runProcess(name, commandOutput, options)
{

}

void BuildProcess::run() {
    connect(this, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), std::bind(&BuildProcess::monitorCallback, this, std::placeholders::_1, std::placeholders::_2));
    connect(this, &QProcess::readyReadStandardError, std::bind(&BuildProcess::errorCallback, this));
    connect(this, &QProcess::finished, std::bind(&BuildProcess::finishedCallback, this, std::placeholders::_1, std::placeholders::_2));

    const auto command = build();

    startCommand(command.c_str());
}

std::string BuildProcess::build() {
    if(options.unfree) {
        setenv("NIXPKGS_ALLOW_UNFREE", "1", 1);
        return std::format("nix build nixpkgs#{} --impure", name.toStdString());
    }
    unsetenv("NIXPKGS_ALLOW_UNFREE");
    return std::format("nix build nixpkgs#{}", name.toStdString());
}

void BuildProcess::monitorCallback(int exitCode, QProcess::ExitStatus status) {
    log(WARNING, "Exit code: {}, status: {}", exitCode, (int)status);
}

void BuildProcess::errorCallback()
{
    log(DEBUG, "output callback");
    auto output = readAllStandardError();
    commandOutput.appendPlainText(output);
}

void BuildProcess::finishedCallback(int exitCode, QProcess::ExitStatus status) {
    log(DEBUG, "Finished build");
    if (exitCode != 0) {
        log(ERROR, "Error, build command exited: {}", exitCode);
        return;
    }
    runProcess.run();
}
