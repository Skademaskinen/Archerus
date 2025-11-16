#include "launcher.hpp"

#include <libarcherus/utils.hpp>
#include <libarcherus/log.hpp>

#include <QtWidgets/QApplication>

// we can't use the macro as Qt doesn't support that.
int main(int argc, char* argv[])
{
    currentLogLevel = dbg;
    log(DEBUG, "Starting nix launcher");
    argparse::ArgumentParser parser("nix-launcher");
    parser.add_argument("--force")
          .help("Force the operation")
          .default_value(false)
          .implicit_value(true);
    parser.parse_args(argc, argv);
    QApplication app(argc, argv);
    Launcher launcher(app, parser);
    launcher.run();
    return ErrorCode::success;
}
