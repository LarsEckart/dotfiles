#!/usr/bin/env bash
set -euo pipefail

# Sync shared skills to all agent skill directories
# 1. Clones/pulls external repos from repos.txt
# 2. Creates symlinks from each agent's skill location to skills here

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_FILE="$SCRIPT_DIR/repos.txt"
REPOS_DIR="$SCRIPT_DIR/.repos"

# Target directories for each agent
CLAUDE_SKILLS="$HOME/.claude/skills"
CODEX_SKILLS="$HOME/.codex/skills"
PI_SKILLS="$HOME/.pi/agent/skills"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }
log_section() { echo -e "\n${BLUE}===${NC} $1 ${BLUE}===${NC}"; }

# Clone or pull external repositories
sync_repos() {
    if [[ ! -f "$REPOS_FILE" ]]; then
        log_warn "No repos.txt found, skipping external repos"
        return
    fi

    log_section "Syncing external repositories"
    mkdir -p "$REPOS_DIR"

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        
        # First word is URL, rest are skill paths (optional)
        local repo_url skill_paths repo_name repo_path
        repo_url="$(echo "$line" | awk '{print $1}')"
        skill_paths="$(echo "$line" | awk '{$1=""; print $0}' | xargs)"
        repo_name="$(basename "$repo_url" .git)"
        repo_path="$REPOS_DIR/$repo_name"

        if [[ -d "$repo_path/.git" ]]; then
            echo "Updating $repo_name..."
            if git -C "$repo_path" pull --ff-only --quiet 2>/dev/null; then
                log_info "$repo_name (updated)"
            else
                log_warn "$repo_name (pull failed, trying reset)"
                git -C "$repo_path" fetch --quiet
                git -C "$repo_path" reset --hard origin/HEAD --quiet
                log_info "$repo_name (reset to origin)"
            fi
        elif [[ -n "$skill_paths" ]]; then
            # Sparse checkout for specific paths only
            echo "Cloning $repo_name (sparse: $skill_paths)..."
            if git clone --filter=blob:none --no-checkout --quiet "$repo_url" "$repo_path" 2>/dev/null; then
                git -C "$repo_path" sparse-checkout init --cone
                # shellcheck disable=SC2086
                git -C "$repo_path" sparse-checkout set $skill_paths
                git -C "$repo_path" checkout --quiet
                log_info "$repo_name (sparse clone)"
            else
                log_error "$repo_name (clone failed)"
            fi
        else
            echo "Cloning $repo_name..."
            if git clone --quiet "$repo_url" "$repo_path" 2>/dev/null; then
                log_info "$repo_name (cloned)"
            else
                log_error "$repo_name (clone failed)"
            fi
        fi
    done < "$REPOS_FILE"
}

# Parse repos.txt and store skill filters
declare -A REPO_FILTERS

parse_repos_file() {
    [[ ! -f "$REPOS_FILE" ]] && return
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        
        # First word is URL, rest are skill paths (optional)
        local url paths repo_name
        url="$(echo "$line" | awk '{print $1}')"
        paths="$(echo "$line" | awk '{$1=""; print $0}' | xargs)"
        repo_name="$(basename "$url" .git)"
        
        if [[ -n "$paths" ]]; then
            REPO_FILTERS[$repo_name]="$paths"
        fi
    done < "$REPOS_FILE"
}

