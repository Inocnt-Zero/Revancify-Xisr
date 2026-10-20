#!/usr/bin/bash

advanced_menu() {
  while true; do
    CHOICE=$("${DIALOG[@]}" \
      --title "| Advanced Configs |" \
      --ok-label "Select" \
      --cancel-label "Back" \
      --menu "Choose an option:" -1 -1 -1 \
      1 "GitHub Token Manager" \
      2>&1 >/dev/tty) || break

    case "$CHOICE" in
      1)
        manage_github_token
        ;;
      *)
        break
        ;;
    esac
  done
}

manage_github_token() {
  local TOKEN_FILE="$SRC/github_token.json"

  while true; do
    CHOICE=$("${DIALOG[@]}" \
      --title "| GitHub Token |" \
      --ok-label "Select" \
      --cancel-label "Back" \
      --menu "Manage GitHub token:" -1 -1 -1 \
      1 "Add token" \
      2 "Remove token" \
      2>&1 >/dev/tty) || break

    case "$CHOICE" in
      1)
        TOKEN=$("${DIALOG[@]}" \
          --title "Add GitHub Token" \
          --ok-label "Save" \
          --cancel-label "Cancel" \
          --inputbox "Paste your GitHub token:" -1 -1 \
          2>&1 >/dev/tty) || continue

        [ -z "$TOKEN" ] && continue

        mkdir -p "$SRC"
        echo "{}" | jq --arg token "$TOKEN" '.token = $token' > "$TOKEN_FILE"

        "${DIALOG[@]}" \
          --title "Done" \
          --msgbox "GitHub token saved." 8 40
        ;;

      2)
        rm -f "$TOKEN_FILE"

        "${DIALOG[@]}" \
          --title "Done" \
          --msgbox "GitHub token removed." 8 40
        ;;

      *)
        break
        ;;
    esac
  done
}
