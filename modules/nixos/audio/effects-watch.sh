processed=bankstown_sink
unprocessed=effects_off_sink
state_file=${XDG_STATE_HOME:-$HOME/.local/state}/effects-mode

pw-dump -m -N | jq --unbuffered -r '
  .[]
  | select(.type == "PipeWire:Interface:Node" and .info.props["media.class"] == "Stream/Output/Audio")
  | select((.info.props["node.name"] // "" | test("^(output\\.|input\\.|easyeffects)"; "i")) | not)
  | .id
' | while IFS= read -r stream_id; do
  mode=$(cat "$state_file" 2>/dev/null || echo on)
  if [[ "$mode" == off ]]; then target=$unprocessed; else target=$processed; fi
  pw-metadata -n default "$stream_id" target.object "$target" Spa:String >/dev/null || true
done
