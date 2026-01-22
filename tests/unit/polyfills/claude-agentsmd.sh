# ============================================
# Polyfill Mode Helpers
# ============================================

# Run polyfill from project location (repo mode)
run_polyfill_repo() {
	local project_dir="$1"
	CLAUDE_PROJECT_DIR="$project_dir" sh "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh"
}

# Run polyfill from global location (global mode)
run_polyfill_global() {
	local project_dir="$1"
	# Copy script to global location if not already there
	if [ ! -f "$HOME/.agents/polyfills/claude/agentsmd.sh" ]; then
		mkdir -p "$HOME/.agents/polyfills/claude"
		cp "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh" "$HOME/.agents/polyfills/claude/agentsmd.sh"
	fi
	CLAUDE_PROJECT_DIR="$project_dir" sh "$HOME/.agents/polyfills/claude/agentsmd.sh"
}

# Clean up global polyfill
cleanup_global_polyfill() {
	rm -f "$HOME/.agents/polyfills/claude/agentsmd.sh"
}

# ============================================
# Tests
# ============================================

test_no_agentsmd_files() {
	local project_dir="$1"

	# Run the polyfill script with no AGENTS.md files
	local output
	output=$(run_polyfill_repo "$project_dir")
	local exit_code=$?

	# Should exit with 0 and produce no output
	[ "$exit_code" -eq 0 ] &&
	[ -z "$output" ]
}

test_single_root_agentsmd() {
	local project_dir="$1"

	# Create a root AGENTS.md
	cat > "$project_dir/AGENTS.md" <<-end_agentsmd
		# Test Project
		This is a test AGENTS.md file.
	end_agentsmd

	# Run the polyfill script
	local output
	output=$(CLAUDE_PROJECT_DIR="$project_dir" sh "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh")

	# Should output the instructions and root content
	echo "$output" | grep -q "<agentsmd_instructions>" &&
	echo "$output" | grep -q "<available_agentsmd_files>" &&
	echo "$output" | grep -q "./AGENTS.md" &&
	echo "$output" | grep -q '<agentsmd path="./AGENTS.md">' &&
	echo "$output" | grep -q "# Test Project" &&
	echo "$output" | grep -q "This is a test AGENTS.md file."
}

test_multiple_nested_agentsmd() {
	local project_dir="$1"

	# Create multiple AGENTS.md files
	cat > "$project_dir/AGENTS.md" <<-end_root
		# Root Instructions
	end_root

	mkdir -p "$project_dir/subfolder"
	cat > "$project_dir/subfolder/AGENTS.md" <<-end_subfolder
		# Subfolder Instructions
	end_subfolder

	mkdir -p "$project_dir/deep/nested/path"
	cat > "$project_dir/deep/nested/path/AGENTS.md" <<-end_deep
		# Deep Instructions
	end_deep

	# Run the polyfill script
	local output
	output=$(CLAUDE_PROJECT_DIR="$project_dir" sh "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh")

	# Should list all AGENTS.md files
	echo "$output" | grep -q "<available_agentsmd_files>" &&
	echo "$output" | grep -q "./AGENTS.md" &&
	echo "$output" | grep -q "./subfolder/AGENTS.md" &&
	echo "$output" | grep -q "./deep/nested/path/AGENTS.md" &&
	# Should include root content
	echo "$output" | grep -q '<agentsmd path="./AGENTS.md">' &&
	echo "$output" | grep -q "# Root Instructions"
}

test_nested_agentsmd_without_root() {
	local project_dir="$1"

	# Create nested AGENTS.md files but no root
	mkdir -p "$project_dir/subfolder"
	cat > "$project_dir/subfolder/AGENTS.md" <<-end_subfolder
		# Subfolder Only
	end_subfolder

	# Run the polyfill script
	local output
	output=$(CLAUDE_PROJECT_DIR="$project_dir" sh "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh")

	# Should list the subfolder file
	echo "$output" | grep -q "<available_agentsmd_files>" &&
	echo "$output" | grep -q "./subfolder/AGENTS.md" &&
	# Should NOT have root AGENTS.md content
	! echo "$output" | grep -q '<agentsmd path="./AGENTS.md">'
}

