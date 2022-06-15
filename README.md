# ng.nvim

Angular language server client for Neovim LSP

![Kapture 2022-06-15 at 17 03 40](https://user-images.githubusercontent.com/19226858/173929937-e2b6db50-0ce7-451b-9e61-7e7a88696145.gif)

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
