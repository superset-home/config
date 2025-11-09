#!/bin/zsh

# Smart directory navigation for monorepo packages
# Usage: nav [partial_directory_name] | nav r (for root)
function nav() {
    local search_term="$1"
    local monorepo_root
    local matching_dirs
    local selected_dir

    # Set the monorepo root
    monorepo_root="$HOME/code/monorepo"
    if [[ ! -d "$monorepo_root" ]]; then
        echo "Error: Monorepo directory not found at $monorepo_root"
        return 1
    fi

    # Handle root navigation
    if [[ "$search_term" == "r" ]]; then
        cd "$monorepo_root"
        echo "Navigated to monorepo root: $(pwd)"
        return 0
    fi

    # Find all directories with package.json, limiting search depth and excluding cache directories
    # Most monorepos have packages within 3-4 levels, so -maxdepth 5 should be sufficient
    matching_dirs=$(find "$monorepo_root" -maxdepth 3 -name "package.json" -type f \
        -not -path "*/node_modules/*" \
        -not -path "*/.next/*" \
        -not -path "*/dist/*" \
        -not -path "*/build/*" \
        -not -path "*/.cache/*" \
        -not -path "*/coverage/*" \
        -not -path "*/.nyc_output/*" \
        -exec dirname {} \; | sort)

    if [[ -z "$matching_dirs" ]]; then
        echo "No directories with package.json found in the monorepo."
        return 1
    fi

    # Convert absolute paths to relative paths for display and matching
    local relative_dirs=$(echo "$matching_dirs" | sed 's|'"$monorepo_root"'/||g')

    # If no search term provided, show all options with fzf
    if [[ -z "$search_term" ]]; then
        if command -v fzf >/dev/null 2>&1; then
            local selected_relative=$(echo "$relative_dirs" | fzf --height=40% --reverse --prompt="Select directory: ")
            if [[ -n "$selected_relative" ]]; then
                selected_dir="$monorepo_root/$selected_relative"
            fi
        else
            echo "Available directories:"
            echo "$relative_dirs" | nl
            echo
            echo "Please provide a search term or install fzf for interactive selection."
            return 1
        fi
    else
        # Filter directories based on search term (case-insensitive) using relative paths
        local filtered_relative=$(echo "$relative_dirs" | grep -i "$search_term")

        if [[ -z "$filtered_relative" ]]; then
            echo "No directories found matching: $search_term"
            return 1
        fi

        local match_count=$(echo "$filtered_relative" | wc -l | tr -d ' ')

        if [[ "$match_count" -eq 1 ]]; then
            # Single match - navigate directly
            selected_dir="$monorepo_root/$filtered_relative"
        else
            # Multiple matches - use fuzzy finder if available
            if command -v fzf >/dev/null 2>&1; then
                local selected_relative=$(echo "$filtered_relative" | fzf --height=40% --reverse --prompt="Select directory: " --query="$search_term")
                if [[ -n "$selected_relative" ]]; then
                    selected_dir="$monorepo_root/$selected_relative"
                fi
            else
                echo "Multiple matches found for '$search_term':"
                echo "$filtered_relative" | nl
                echo
                echo "Please be more specific or install fzf for interactive selection."
                return 1
            fi
        fi
    fi

    # Navigate to selected directory
    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir"
        echo "Navigated to: $(echo "$selected_dir" | sed 's|'"$monorepo_root"'/||g')"

        # Show some useful info about the package
        if [[ -f "package.json" ]]; then
            local package_name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | cut -d'"' -f4)
            if [[ -n "$package_name" ]]; then
                echo "Package: $package_name"
            fi
        fi
    fi
}

# Completion function for the nav command
function _nav_completion() {
    local monorepo_root="$HOME/code/monorepo"
    local dirs

    if [[ ! -d "$monorepo_root" ]]; then
        return 1
    fi

    # Get directory names (relative to monorepo root) for completion
    dirs=$(find "$monorepo_root" -maxdepth 5 -name "package.json" -type f \
        -not -path "*/node_modules/*" \
        -not -path "*/.next/*" \
        -not -path "*/dist/*" \
        -not -path "*/build/*" \
        -not -path "*/.cache/*" \
        -not -path "*/coverage/*" \
        -not -path "*/.nyc_output/*" \
        -exec dirname {} \; | sed 's|'"$monorepo_root"'/||g' | sed 's|^./||g' | sort)

    # Generate completions based on directory names
    local -a suggestions
    suggestions+=("r")  # Add root option
    while IFS= read -r dir; do
        suggestions+=("$dir")
        # Also add just the basename for easier completion
        suggestions+=("$(basename "$dir")")
    done <<< "$dirs"

    # Remove duplicates and provide completions
    printf '%s\n' "${suggestions[@]}" | sort -u
}

# Set up completion
compdef _nav_completion nav

# Optional: Add an alias for even shorter usage
alias gt='nav'
