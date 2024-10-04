# Launch.nvim

Current settings version: 0.0.1

```JSON
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
      "name": "Run My C",
      "lang": "C",
      "type": "dbg", // Following DAP types
      "run": "make debug",
      "program": "./target",
      // Acts as a "Preprocessor"
      "pipeline": ["echo 'Hello World'", "make debug"],
      "args" : ["examples/flow-control/example_02.bc"],
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
