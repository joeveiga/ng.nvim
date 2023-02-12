<p align="center">
  <img width="300" height="300" src="logo.png">
</p>

# ng.nvim

Angular language server client for Neovim LSP. This extension adds extra commands exposed by [vscode-ng-language-server](https://github.com/angular/vscode-ng-language-service), such as:

- [x] Go to template for component under cursor
- [x] Go to component(s) for template
- [x] Display template typecheck block

![Kapture 2022-06-15 at 17 03 40](https://user-images.githubusercontent.com/19226858/173929937-e2b6db50-0ce7-451b-9e61-7e7a88696145.gif)

## Getting started

### Required dependencies

This extension **WILL NOT** config an angular language server (not yet, at least). If you use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) you can follow [these steps](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#angularls).

### Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use { 'joeveiga/ng.nvim'}
```

### Usage

```lua
local opts = { noremap = true, silent = true }
local ng = require("ng");
vim.keymap.set("n", "<leader>at", ng.goto_template_for_component, opts)
vim.keymap.set("n", "<leader>ac", ng.goto_component_with_template_file, opts)
vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, opts)
```

### FAQ

<details>
 <summary>How can I restart the angular language service?</summary>

 <br>
 
 VSCode provides a `Angular: Restart Angular Language Server` command to restart the service. Unfortunately `ng.nvim` does not
 manage the lifecycle of the server at the moment. However, you can use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) to
 accomplish this with the `:LspRestart` command.

![Kapture 2022-06-15 at 21 59 23](https://user-images.githubusercontent.com/19226858/173974953-68cc17a5-1684-43f1-80cb-78b6cf95ae8e.gif)

</details>

<details>
 <summary>Can I access the angular server logs?</summary>

 <br>
 
 I don't plan to support VSCode's `Angular: Open Language Server Log` command at the moment (at least not the functionality to automatically
 enable logging). PRs are welcome though ;). If you want to do this via lspconfig, you can add it to your `angularls` config cmd like so:

<!-- prettier-ignore -->
 ```lua
local cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  "<typescript_path>",
  "--ngProbeLocations",
  "<angular_language_service_path>",
  -- THESE ARE THE RELEVANT OPTIONS
  "--logFile",
  "<path_to_logs>/nglangsvc.log",
  "--logVerbosity",
  "verbose" -- terse|normal|verbose|requestTime
}

lspconfig.angularls.setup({
  cmd = cmd,
  capabilities = capabilities,
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = cmd
  end
})

-- ...
-- you can then add a mapping to open the file
vim.keymap.set("n", "<leader>al", '<cmd>view <path_to_logs>/nglangsvc.log<cr>', opts)
```

</details>

## Related Projects

- [vscode-ng-language-server](https://github.com/angular/vscode-ng-language-service)
- [coc-angular](https://github.com/iamcco/coc-angular)
