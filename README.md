# datsyourip

A [myip.wtf](https://codeberg.org/wtfismyip/wtfismyip) alternative that's fucking fast, and is in WTFPL v2. (also known as I do not care enough to license this license)

## Why

1. It's written for JIT version of one of the fastest non-compiled language (also known as LuaJIT)
2. It's fucking fast. I don't even use luvi - this is purely luv, which is available in many distros, including [Haiku](https://haiku-os.org/).
3. Yes, it is faster than myip.wtf.
4. There isn't even an HTTP parsing library used. All I need is `Host`, not `Accept`, `Accept-Encoding`, `Accept-Language`, `Connection` (because you always get `Close`), `Origin`, `Referer`, `Sec-Fetch-blablabla` and `User-Agent`.
5. Did I mention that it's fast?
6. Oh, and the default behavior is to shove the IP to your face. Literally zero bloat, other than this unnecessary piece of document. Now, let's get productive.

## Configuring

Create `cfg.lua` with:

```lua
local dom = ".recycledplist.space"
return {
 hostmatch = true, -- this line is not needed if you want it to be disabled
 port = 32761, -- nor this for default port
 domains = {
  "myip"..dom, -- alternatively, "myip.recycledplist.space"
  "ipv4"..dom,
  "ipv6"..dom
 }
}
```

hostmatch means that the host check will be required for request to be processed.

## How to run

Do I even need this?

WARNING: ONLY EXECUTE ONE COMMAND IN THIS LINE. PICK WHICHEVER YOU PREFER.

```sh
luvit main
luvi .
luajit main.lua
lua main.lua
# and even more... (feel free to PR)
```

If it doesn't work in even a single runtime, make an issue. I will be debugging this for every Lua runtime that Luv runs on.
