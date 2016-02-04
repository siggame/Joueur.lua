# GAME_NAME Lua Client

This is the root of you AI. Stay out of the joueur/ folder, it does most of the heavy lifting to play on our game servers. Your AI, and the game objects it manipulates are all in `games/game_name/`, with your very own AI living in `games/game_name/ai.lua` for you to make smarter.

## How to Run

This client **does not** work on the Campus rc##xcs213 Linux machines, but it can work on your own Windows/Linux/Mac machines. You just need to install lua 5.1 and luajit, both which are easy to install.

### Linux

Make sure you have the package `lua5.1`, `lua-socket`, and `luajit` installed, then:

```
./testRun myOwnGameSession
```

### Windows

Just download [LuaDist](http://luadist.org/). That package has everything you need to run the Lua client, and actually has LuaJIT to run Lua. Place it the contents anywhere, then make sure to add the path to the bin/ folder in LuaDist to your Path. Then you can:

```
lua main.lua GAME_NAME -s r99acm.device.mst.edu -r myOwnGameSession
```

#### make

There is a `Makefile` provided, but it is empty as Lua is an interpreted language. If you want to add `make` steps feel free to, but you may want to check with an Arena dev to make sure the Arena has the packages you need to use in `make`.
