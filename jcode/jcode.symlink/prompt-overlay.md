# Global skills

Global skills are available through mcpc's `@global-skills` session. Discover them on demand:

```bash
mcpc @global-skills skills-list
mcpc @global-skills skills-get < name > --raw
```

If mcpc cannot connect to `@global-skills`, start the local skill server and retry:

```bash
skills-server start
```

If the session has expired, restart it and retry:

```bash
mcpc @global-skills restart
```