# Find all skill directories (contain SKILL.md)
find_skills() {
    # Find local skills (direct children only)
    find "$SCRIPT_DIR" -maxdepth 2 -name "SKILL.md" -not -path "*/.repos/*" -exec dirname {} \; 2>/dev/null
    
    # Find skills in cloned repos
    if [[ -d "$REPOS_DIR" ]]; then
        for repo_path in "$REPOS_DIR"/*/; do
            [[ ! -d "$repo_path" ]] && continue
            local repo_name
            repo_name="$(basename "$repo_path")"
            
            if [[ -n "${REPO_FILTERS[$repo_name]:-}" ]]; then
                # Only include specified skill paths
                for skill_path in ${REPO_FILTERS[$repo_name]}; do
                    local full_path="$repo_path$skill_path"
                    if [[ -f "$full_path/SKILL.md" ]]; then
                        echo "$full_path"
                    fi
                done
            else
                # Include all skills from this repo
                find "$repo_path" -name "SKILL.md" -exec dirname {} \; 2>/dev/null
            fi
        done
    fi
}

# Create symlinks for a target directory
sync_to_target() {
    local target_dir="$1"
    local agent_name="$2"
    local -a skill_list=("${@:3}")
    
    mkdir -p "$target_dir"
    
    log_section "Syncing to $agent_name (symlinks)"
    echo "Target: $target_dir"
    
    # Build set of valid skill names from skill_list
    declare -A valid_skills
    for skill_path in "${skill_list[@]}"; do
        [[ -z "$skill_path" ]] && continue
        valid_skills["$(basename "$skill_path")"]=1
    done
    
    # Track which skill names we've seen (to handle duplicates)
    declare -A seen_skills
    
    # Remove stale symlinks
    for link in "$target_dir"/*; do
        [[ -e "$link" || -L "$link" ]] || continue
        
        if [[ -L "$link" ]]; then
            local link_target link_name
            link_target="$(readlink "$link")"
            link_name="$(basename "$link")"
            
            # Remove if target doesn't exist
            if [[ ! -e "$link" ]]; then
                log_warn "Removing stale link: $link_name"
                rm "$link"
            # Remove if it points into our directory but is not in valid skills
            elif [[ "$link_target" == "$SCRIPT_DIR"* ]] && [[ -z "${valid_skills[$link_name]:-}" ]]; then
                log_warn "Removing filtered link: $link_name"
                rm "$link"
            fi
        fi
    done
    
    # Create symlinks for each skill
    for skill_path in "${skill_list[@]}"; do
        [[ -z "$skill_path" ]] && continue
        
        local skill_name
        skill_name="$(basename "$skill_path")"
        local link_path="$target_dir/$skill_name"
        
        # Skip duplicates (first one wins)
        if [[ -n "${seen_skills[$skill_name]:-}" ]]; then
            log_warn "$skill_name (duplicate, skipping - already from ${seen_skills[$skill_name]})"
            continue
        fi
        seen_skills[$skill_name]="$skill_path"
        
        if [[ -L "$link_path" ]]; then
            local existing_target
            existing_target="$(readlink "$link_path")"
            if [[ "$existing_target" == "$skill_path" ]]; then
                log_info "$skill_name (already linked)"
            else
                rm "$link_path"
                ln -s "$skill_path" "$link_path"
                log_info "$skill_name (updated)"
            fi
        elif [[ -e "$link_path" ]]; then
            log_error "$skill_name: target exists and is not a symlink, skipping"
        else
            ln -s "$skill_path" "$link_path"
            log_info "$skill_name (created)"
        fi
    done
}

# Copy skills to target directory (for agents that don't support symlinks)
copy_to_target() {
    local target_dir="$1"
    local agent_name="$2"
    local -a skill_list=("${@:3}")
    
    mkdir -p "$target_dir"
    
    log_section "Syncing to $agent_name (copying)"
    echo "Target: $target_dir"
    
    # Build set of valid skill names from skill_list
    declare -A valid_skills
    for skill_path in "${skill_list[@]}"; do
        [[ -z "$skill_path" ]] && continue
        valid_skills["$(basename "$skill_path")"]=1
    done
    
    # Track which skill names we've seen (to handle duplicates)
    declare -A seen_skills
    
    # Remove stale/outdated copied skills (but preserve .system and other non-managed dirs)
    for existing in "$target_dir"/*; do
        [[ -e "$existing" ]] || continue
        [[ -d "$existing" ]] || continue
        
        local dir_name
        dir_name="$(basename "$existing")"
        
        # Skip hidden directories like .system
        [[ "$dir_name" == .* ]] && continue
        
        # Remove if not in valid skills
        if [[ -z "${valid_skills[$dir_name]:-}" ]]; then
            log_warn "Removing stale copy: $dir_name"
            rm -rf "$existing"
        fi
    done
    
    # Copy each skill
    for skill_path in "${skill_list[@]}"; do
        [[ -z "$skill_path" ]] && continue
        
        local skill_name
        skill_name="$(basename "$skill_path")"
        local copy_path="$target_dir/$skill_name"
        
        # Skip duplicates (first one wins)
        if [[ -n "${seen_skills[$skill_name]:-}" ]]; then
            log_warn "$skill_name (duplicate, skipping - already from ${seen_skills[$skill_name]})"
            continue
        fi
        seen_skills[$skill_name]="$skill_path"
        
        if [[ -d "$copy_path" ]]; then
            # Check if source is newer than copy
            local source_mtime copy_mtime
            source_mtime="$(find "$skill_path" -type f -exec stat -f %m {} \; 2>/dev/null | sort -rn | head -1)"
            copy_mtime="$(find "$copy_path" -type f -exec stat -f %m {} \; 2>/dev/null | sort -rn | head -1)"
            
            if [[ "${source_mtime:-0}" -gt "${copy_mtime:-0}" ]]; then
                rm -rf "$copy_path"
                cp -R "$skill_path" "$copy_path"
                log_info "$skill_name (updated)"
            else
                log_info "$skill_name (up to date)"
            fi
        else
            cp -R "$skill_path" "$copy_path"
            log_info "$skill_name (copied)"
        fi
    done
}

main() {
    echo "=== Agent Skills Sync ==="
    echo "Source: $SCRIPT_DIR"
    
    # Parse repo filters first
    parse_repos_file
    
    # Sync external repos
    sync_repos
    
    # Find all skills
    log_section "Discovering skills"
    local skills
    skills="$(find_skills | sort)"
    
    if [[ -z "$skills" ]]; then
        log_error "No skills found"
        exit 1
    fi
    
    echo "Found skills:"
    echo "$skills" | while read -r s; do
        local name=$(basename "$s")
        local source=""
        if [[ "$s" == "$REPOS_DIR"* ]]; then
            local repo=$(echo "$s" | sed "s|$REPOS_DIR/||" | cut -d'/' -f1)
            source=" (from $repo)"
        fi
        echo "  - $name$source"
    done
    
    # Convert skills to array
    local -a skills_array
    mapfile -t skills_array <<< "$skills"
    
    # Sync to each agent
    sync_to_target "$CLAUDE_SKILLS" "Claude Code" "${skills_array[@]}"
    copy_to_target "$CODEX_SKILLS" "Codex" "${skills_array[@]}"  # Codex doesn't support symlinks
    sync_to_target "$PI_SKILLS" "Pi" "${skills_array[@]}"
    
    echo ""
    echo "=== Sync complete ==="
}

main "$@"
