{
    boot.loader.grub = {
        gfxmodeEfi = "1920x1200";
        extraEntries = ''
            menuentry "Ubuntu 24.11 LTS" --class ubuntu {
                if [ x$feature_all_video_module = xy ]; then
                    insmod all_video
                else
                    insmod efi_gop
                    insmod efi_uga
                    insmod ieee1275_fb
                    insmod vbe
                    insmod vga
                    insmod video_bochs
                    insmod video_cirrus
                fi
                insmod gzio
                if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
                insmod part_gpt
                insmod ext2
                search --no-floppy --set=root --fs-uuid a0339a88-852e-4316-bfc0-a895f3d0a04f
                linux /vmlinuz root=/dev/mapper/ubuntu--vg-ubuntu--lv ro quiet splash crashkernel=2G-4G:320M,4G-32G:512M,32G-64G:1024M,64G-128G:2048M,128G-:4096M 
                initrd /initrd.img
            
            }
        '';
    };
}
