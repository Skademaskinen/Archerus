# this is a hack to easily use lib within lib
inputs:

path: import path (inputs // { lib = inputs.self.lib; })
