# ng.nvim

Angular language server client for Neovim LSP. This extension adds extra commands exposed by [vscode-ng-language-server](https://github.com/angular/vscode-ng-language-service), such as:

 - [x] Go to template for component under cursor 
 - [x] Go to component(s) for template
 - [x] Display template typecheck block

![Kapture 2022-06-15 at 17 03 40](https://user-images.githubusercontent.com/19226858/173929937-e2b6db50-0ce7-451b-9e61-7e7a88696145.gif)

## Getting started

### Required dependencies

This extension **WILL NOT** config an angular language server (not yet, at least). If you use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) you can follow [this steps](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#angularls).

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
