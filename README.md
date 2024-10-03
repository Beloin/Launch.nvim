# Launch.nvim

Current settings version: 0.0.1


# launch.nvim example

```JSON
{
  "version": "0.0.1",
  "configurations":[ 
    {
      "name": "Run My C",
      "type": "cppdbg", // Following DAP types
      "run": "make debug",
      "program": "./target",
      // Acts as a "Preprocessor"
      "pipeline": ["echo 'Hello World'", "make debug"],
      "args" : ["examples/flow-control/example_02.bc"]
    }
  ]
}
```
