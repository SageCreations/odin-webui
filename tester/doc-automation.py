#!/usr/bin/env python3

import sys
import os
from pprint import pprint

def parse_test_file(test_file, key_prefix, example_prefix, example_suffix):
    """
    Parse a test file to extract key-value pairs.

    This function scans the specified test file line by line to locate lines
    containing the given `key_prefix`. Such lines are treated as keys (with an
    optional removal of leading `// `), and the subsequent content enclosed by
    `example_prefix` and `example_suffix` is captured as a multiline string value.

    Args:
        test_file (str):
            The file path to the test file to read.
        key_prefix (str):
            The prefix that identifies a key line (e.g., "###").
        example_prefix (str):
            The token that marks the beginning of the example code block
            (e.g., "example :: `").
        example_suffix (str):
            The token that marks the end of the example code block (e.g., "`").

    Returns:
        dict:
            A dictionary where each key is the full line containing `key_prefix`
            (after removing leading `// ` if present), and each value is the
            corresponding code block content as a single multiline string.

    Example:
        If the test file contains:

            // ### get_new_window_id
            example :: `
            ui.show(my_window, "index.html")
            `

        This function will produce a dictionary like:

            {
                "### get_new_window_id": "ui.show(my_window, \"index.html\")"
            }
    """
    data = {}

    with open(test_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].rstrip('\n')

        # Look for the key prefix in the current line
        if key_prefix in line:
            # First, remove any leading "// " if present, but keep the "### " portion
            line_stripped = line.strip()
            if line_stripped.startswith("// "):
                # remove the leading "// "
                line_stripped = line_stripped[3:].strip()

            # Now line_stripped should be something like "### get_new_window_id"
            # We'll store that whole thing as our dict key
            key_part = line_stripped

            # Move to the next lines to look for example_prefix
            i += 1
            while i < len(lines):
                line_candidate = lines[i].rstrip('\n')

                if example_prefix in line_candidate:
                    # Found the start of the example block
                    example_lines = []
                    i += 1

                    # Collect lines until we find example_suffix
                    while i < len(lines):
                        if example_suffix in lines[i]:
                            # Once we hit the suffix, stop collecting
                            break
                        example_lines.append(lines[i].rstrip('\n'))
                        i += 1

                    # Join all example lines into a single string
                    example_code = '\n'.join(example_lines)

                    # Store the key and the example code in our dictionary
                    data[key_part] = example_code

                    # Done capturing code for this key; break out of this inner while
                    break
                i += 1
        else:
            i += 1

    return data

