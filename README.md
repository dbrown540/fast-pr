# Fast-PR

A fast and convenient Bash script for automating the git workflow of committing changes, rebasing onto main, and creating pull requests.

## Overview

This script streamlines your git workflow by automating several common steps:

1. Stages all changes
2. Commits with a provided message
3. Fetches the latest main branch
4. Rebases your branch onto main
5. Force pushes with lease (safely)
6. Creates a pull request using GitHub CLI

## Prerequisites

- Git installed and configured
- [GitHub CLI](https://cli.github.com/) installed and authenticated
- Working on a feature branch (not main)

## Installation

1. Save the script as `fast-pr.sh` in your repository
2. Make it executable:

```bash
chmod +x fast-pr.sh
```

## Usage

```bash
./fast-pr.sh --message "Your commit message" --title "Your PR title"
```

Or using short options:

```bash
./fast-pr.sh -m "Your commit message" -t "Your PR title"
```

### Parameters

- `-m, --message`: (Required) The commit message
- `-t, --title`: (Optional) The PR title. If not provided, the commit message will be used as the PR title

## Safety Features

- Prevents running on the main branch
- Uses `--force-with-lease` instead of `--force` for safer force pushing
- Verifies that a commit message is provided

## Example

```bash
./fast-pr.sh -m "Fix navigation bug" -t "Navigation: Fix dropdown menu disappearing on hover"
```

## Notes

- This script stages ALL changes in your working directory
- The PR is created with a minimal auto-generated body containing your commit message
- You can modify the script to customize the PR body or add labels if needed