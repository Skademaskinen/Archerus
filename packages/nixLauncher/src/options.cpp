#include "options.hpp"

Options::Options(Callback callback) :
    hidden("Hide overlay", true),
    unfree("Allow Unfree"),
    callback(callback)
{
}
