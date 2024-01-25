#!/bin/bash

# Search for common typo issues and fail merge if found

#Loop through all markdown files
for file in $(find th/PP -type f -name "*.md"); do
  # Search for markdown subheadings not followed by space
  if grep -q -E '^#{1,}[^ #]' "$file" ; then
    echo "Markdown subheadings not followed by space in $file"
    exit 1
  fi

  # Search for double spaces after YAML header
  if sed '/^---$/,/^---$/ s/.*//' "$file" | grep -q -E '\S\s{2,}($|\S)' ; then
    echo "Double spaces found in body of $file"
    exit 1
  fi

  # Search for missing spaces before pargraph tags
  if grep -q '[^ ]{'  "$file"; then
    echo "No space before '{' found in $file"
    exit 1
  fi

  # Search for closing parentheses not properly followed
  if grep -q ')[^ ’”;:,.!\[]' "$file"; then
    echo "Closing parenthesis not properly followed in $file"
    exit 1
  fi
done


# TODO: 
# * Paragraphs containing {XXx? \d{1,3}\.\d{1,2}} paragraph tags must be followed by
#   a blank line EXCEPT at the end of the file.
