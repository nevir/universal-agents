#!/bin/sh

cd "$CLAUDE_PROJECT_DIR"
agent_files=$(find . -name "AGENTS.md" -type f)
[ -z "$agent_files" ] && exit 0

cat <<end_context
=== AGENTS.MD CONTEXT ===

This project uses AGENTS.md files to provide scoped instructions based on the
file or directory being worked on.

This project has the following AGENTS.md files:

$agent_files

NON-NEGOTIABLE: When working with any file or directory within the project:

1. Load ALL AGENTS.md files in the directory hierarchy matching that location.
   You do not have to reload AGENTS.md files you have already loaded previously.

2. ALWAYS apply instructions from the AGENTS.md files that match that location.
   When there are conflicting instructions, apply instructions from the
	 AGENTS.md file that is CLOSEST (most specific) to that location. More
	 specific instructions OVERRIDE more general ones.

Example (hypothetical project):
	AGENTS.md
	subfolder/
		file.txt
		AGENTS.md

	When working with "subfolder/file.txt":
	- Instructions from "subfolder/AGENTS.md" take precedence
	- Instructions from root "AGENTS.md" apply only if not overridden
end_context

# Load top-level AGENTS.md if present - it applies to ALL work in the project
if [ -f "./AGENTS.md" ]; then
	cat <<-end_root_context

	=== PROJECT-WIDE INSTRUCTIONS ===

	The following instructions from the root AGENTS.md apply to ALL work within
	this project, as all files are within scope of the project:

	end_root_context
	cat "./AGENTS.md"
	printf "\n"
fi
