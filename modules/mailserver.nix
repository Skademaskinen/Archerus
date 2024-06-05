{config, lib, ...}: {
    options = {
        skademaskinen.mailserver = {
            enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
            };
        };
    };
    config = {
        imports = [(builtins.fetchTarball {
            url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-${config.system.stateVersion}/nixos-mailserver-nixos-${config.system.stateVersion}.tar.gz";
            sha256 = "";
        })]; 

        mailserver = {
            enable = config.skademaskinen.mailserver.enable;
            fqdn = "mail.${config.skademaskinen.domain}";
            domains = [config.skademaskinen.domain];
            loginAccounts."mast3r@${config.skademaskinen.domain}" = {
                hashedPasswordFile = ../files/mail.pw;
                aliases = ["admin@${config.skademaskinen.domain}" "postmaster@${config.skademaskinen.domain}"];
            };
            certificateScheme = "acme-nginx";
        };
        security.acme = if config.skademaskinen.mailserver.enable then {
            acceptTerms = true;
            default.email = "security@${config.skademaskinen.domain}";
        } else {};
    };
}