test_output_format_structure() {
	local project_dir="$1"

	# Create a simple AGENTS.md
	cat > "$project_dir/AGENTS.md" <<-end_agentsmd
		# Format Test
	end_agentsmd

	# Run the polyfill script
	local output
	output=$(CLAUDE_PROJECT_DIR="$project_dir" sh "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh")

	# Verify complete XML-like structure
	echo "$output" | grep -q "<agentsmd_instructions>" &&
	echo "$output" | grep -q "</agentsmd_instructions>" &&
	echo "$output" | grep -q "<available_agentsmd_files>" &&
	echo "$output" | grep -q "</available_agentsmd_files>" &&
	echo "$output" | grep -q '<agentsmd path="./AGENTS.md">' &&
	echo "$output" | grep -q "</agentsmd>" &&
	# Verify key instruction text
	echo "$output" | grep -q "NON-NEGOTIABLE" &&
	echo "$output" | grep -q "Load ALL AGENTS.md files"
}

test_special_characters_in_agentsmd() {
	local project_dir="$1"

	# Create AGENTS.md with special characters
	cat > "$project_dir/AGENTS.md" <<-'end_agentsmd'
		# Special Characters Test
		Use `backticks` and $variables and "quotes"
		<xml>tags</xml>
		Line with \ backslash
	end_agentsmd

	# Run the polyfill script
	local output
	output=$(CLAUDE_PROJECT_DIR="$project_dir" sh "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh")

	# Should preserve special characters
	echo "$output" | grep -q '`backticks`' &&
	echo "$output" | grep -q '\$variables' &&
	echo "$output" | grep -q '"quotes"' &&
	echo "$output" | grep -q '<xml>tags</xml>' &&
	echo "$output" | grep -q 'backslash'
}

test_empty_agentsmd_file() {
	local project_dir="$1"

	# Create an empty AGENTS.md
	touch "$project_dir/AGENTS.md"

	# Run the polyfill script
	local output
	output=$(CLAUDE_PROJECT_DIR="$project_dir" sh "$REPO_ROOT/.agents/polyfills/claude/agentsmd.sh")

	# Should still run successfully and include the file
	echo "$output" | grep -q "<available_agentsmd_files>" &&
	echo "$output" | grep -q "./AGENTS.md" &&
	echo "$output" | grep -q '<agentsmd path="./AGENTS.md">' &&
	echo "$output" | grep -q "</agentsmd>"
}

test_global_agentsmd_with_project_install() {
	local project_dir="$1"

	# Create a global ~/AGENTS.md
	local home_agentsmd_backup=""
	if [ -f "$HOME/AGENTS.md" ]; then
		home_agentsmd_backup=$(cat "$HOME/AGENTS.md")
	fi

	cat > "$HOME/AGENTS.md" <<-end_global
		# Global Instructions
		This should NOT appear when running from project install.
	end_global

	# Create a project AGENTS.md
	cat > "$project_dir/AGENTS.md" <<-end_project
		# Project Instructions
	end_project

	# Run from project install location (repo mode)
	local output
	output=$(run_polyfill_repo "$project_dir")

	local result=0
	# Should include project AGENTS.md
	echo "$output" | grep -q "# Project Instructions" || result=1
	# Should NOT include global AGENTS.md (not a global install)
	echo "$output" | grep -q "# Global Instructions" && result=1
	echo "$output" | grep -q '<agentsmd path="~/AGENTS.md">' && result=1

	# Restore backup
	if [ -n "$home_agentsmd_backup" ]; then
		echo "$home_agentsmd_backup" > "$HOME/AGENTS.md"
	else
		rm -f "$HOME/AGENTS.md"
	fi

	return $result
}

