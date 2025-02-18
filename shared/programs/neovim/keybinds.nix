{
    programs.nixvim = {
        keymaps = [
            {
                key = "<A-i>";
                action = "<Cmd>ToggleTerm direction=float<CR>";
                mode = "n";
            }
            {
                key = "<A-i>";
                action = "<Cmd>ToggleTerm direction=float<CR>";
                mode = "t";
            }
            {
                key = "<A-j>";
                action = "<Cmd>Neotree toggle<CR>";
                mode = "n";
    }
            {
                key = "<C-s>";
                action = "<Cmd><ESC>w<CR>";
                mode = "n";
            }
            {
                key = "<C-s>";
                action = "<Cmd>w<CR>";
                mode = "i";
            }
            {
                key = "<A-t>";
                action = "<Cmd>Trouble diagnostics toggle<CR>";
                mode = "n";
            }
        ];

    };
}
