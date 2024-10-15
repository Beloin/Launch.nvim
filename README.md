![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

# Launch.nvim

Current settings version: `0.2.0`

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
  "version": "0.2.0",
  "configurations":[ 
    {
      "name": "My C runnable",
      "lang": "c",
      "type": "codelldb", // Following DAP types
      "program": "./target",
      "request": "launch",
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

- [ ] Java Implementation
- [ ] Varible expansion (Including env variables)
  - List of default variables
  - Command variables (if not exists create it)
- [ ] Command Prompt

# References

1. Usually all code is inspired from [nvim-dap vscode extension](https://github.com/mfussenegger/nvim-dap/blob/master/lua/dap/ext/vscode.lua) 
2. Following some tips with [nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template/tree/main) 
3. References in [nvim-dap](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation) 

## Java:

### TODOs:
- [ ] Implement Pipeline
- [ ] Configure args usage
- [ ] Fix per project env call

1. Strong usage of [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
2. References in [nvim-dap](https://github.com/mfussenegger/nvim-dap/wiki/Java) 
3. References from [Java Debug Configuration](https://github.com/microsoft/vscode-java-debug/blob/main/Configuration.md) 
4. Also using [vscode-java-options](https://github.com/microsoft/vscode-java-debug#options) 
