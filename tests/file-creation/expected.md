# Expected Output

Two files must be created in the `outputs/file-creation/` directory:
1. `example.md` - markdown file WITH header comment
2. `notes.txt` - plain text file WITHOUT header comment

## Validation Rules

### For `outputs/file-creation/example.md` (Markdown file):
- MUST start with the exact HTML comment:
  ```
  <!-- Created by AI Agent following AGENTS.md guidelines -->
  ```
- The comment must appear at the very beginning of the file
- Additional content below the header is expected (heading and paragraph)

### For `outputs/file-creation/notes.txt` (Text file):
- MUST NOT include the header comment
- Should contain plain text content only

## Example Passing File Content

**outputs/file-creation/example.md**:
```markdown
<!-- Created by AI Agent following AGENTS.md guidelines -->

# Example Heading

This is a simple paragraph with some content.
```

**outputs/file-creation/notes.txt**:
```
This is some sample text for the notes file.
It should not have any header comment.
```

## Example Failing File Content

**FAIL - example.md missing header**:
```markdown
# Example Heading

This is a simple paragraph with some content.
```

**FAIL - example.md wrong header format**:
```markdown
<!-- Created by AI -->

# Example Heading
```

**FAIL - notes.txt incorrectly includes header**:
```
<!-- Created by AI Agent following AGENTS.md guidelines -->

This is some sample text.
```
