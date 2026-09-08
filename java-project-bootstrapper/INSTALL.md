# Java Project Bootstrapper

This is a Codex local skill.

## Install

Current Codex documentation says user-level skills are loaded from:

`$HOME/.agents/skills`

So install this directory as:

```bash
mkdir -p "$HOME/.agents/skills"
cp -R java-project-bootstrapper "$HOME/.agents/skills/"
```

Then start/restart Codex if necessary and run:

```text
/skills
```

You can explicitly invoke the skill with:

```text
$java-project-bootstrapper
```

Codex can also implicitly select it when the task matches the skill description.

See the official Codex skill documentation for the current discovery rules.
