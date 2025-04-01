#!/bin/bash
set -e
# Parse arguments

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--message) COMMIT_MSG="$2"; shift;;
        -t|--title) TITLE="$2"; shift;;
        *) echo "Unknown parameter passed: $1."; exit 1;;
    esac
    shift
done

BRANCH=$(git branch --show-current)

if [ -z "$COMMIT_MSG" ]; then
    echo "❌ Commit message required."
    echo "Usage: ./git-pr.sh --message|-m \"Your commit message\" --title|-t \"Your PR Title\""
    exit 1
fi

if [ "$BRANCH" = "main" ]; then
    echo "🛑 Current branch is '$BRANCH'. This script only works on feature branches."
    exit 1
fi

if [ -z "$TITLE" ]; then
    echo "No title provided..."
    echo "Defaulting title to commit message: $COMMIT_MSG"
    TITLE="$COMMIT_MSG"
fi

echo "🚀 Staging all changes..."
git add .

echo "✅ Committing with message: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

echo "📥 Fetching latest origin/main..."
git fetch origin

echo "🔁 Rebasing onto origin/main..."
git rebase origin/main

echo "📤 Pushing with --force-with-lease..."
git push --force-with-lease

echo "✨ Creating pull request with gh..."
gh pr create --base main --title "$TITLE" --body "Auto-generated PR: $COMMIT_MSG"+