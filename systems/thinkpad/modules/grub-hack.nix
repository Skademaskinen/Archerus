{
    boot.loader.grub.extraEntries = ''
        menuentry "Ubuntu 24.11 LTS" -class ubuntu {
            insmod part_gpt
            insmod ext2
            search --no-floppy --set=root --fs-uuid a0339a88-852e-4316-bfc0-a895f3d0a04f
            linux //vmlinuz splash root=/dev/mapper/ubuntu--vg-ubuntu--lv
            initrd //initrd.img
        
        }
    '';
}
