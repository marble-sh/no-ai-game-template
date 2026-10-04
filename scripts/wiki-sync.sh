#!/bin/sh
# Publish the project wiki from docs/wiki/.
#
# Pages are worked on in docs/wiki/ (gitignored; a clone of <repo>.wiki.git once
# the wiki exists). Run this to push them live:
#
#   sh scripts/wiki-sync.sh "short message"
#
# Notes:
#  - The very first wiki page must be created once in the browser — GitHub only
#    builds the wiki git repository when that first page is saved: <repo>/wiki/_new
#  - If docs/wiki/ has pages but no clone yet, this script bootstraps the clone
#    from them (so you can write pages before the wiki exists).
#  - WIKI_REMOTE overrides the wiki remote (testing / GitHub Enterprise).
set -eu

REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
DIR=docs/wiki
REMOTE=${WIKI_REMOTE:-"git@github.com:$REPO.wiki.git"}
URL="https://github.com/$REPO/wiki"

if [ -d "$DIR/.git" ]; then
  cd "$DIR"
  git pull --rebase --autostash
else
  [ -d "$DIR" ] || { echo "no $DIR/ with pages to publish — nothing to do"; exit 1; }
  tmp=$(mktemp -d)
  if ! git clone "$REMOTE" "$tmp/wiki" 2>/dev/null; then
    rm -rf "$tmp"
    echo "The wiki repository does not exist yet."
    echo "Create the first page in the browser once, then re-run this script:"
    echo "  $URL/_new"
    exit 1
  fi
  # seed state: keep the local pages, adopt the clone as the working copy
  cp -R "$DIR/." "$tmp/wiki/"
  rm -rf "$DIR"
  mv "$tmp/wiki" "$DIR"
  rmdir "$tmp" 2>/dev/null || rm -rf "$tmp"
  cd "$DIR"
fi

git add -A
if git diff --cached --quiet; then
  echo "wiki is up to date: $URL"
  exit 0
fi
git commit -m "${1:-wiki: sync pages}"
git push
echo "published: $URL"
