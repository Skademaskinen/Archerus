{pkgs, name ? "test", ...}: pkgs.stdenv.mkDerivation {
    name = "banner";
    pname = "banner";
    src = null;
    dontUnpack = true;
    installPhase = ''
        ${pkgs.figlet}/bin/figlet "${name}" > $out
        echo "Last rebuild:  $(date)" >> $out
        echo "" >> $out
        echo "Written by:    Mast3r_waf1z" >> $out
    '';
}
