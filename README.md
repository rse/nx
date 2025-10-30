
NX 
==

**Node.js Environment Execution Utility**

**nx** is a very small Unix utility for executing Node.js-based commands
(like `node` itself, its companion tool `npm`, or arbitrary third-party
commands like `claude` or `copilot`) while directing Node.js and NPM to a
dedicated global-like local installation tree.

The crux is that the used global installation trees under `~/.nx/` are
writable instead of the usually non-writable default one (under e.g.
`/opt/local`).

Installation
------------

```
$ make install
```

Usage
-----

```
# use Anthropic Claude Code
$ nx claude create
$ nx claude npm install -g @anthropic-ai/claude-code
$ nx claude npm install -g ccstatusline
$ nx claude npm install -g tweakcc
$ nx claude tweakcc [...]
$ nx claude claude [...]
```

Copyright & License
-------------------

Copyright &copy; 2025 [Dr. Ralf S. Engelschall](mailto:rse@engelschall.com)<br/>
Licensed under [MIT](https://spdx.org/licenses/MIT)

