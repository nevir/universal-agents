#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TESTS_DIR="$REPO_ROOT/tests"

cd "$REPO_ROOT"

KNOWN_AGENTS="claude gemini aider cursor"

# ============================================
# Colors
# ============================================

color_red='\033[0;31m'
color_green='\033[0;32m'
color_yellow='\033[0;33m'
color_blue='\033[0;34m'
color_purple='\033[0;35m'
color_cyan='\033[0;36m'
color_bold='\033[1m'
color_reset='\033[0m'

# Semantic colors
color_error="$color_red"
color_success="$color_green"
color_warning="$color_yellow"
color_agent="$color_cyan"
color_test="$color_yellow"
color_command="$color_purple"
color_heading="$color_bold"

c() {
	local color_name="$1"; shift
	local text="$*"
	local var_name
	local color_code

	var_name="color_$color_name"
	eval "color_code=\$$var_name"

	printf "%s%s%s" "$color_code" "$text" "$color_reset"
}

c_list() {
	local color_type="$1"
	shift
	local result=""
	local first=1

	for item in "$@"; do
		[ $first -eq 0 ] && result="$result, "
		result="$result$(c "$color_type" "$item")"
		first=0
	done

	echo "$result"
}

# ============================================
# Utilities
# ============================================

trim() {
	local var="$1"
	var="${var#"${var%%[![:space:]]*}"}"
	var="${var%"${var##*[![:space:]]}"}"
	echo "$var"
}

indent() {
	local spaces="$1"
	local text="$2"
	echo "$text" | while IFS= read -r line; do
		printf "%${spaces}s%s\n" "" "$line"
	done
}

panic() {
	local exit_code="$1"
	shift
	local show_usage=0
	local message

	if [ "$1" = "show_usage" ]; then
		show_usage=1
		shift
	fi

	if [ $# -gt 0 ]; then
		message="$*"
	else
		message=$(cat)
	fi

	printf "\n$(c error Error:) $(trim "$message")\n" >&2

	if [ "$show_usage" -eq 1 ]; then
		printf "\n$(usage)\n" >&2
	fi

	printf "\n" >&2
	exit "$exit_code"
}

# ============================================
# Discovery
# ============================================

discover_agents() {
	agents=""
	for agent in $KNOWN_AGENTS; do
		if command -v "$agent" >/dev/null 2>&1; then
			agents="$agents $agent"
		fi
	done
	echo "$agents"
}

discover_tests() {
	tests=""
	for test_dir in "$TESTS_DIR"/*/; do
		test_name="$(basename "$test_dir")"
		case "$test_name" in
			_*|.*) continue ;;
			*) tests="$tests $test_name" ;;
		esac
	done
	echo "$tests"
}

# ============================================
# Test execution
# ============================================

run_test() {
	local agent="$1"
	local test_name="$2"
	local test_dir="$TESTS_DIR/$test_name"
	local sandbox_dir="$test_dir/sandbox"

	if [ ! -f "$test_dir/prompt.md" ]; then
		panic 2 "$test_dir/prompt.md not found"
	fi
	if [ ! -f "$test_dir/expected.md" ]; then
		panic 2 "$test_dir/expected.md not found"
	fi

	# Set up sandbox before running test
	mkdir -p "$sandbox_dir"
	git clean -fdx "$sandbox_dir" >/dev/null 2>&1

	cd "$sandbox_dir"

	"$REPO_ROOT/install.sh" -y > /dev/null 2>&1

	prompt=$(cat "$test_dir/prompt.md")
	expected=$(cat "$test_dir/expected.md")
	expected=$(trim "$expected")

	# Run agent from within sandbox directory
	case "$agent" in
		claude)
			output=$(echo "$prompt" | claude --print 2>/dev/null)
			;;
		gemini)
			output=$(echo "$prompt" | gemini 2>/dev/null)
			;;
		*)
			output=$(echo "$prompt" | "$agent" 2>/dev/null)
			;;
	esac

	output=$(trim "$output")

	if [ "$output" = "$expected" ]; then
		return 0
	else
		TEST_EXPECTED="$expected"
		TEST_GOT="$output"
		return 1
	fi
}

display_result() {
	local test_name="$1"
	local result="$2"

	if [ "$result" -eq 0 ]; then
		printf "$(c success ✓) $(c test $test_name)\n"

		if [ "$VERBOSE" -eq 1 ]; then
			printf "    Expected:\n"
			indent 6 "$TEST_EXPECTED"
			printf "    Got:\n"
			indent 6 "$TEST_GOT"
		fi
	else
		printf "$(c error ✗) $(c test $test_name)\n"
		printf "    Expected:\n"
		indent 6 "$TEST_EXPECTED"
		printf "    Got:\n"
		indent 6 "$TEST_GOT"
	fi
}

# ============================================
# Usage and help
# ============================================

usage() {
	printf "$(c heading Usage:) $(c command test.sh) $(c agent [AGENT]) $(c test [TEST])"
}

show_help() {
	printf "\n"
	printf "$(usage)\n\n"
	printf "Test runner for AGENTS.md polyfill configuration.\n\n"

	printf "$(c heading Arguments:)\n"
	printf "  $(c agent AGENT)    Agent to test: $(c_list agent $KNOWN_AGENTS), $(c agent all) (default: $(c agent all))\n"
	printf "  $(c test TEST)     Test to run (default: $(c test all))\n\n"

	printf "If one argument is provided, it will be interpreted as either an agent\n"
	printf "name or test name based on available agents and tests.\n\n"

	printf "$(c heading Examples:)\n"
	printf "  $(c command test.sh)                    # Run all tests on all agents\n"
	printf "  $(c command test.sh) $(c agent claude)             # Run all tests on claude\n"
	printf "  $(c command test.sh) $(c test basic-load)         # Run basic-load on all agents\n"
	printf "  $(c command test.sh) $(c agent claude) $(c test basic-load)  # Run basic-load on claude only\n\n"

	printf "$(c heading Options:)\n"
	printf "  -h, --help    Show this help message\n"
	printf "  -v, --verbose Show full output for all tests\n\n"

	printf "$(c heading Agents:)\n"
	for agent in $KNOWN_AGENTS; do
		if command -v "$agent" >/dev/null 2>&1; then
			printf "  $(c agent %-8s) $(c success ✓ available)\n" "$agent"
		else
			printf "  $(c agent %-8s) $(c error ✗ not found)\n" "$agent"
		fi
	done

	printf "\n$(c heading Tests:)\n"
	for test in $(discover_tests); do
		printf "  $(c test "$test")\n"
	done

	printf "\n$(c heading Exit codes:)\n"
	printf "  0    All tests passed\n"
	printf "  1    One or more tests failed\n"
	printf "  2    Invalid arguments or configuration error\n"
	printf "\n"
}

# ============================================
# Main
# ============================================

main() {
	# Parse arguments
	local verbose=0
	local agent_filter=""
	local test_filter=""

	while [ $# -gt 0 ]; do
		case "$1" in
			-h|--help)
				show_help
				exit 0
				;;
			-v|--verbose)
				verbose=1
				shift
				;;
			*)
				if [ -z "$agent_filter" ]; then
					agent_filter="$1"
				elif [ -z "$test_filter" ]; then
					test_filter="$1"
				else
					panic 2 show_usage "Too many arguments"
				fi
				shift
				;;
		esac
	done

	# Export for use in run_test
	VERBOSE=$verbose

	# Discover available agents and tests
	local available_agents=$(discover_agents)
	local available_tests=$(discover_tests)

	if [ -z "$available_agents" ]; then
		panic 2 <<-end_panic
			No agents found
			Available agents: $(c_list agent $KNOWN_AGENTS)
		end_panic
	fi

	if [ -z "$available_tests" ]; then
		panic 2 "No tests found"
	fi

	# Disambiguate single argument (agent or test?)
	if [ -n "$agent_filter" ] && [ -z "$test_filter" ]; then
		local is_agent=0
		for agent in $available_agents; do
			if [ "$agent" = "$agent_filter" ]; then
				is_agent=1
				break
			fi
		done

		local is_test=0
		for test in $available_tests; do
			if [ "$test" = "$agent_filter" ]; then
				is_test=1
				break
			fi
		done

		if [ "$is_test" -eq 1 ] && [ "$is_agent" -eq 0 ]; then
			test_filter="$agent_filter"
			agent_filter=""
		fi
	fi

	# Determine agents to run
	local agents_to_run
	if [ -z "$agent_filter" ] || [ "$agent_filter" = "all" ]; then
		agents_to_run="$available_agents"
	else
		local found=0
		for agent in $available_agents; do
			if [ "$agent" = "$agent_filter" ]; then
				found=1
				break
			fi
		done

		if [ "$found" -eq 0 ]; then
			panic 2 show_usage <<-end_panic
				Agent $(c agent "'$agent_filter'") not found or not executable.
				Available agents: $(c_list agent $available_agents)
			end_panic
		fi

		agents_to_run="$agent_filter"
	fi

	# Determine tests to run
	local tests_to_run
	if [ -z "$test_filter" ] || [ "$test_filter" = "all" ]; then
		tests_to_run="$available_tests"
	else
		local found=0
		for test in $available_tests; do
			if [ "$test" = "$test_filter" ]; then
				found=1
				break
			fi
		done

		if [ "$found" -eq 0 ]; then
			panic 2 show_usage <<-end_panic
				Test $(c test "'$test_filter'") not found.
				Available tests: $(c_list test $available_tests)
			end_panic
		fi

		tests_to_run="$test_filter"
	fi

	# Count agents
	local agent_count=0
	for agent in $agents_to_run; do
		agent_count=$((agent_count + 1))
	done

	# Run tests
	local total_passed=0
	local total_failed=0

	printf "\n"

	for agent in $agents_to_run; do
		printf "$(c blue ===) $(c agent $agent) $(c blue ===)\n"

		local passed=0
		local failed=0

		for test_name in $tests_to_run; do
			printf "\r◌ $(c test $test_name)"

			if run_test "$agent" "$test_name"; then
				passed=$((passed + 1))
				total_passed=$((total_passed + 1))
				result=0
			else
				failed=$((failed + 1))
				total_failed=$((total_failed + 1))
				result=1
			fi

			printf "\r"
			display_result "$test_name" "$result"
		done

		eval "agent_passed_$agent=$passed"
		eval "agent_total_$agent=$((passed + failed))"

		printf "\n"
	done

	# Display summary
	local total=$((total_passed + total_failed))

	if [ "$total_passed" -eq "$total" ]; then
		printf "$(c success %d/%d passed)\n" "$total_passed" "$total"
	else
		printf "$(c error %d/%d passed)\n" "$total_passed" "$total"
	fi

	if [ "$agent_count" -gt 1 ]; then
		for agent in $agents_to_run; do
			eval "passed=\$agent_passed_$agent"
			eval "total_tests=\$agent_total_$agent"
			if [ "$passed" -eq "$total_tests" ]; then
				printf "$(c agent $agent): $(c success $passed/$total_tests)\n"
			else
				printf "$(c agent $agent): $(c error $passed/$total_tests)\n"
			fi
		done
	fi

	printf "\n"

	# Exit with appropriate code
	if [ "$total_failed" -gt 0 ]; then
		exit 1
	else
		exit 0
	fi
}

main "$@"