test_global_agentsmd_with_global_install() {
	local project_dir="$1"

	# Create a global ~/AGENTS.md
	local home_agentsmd_backup=""
	if [ -f "$HOME/AGENTS.md" ]; then
		home_agentsmd_backup=$(cat "$HOME/AGENTS.md")
	fi

	cat > "$HOME/AGENTS.md" <<-end_global
		# Global Instructions
		This should appear when running from global install.
	end_global

	# Create a project AGENTS.md
	cat > "$project_dir/AGENTS.md" <<-end_project
		# Project Instructions
	end_project

	# Run from global install location (global mode)
	local output
	output=$(run_polyfill_global "$project_dir")

	local result=0
	# Should include both global and project AGENTS.md
	echo "$output" | grep -q "# Global Instructions" || result=1
	echo "$output" | grep -q "# Project Instructions" || result=1
	echo "$output" | grep -q '<agentsmd path="~/AGENTS.md">' || result=1
	echo "$output" | grep -q '<agentsmd path="./AGENTS.md">' || result=1

	# Clean up
	cleanup_global_polyfill
	if [ -n "$home_agentsmd_backup" ]; then
		echo "$home_agentsmd_backup" > "$HOME/AGENTS.md"
	else
		rm -f "$HOME/AGENTS.md"
	fi

	return $result
}

test_global_agentsmd_only() {
	local project_dir="$1"

	# Create a global ~/AGENTS.md
	local home_agentsmd_backup=""
	if [ -f "$HOME/AGENTS.md" ]; then
		home_agentsmd_backup=$(cat "$HOME/AGENTS.md")
	fi

	cat > "$HOME/AGENTS.md" <<-end_global
		# Global Only
		No project-specific instructions.
	end_global

	# No project AGENTS.md - only global

	# Run from global install location (global mode)
	local output
	output=$(run_polyfill_global "$project_dir")

	local result=0
	# Should include global AGENTS.md
	echo "$output" | grep -q "# Global Only" || result=1
	echo "$output" | grep -q '<agentsmd path="~/AGENTS.md">' || result=1
	# Should NOT include project AGENTS.md content (doesn't exist)
	echo "$output" | grep -qF "The content of ./AGENTS.md is as follows:" && result=1 || true

	# Clean up
	cleanup_global_polyfill
	if [ -n "$home_agentsmd_backup" ]; then
		echo "$home_agentsmd_backup" > "$HOME/AGENTS.md"
	else
		rm -f "$HOME/AGENTS.md"
	fi

	return $result
}

test_precedence_hierarchy() {
	local project_dir="$1"

	# Create global, project root, and nested AGENTS.md files
	local home_agentsmd_backup=""
	if [ -f "$HOME/AGENTS.md" ]; then
		home_agentsmd_backup=$(cat "$HOME/AGENTS.md")
	fi

	cat > "$HOME/AGENTS.md" <<-end_global
		# Level 1: Global
	end_global

	cat > "$project_dir/AGENTS.md" <<-end_root
		# Level 2: Project Root
	end_root

	mkdir -p "$project_dir/subfolder"
	cat > "$project_dir/subfolder/AGENTS.md" <<-end_subfolder
		# Level 3: Subfolder
	end_subfolder

	# Run from global install location (global mode)
	local output
	output=$(run_polyfill_global "$project_dir")

	local result=0
	# Verify instructions mention the precedence hierarchy
	echo "$output" | grep -q "Precedence hierarchy" || result=1
	# Verify all levels are mentioned
	echo "$output" | grep -q "~/AGENTS.md (global" || result=1
	echo "$output" | grep -q "./AGENTS.md (project root" || result=1
	# Verify global and root are loaded (subfolder listed but not loaded)
	echo "$output" | grep -q "# Level 1: Global" || result=1
	echo "$output" | grep -q "# Level 2: Project Root" || result=1
	echo "$output" | grep -q "./subfolder/AGENTS.md" || result=1

	# Clean up
	cleanup_global_polyfill
	if [ -n "$home_agentsmd_backup" ]; then
		echo "$home_agentsmd_backup" > "$HOME/AGENTS.md"
	else
		rm -f "$HOME/AGENTS.md"
	fi

	return $result
}
