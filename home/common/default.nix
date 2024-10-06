{
    imports = [
        ./alacritty.nix
        ./zsh.nix
    ];
    home.sessionVariables = {
        EDITOR="nvim";
        PROMPT="%F{166}%n%f@%F{166}%m%f %F{7}%~%f%F{166} > %f";
    };
}