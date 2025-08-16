{ self, ... }:

{
    imports = with self.nixosModules; [
        common
        desktop
        gaming
        grub
        plymouth
        programming
        server.base
        server.dummyProject
        server.folkevognen
        server.homepage
        server.matrix
        server.minecraft
        server.mysql
        server.nextcloud
        server.palworld
        server.prometheus
        server.putricide
        server.server
        server.sketch-bot
        server.taoshi-web
        systemd-boot
        users.mast3r
        users.taoshi
    ];
}
