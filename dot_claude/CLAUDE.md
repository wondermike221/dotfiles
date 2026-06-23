{{- if eq .chezmoi.username "CORP\\mhixon" -}}
# graphify

- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.

# read-later

- **read-later** (`~/.claude/skills/read-later/SKILL.md`) - browser tab URLs → Obsidian notes in `Read Later/`. Trigger: `/read-later`
When the user types `/read-later`, invoke the Skill tool with `skill: "read-later"` before doing anything else.

{{ end -}}
{{- /* # Use Fable 5 to plan this task but use sonnet sub-agents for the implementation */ -}}
Ask questions whenever in doubt instead of providing formulaic responses. Do it when you think the go-to response is vague, and you could use some clarification to create a better response. Always use interactive (clickable) interface for questions instead of numbering them
