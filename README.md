# ng.nvim

Angular language server client for Neovim LSP

## Getting started

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use { 'joeveiga/ng.nvim'}
```

### Usage

```lua
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>at", '<cmd>lua require("ng").goto_template_for_component()<cr>', opts)
vim.api.nvim_set_keymap("n", "<leader>ac", '<cmd>lua require("ng").goto_component_with_template_file()<cr>', opts)
vim.api.nvim_set_keymap("n", "<leader>aT", '<cmd>lua require("ng").get_template_tcb()<cr>', opts)
```

## Related Projects

* [vscode-ng-language-server](https://github.com/angular/vscode-ng-language-service)
* [coc-angular](https://github.com/iamcco/coc-angular)
