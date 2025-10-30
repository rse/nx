
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
# setup environment
$ nx foo --create
$ nx foo npm install -g bar

# use environment
$ nx foo node [...]
$ nx foo npm [...]
$ nx foo bar [...]

[...]

# check and update environment
$ nx foo --list
$ nx foo --update

[...]

# destroy environment
$ nx foo --destroy
```

Example
-------

```
# setup tool environment
$ nx tool --create

# install Anthropic Claude Code (and companion tools)
# (https://www.claude.com/product/claude-code)
$ nx tool npm install -g @anthropic-ai/claude-code
$ nx tool npm install -g ccstatusline tweakcc
$ nx tool tweakcc -a

# install Google Gemini
# (https://google-gemini.github.io/gemini-cli/)
$ nx tool npm install -g @google/gemini-cli

# install Alibaba Qwen Code
# (https://github.com/QwenLM/qwen-code)
$ nx tool npm install -g @qwen-code/qwen-code

# install Github Copilot CLI
# (https://github.com/github/copilot-cli)
$ nx tool npm install -g @github/copilot

# install OpenAI Codex
# (https://github.com/openai/codex/)
$ nx tool npm install -g @openai/codex

# install OpenCode
# (https://github.com/sst/opencode)
$ nx tool npm install -g opencode-ai

# install Crush
# (https://github.com/charmbracelet/crush)
$ nx tool npm install -g @charmland/crush

# install Continue CLI
# (https://docs.continue.dev/cli/install)
$ nx tool npm install -g @continuedev/cli

# use the tools
$ nx tool claude [...]
$ nx tool gemini [...]
$ nx tool qwen [...]
$ nx tool copilot [...]
$ nx tool codex [...]
$ nx tool opencode [...]
$ nx tool crush [...]
$ nx tool cn [...]
```

Copyright & License
-------------------

Copyright &copy; 2025 [Dr. Ralf S. Engelschall](mailto:rse@engelschall.com)<br/>
Licensed under [MIT](https://spdx.org/licenses/MIT)

