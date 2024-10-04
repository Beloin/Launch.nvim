# Launch.nvim

Current settings version: 0.0.1

```lua
{
  "Beloin/Launch.nvim",
  config = function()
    require('Launch').setup()
  end,
  dependencies = {
    "folke/noice.nvim",
  }
}
```


# launch.nvim example

```JSON
{
  "version": "0.0.1",
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
  ]
}
```

# Dependencies
Noice

# References

Usually all code is inspired from [nvim-dap vscode extension](https://github.com/mfussenegger/nvim-dap/blob/master/lua/dap/ext/vscode.lua) 
