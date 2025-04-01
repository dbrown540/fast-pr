#!/bin/bash
set -e

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--message) COMMIT_MSG="$2"; shift ;;
        -t|--title) TITLE="$2"; shift ;;
        *) echo "Unknown parameter passed: $1."; exit 1 ;;
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

write_pr() {
    echo "📥 Fetching latest origin/main..."
    git fetch origin

    echo "🔁 Rebasing onto origin/main..."
    git rebase origin/main

    echo "📤 Pushing with --force-with-lease..."
    git push --force-with-lease

    echo "✨ Creating pull request with gh..."
    gh pr create --base main --title "$TITLE" --body "Auto-generated PR: $COMMIT_MSG"
}

echo "🚀 Staging all changes..."
git add .

echo "✅ Committing with message: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

# Check to see if there is an upstream
if git rev-parse --symbolic-full-name @{u} > /dev/null 2>&1; then
    echo "🤑 Found a valid upstream!"
else
    echo "🌱 No upstream found. Creating a new one..."
    git push --set-upstream origin "$BRANCH"
fi

write_pr

echo "     _                         _"
echo "    |_|                       |_|"
echo "    | |         /^^^\\         | |"
echo "   _| |_      (| \"o\" |)      _| |_"
echo "  _| | | | _    (_---_)    _ | | | |_ "
echo " | | | | |' |    _| |_    | \`| | | | |"
echo "\\          /   /     \\   \\          /"
echo " \\        /  / /(. .)\\ \\  \\        /"
echo "   \\    /  / /  | . |  \\ \\  \\    /"
echo "     \\  \\/ /   ||Y||    \\ \\/  /"
echo "       \\_/      || ||      \\_/"
echo "                 () ()"
echo "                 || ||"
echo "                ooO Ooo"
