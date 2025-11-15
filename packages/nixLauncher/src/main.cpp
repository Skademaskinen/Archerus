#include "launcher.hpp"

#include <libarcherus/utils.hpp>
#include <libarcherus/log.hpp>

#include <QtWidgets/QApplication>

// we can't use the macro as Qt doesn't support that.
int main(int argc, char* argv[])
{
    currentLogLevel = dbg;
    log(DEBUG, "Starting nix launcher");
    QApplication app(argc, argv);
    Launcher launcher(app);
    launcher.run();
    return ErrorCode::success;
}
