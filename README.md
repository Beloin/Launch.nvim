# Launch.nvim

Current settings version: `0.1.0`

```lua
{
  "Beloin/Launch.nvim",
  config = function()
    require('Launch').setup()
  end,
  dependencies = {
    "folke/noice.nvim",
    "nvim-telescope/telescope.nvim",
  }
}
```

# launch.nvim example

```JSON
{
  "version": "0.1.0",
  "configurations":[ 
    {
      "name": "My C runnable",
      "lang": "c",
      "type": "codelldb", // Following DAP types
      "program": "./target",
      // Act as preprocessor
      "pipeline": [ "echo 'Hello World'", "make debug" ],
      "args" : [ "examples/flow-control/example_02.bc" ],
      "env": { 
        "ENV_VAR": "1" 
      }
    }
  ],
  "tasks": [
    {
      "name": "Generate compile_commands.json",
      "pipeline": [
        "bear -- make debug"
      ]
    }
  ]
}
```

# Dependencies

1. [Noice](https://github.com/folke/noice.nvim)
2. [Telescope](https://github.com/nvim-telescope/telescope.nvim)

# Posterior works

- [ ] CWD Property
- [ ] Varible expansion (Including env variables)
  - List of default variables
  - Command variables (if not exists create it)
- [ ] Command Prompt

# References

1. Usually all code is inspired from [nvim-dap vscode extension](https://github.com/mfussenegger/nvim-dap/blob/master/lua/dap/ext/vscode.lua) 
2. Following some tips with [nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template/tree/main) 