def update_readme(readme_file, block_prefix, block_suffix, parsed_data):
    """
    Update a README file in-place by replacing code blocks for each matching key.

    This function processes a README line by line, searching for each key from
    `parsed_data`. When a line containing the key is found, subsequent lines are
    scanned until the first occurrence of `block_prefix`. From there, all content
    is skipped until the occurrence of `block_suffix`. The function then inserts
    the new code block (from `parsed_data`) before re-inserting the suffix line,
    effectively replacing old content with updated examples.

    Args:
        readme_file (str):
            The path to the README file to be updated.
        block_prefix (str):
            The token indicating the start of a code block in the README
            (e.g., a line with triple backticks ```` ``` ````).
        block_suffix (str):
            The token indicating the end of a code block in the README
            (e.g., a matching line with triple backticks).
        parsed_data (dict):
            A dictionary mapping keys (e.g., "### get_new_window_id") to
            the updated code block strings that should be inserted in place
            of the existing code block.

    Returns:
        None. The function modifies the README file in-place.

    Raises:
        FileNotFoundError: If the specified `readme_file` does not exist.

    Example:
        Suppose `parsed_data` is:
            {
                "### get_new_window_id": "ui.show(my_window, \"index.html\")"
            }
        and the README has a section like:

            ### get_new_window_id
            ```odin
            // old code...
            ```

        After this function runs, the old code within that code block will
        be replaced by "ui.show(my_window, \"index.html\")" before the
        closing triple backticks.
    """
    if not os.path.isfile(readme_file):
        print(f"ERROR: README file '{readme_file}' not found.")
        return

    with open(readme_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    new_lines = []
    i = 0
    # We'll keep track of which keys have already been processed, so we don't re-insert multiple times
    used_keys = set()

    while i < len(lines):
        line = lines[i]

        # 1) Check if this line contains any key from parsed_data
        matched_key = None
        for key in parsed_data:
            if key in line and key not in used_keys:
                matched_key = key
                break

        if matched_key is not None:
            # Mark this key as used to avoid multiple replacements if the key appears again
            used_keys.add(matched_key)

            # Keep this line that contains the key
            new_lines.append(line)
            i += 1

            # 2) Continue until we find block_prefix
            while i < len(lines) and block_prefix not in lines[i]:
                new_lines.append(lines[i])
                i += 1

            # If we've reached the file end or found block_prefix
            if i < len(lines) and block_prefix in lines[i]:
                # Keep (or remove) the block_prefix line, depending on your preference.
                # Here we choose to keep it:
                new_lines.append(lines[i])
                i += 1

                # 3) Skip lines until we find block_suffix
                while i < len(lines) and block_suffix not in lines[i]:
                    i += 1

                # 4) Insert the new code
                new_lines.append(parsed_data[matched_key] + "\n")

                # 5) Re-insert the block_suffix line, if it exists
                if i < len(lines):
                    new_lines.append(lines[i])  # This should be the block_suffix line
                i += 1

            # Move on to the next iteration
            continue

        else:
            # If no key matched, just copy this line
            new_lines.append(line)
            i += 1

    with open(readme_file, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)


def main():
    """
    Provide a command-line entry point for the script, parsing arguments and
    orchestrating the parse-and-update process.

    Usage:
        python script.py <test_file> <readme_file>

    This function:
      1) Reads the command-line arguments to identify the test file and
         README file paths.
      2) Parses the test file to extract code blocks into a dictionary
         via `parse_test_file(...)`.
      3) Updates the specified README in-place by replacing old code blocks
         with the newly parsed data via `update_readme(...)`.

    The recognized markers and tokens (e.g., `key_prefix`, `example_prefix`,
    `example_suffix`, `block_prefix`, `block_suffix`) should be adjusted as
    needed to match your project’s structure.

    Args:
        None. Arguments are taken from `sys.argv`.

    Raises:
        SystemExit: If insufficient arguments are provided.

    Example:
        Suppose you have:
            test_file = "tests/my_test.odin"
            readme_file = "README.md"
        You can run:
            python script.py tests/my_test.odin README.md

        This will parse `tests/my_test.odin` for keys and associated
        code blocks, then replace matching sections in `README.md`.
    """
    if len(sys.argv) < 3:
        print("Usage: python script.py <test_file> <readme_file>")
        sys.exit(1)

    test_file_path = sys.argv[1]
    readme_file_path = sys.argv[2]

    # Define your custom markers/tokens here
    key_prefix       = "// ### "       # lines like "// ### get_new_window_id"
    example_prefix   = "example :: `"  # start of code block
    example_suffix   = "`"             # end of code block

    # For the README updating:
    block_prefix     = "```odin"       # e.g. if you want to match "### get_new_window_id" exactly
    block_suffix     = "```"           # or some other delimiter in your README

    # 1) Parse the test file and get a dictionary of { key: code }
    parsed_data = parse_test_file(
        test_file=test_file_path,
        key_prefix=key_prefix,
        example_prefix=example_prefix,
        example_suffix=example_suffix
    )

    pprint(parsed_data)

    # 2) Update the README
    update_readme(
        readme_file=readme_file_path,
        block_prefix=block_prefix,
        block_suffix=block_suffix,
        parsed_data=parsed_data
    )

if __name__ == "__main__":
    main()
