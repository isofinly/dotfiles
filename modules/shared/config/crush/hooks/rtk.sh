CMD="${CRUSH_TOOL_INPUT_COMMAND:-}"
if [ -z "$CMD" ]; then
    exit 0
fi

REWRITTEN=$(rtk rewrite "$CMD" 2>/dev/null) && EXIT_CODE=0 || EXIT_CODE=$?

case $EXIT_CODE in
0 | 3)
    # Rewrite found. If identical, the command already uses rtk.
    [ "$CMD" = "$REWRITTEN" ] && exit 0
    jq -n --arg cmd "$REWRITTEN" \
        '{decision: "allow", updated_input: ({command: $cmd} | tostring)}'
    ;;
*)
    # No rewrite (1), deny (2), or unexpected — pass through.
    exit 0
    ;;
esac
