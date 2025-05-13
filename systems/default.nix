inputs:

with builtins;

mapAttrs (name: path: import path inputs) {
    Arcueid = ./arcueid;
    Laptop = ./laptop;
    Skademaskinen = ./skademaskinen;
    Thinkpad = ./thinkpad;
}
