#!/bin/sh
# One-shot: create the project board — fields, views, items, priorities.
#
# Requires: gh, authenticated with the 'project' scope (gh auth refresh -s project).
# Run from the repo root, after scripts/setup-backlog.sh.
set -eu

REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
OWNER=${REPO%%/*}
NAME=${REPO##*/}
TITLE="$NAME — Roadmap"

echo "Creating project '$TITLE' for $OWNER ..."

if ! NUM=$(gh project create --owner "$OWNER" --title "$TITLE" --format json --jq .number 2>/dev/null); then
  echo "Could not create the project — the gh token probably lacks the 'project' scope."
  echo "Run:  gh auth refresh -s project   then re-run this script."
  exit 1
fi
echo "Project #$NUM created."

echo "Creating fields ..."
gh project field-create "$NUM" --owner "$OWNER" --name "Priority" --data-type SINGLE_SELECT \
  --single-select-options "P1,P2,P3" >/dev/null
gh project field-create "$NUM" --owner "$OWNER" --name "Due" --data-type DATE >/dev/null

echo "Adding issues to the board ..."
sleep 5 # give the search index a moment to catch up with the seeded backlog
gh issue list --state all --limit 300 --json url --jq '.[].url' | while read -r url; do
  if ! gh project item-add "$NUM" --owner "$OWNER" --url "$url" >/dev/null 2>&1; then
    sleep 3
    gh project item-add "$NUM" --owner "$OWNER" --url "$url" >/dev/null 2>&1 \
      || echo "  note: not added ($url) — already on the board, or add it by hand"
  fi
done

PROJ_ID=$(gh project view "$NUM" --owner "$OWNER" --format json --jq .id)
PRI_ID=$(gh project field-list "$NUM" --owner "$OWNER" --format json --jq '.fields[] | select(.name=="Priority") | .id')
DUE_ID=$(gh project field-list "$NUM" --owner "$OWNER" --format json --jq '.fields[] | select(.name=="Due") | .id')

echo "Creating views ..."

new_view() { # $1 name, $2 layout, $3 filter, $4 visible fields (space-separated tokens: PRI DUE)
  cfg=""
  if [ -n "${4:-}" ]; then
    ids=""
    for f in $4; do
      case "$f" in
        PRI) id="$PRI_ID" ;;
        DUE) id="$DUE_ID" ;;
      esac
      ids="$ids\"$id\", "
    done
    cfg=", configuration: {visibleFieldIds: [${ids%, }]}"
  fi
  vid=$(gh api graphql -f query="mutation { createProjectV2View(input: {projectId: \"$PROJ_ID\", name: \"$1\", layout: $2$cfg}) { projectV2View { id } } }" \
    --jq '.data.createProjectV2View.projectV2View.id')
  if [ -n "${3:-}" ]; then
    esc=$(printf '%s' "$3" | sed 's/"/\\"/g')
    gh api graphql -f query="mutation { updateProjectV2View(input: {viewId: \"$vid\", filter: \"$esc\"}) { projectV2View { name } } }" >/dev/null
  fi
  echo "  view: $1"
}

new_view "Next up" TABLE_LAYOUT "label:ready is:open" "PRI DUE"
new_view "Doing now" TABLE_LAYOUT "status:\"In Progress\"" "PRI DUE"
new_view "This milestone" BOARD_LAYOUT "milestone:\"M0 — Setup & first window\" is:open" "PRI DUE"
new_view "Timeline" ROADMAP_LAYOUT "is:open" ""

# GitHub materializes a default "View 1" shortly AFTER project creation — sweep
# once our views exist and the defaults have had a moment to show up.
echo "Removing default placeholder views ..."
sleep 3
gh api graphql -f query="query { node(id: \"$PROJ_ID\") { ... on ProjectV2 { views(first: 20) { nodes { id name } } } } }" \
  --jq '.data.node.views.nodes[] | select(.name | test("^View [0-9]+$")) | .id' |
while read -r vid; do
  if gh api graphql -f query="mutation { deleteProjectV2View(input: {viewId: \"$vid\"}) { projectV2View { id } } }" >/dev/null 2>&1; then
    echo "  removed a default view"
  fi
done

echo "Setting priorities (P1 = ready, P2 = next milestone, P3 = the rest) ..."
pri() {
  if ! gh project item-edit "$NUM" --owner "$OWNER" --url "$1" --field "Priority" --value "$2" >/dev/null 2>&1; then
    sleep 5
    gh project item-edit "$NUM" --owner "$OWNER" --url "$1" --field "Priority" --value "$2" >/dev/null 2>&1 \
      || echo "  note: could not set Priority=$2 on $1 — set it in the project UI"
  fi
  sleep 1
}
gh issue list --state open --label ready --json url --jq '.[].url' | while read -r u; do pri "$u" P1; done
gh issue list --state open --milestone "M1 — Core loop" --json url --jq '.[].url' | while read -r u; do pri "$u" P2; done
for ms in "M2 — Progression" "M3 — Saving" "M4 — Feel & polish" "M5 — Ship"; do
  gh issue list --state open --milestone "$ms" --json url --jq '.[].url' | while read -r u; do pri "$u" P3; done
done

echo
echo "Board ready: https://github.com/users/$OWNER/projects/$NUM"
echo "Notes:"
echo "  - Sort order, board grouping and the roadmap date field are UI-only settings —"
echo "    set them once in the view menus (sort 'Next up' by Due, group 'This milestone'"
echo "    by Status, timeline date field = Due) and they persist."
echo "  - 'This milestone' filters on M0 — update the filter when you move milestones."
echo "  - Built-in project workflows (UI-only, enable once): 'Auto-add to project' with"
echo "    the filter 'is:issue is:open', 'Item closed -> Status: Done', and"
echo "    'Item reopened -> Status: Todo' so the board tracks issue state by itself."
