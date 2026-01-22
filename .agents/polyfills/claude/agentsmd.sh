#!/bin/sh

# This project is licensed under the [Blue Oak Model License, Version 1.0.0][1],
# but you may also license it under [Apache License, Version 2.0][2] if you—
# or your legal team—prefer.
# [1]: https://blueoakcouncil.org/license/1.0.0
# [2]: https://www.apache.org/licenses/LICENSE-2.0

# Detect if this is a global install by checking script location
script_dir=$(cd "$(dirname "$0")" && pwd)
is_global_install=0
case "$script_dir" in
	"$HOME"/.agents/polyfills*) is_global_install=1 ;;
esac

cd "$CLAUDE_PROJECT_DIR"
agent_files=$(find . -name "AGENTS.md" -type f)

# Check for global ~/AGENTS.md (only for global installs)
has_global_agentsmd=0
if [ $is_global_install -eq 1 ] && [ -f "$HOME/AGENTS.md" ]; then
	has_global_agentsmd=1
fi

# Exit if no AGENTS.md files found anywhere
[ -z "$agent_files" ] && [ $has_global_agentsmd -eq 0 ] && exit 0

cat <<end_context
<agentsmd_instructions>
This project uses AGENTS.md files to provide scoped instructions based on the
file or directory being worked on.

This project has the following AGENTS.md files:

<available_agentsmd_files>
$agent_files
</available_agentsmd_files>

NON-NEGOTIABLE: When working with any file or directory within the project:

1. Load ALL AGENTS.md files in the directory hierarchy matching that location.
   You do not have to reload AGENTS.md files you have already loaded previously.

2. ALWAYS apply instructions from the AGENTS.md files that match that location.
   When there are conflicting instructions, apply instructions from the
   AGENTS.md file that is CLOSEST (most specific) to that location. More
   specific instructions OVERRIDE more general ones.

   <example>
     Project structure:
       AGENTS.md
       subfolder/
         file.txt
         AGENTS.md

     When working with "subfolder/file.txt":
       - Instructions from "subfolder/AGENTS.md" take precedence
       - Instructions from root "AGENTS.md" apply only if not overridden
   </example>

3. Precedence hierarchy (from lowest to highest priority):
   - ~/AGENTS.md (global - applies to all projects)
   - ./AGENTS.md (project root - applies to this entire project)
   - Nested AGENTS.md files (directory-specific - applies to subdirectories)

   More specific files ALWAYS override more general ones.
</agentsmd_instructions>
end_context

# Load global ~/AGENTS.md if it exists (lowest precedence)
if [ $has_global_agentsmd -eq 1 ]; then
	cat <<-end_global_context

		The content of ~/AGENTS.md is as follows:

		<agentsmd path="~/AGENTS.md">
		$(cat "$HOME/AGENTS.md")
		</agentsmd>
	end_global_context
fi

# Load project root AGENTS.md if it exists (higher precedence than global)
if [ -f "./AGENTS.md" ]; then
cat <<-end_root_context

The content of ./AGENTS.md is as follows:

<agentsmd path="./AGENTS.md">
$(cat "./AGENTS.md")
</agentsmd>
end_root_context
fi
