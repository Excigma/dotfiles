processed=bankstown_sink
unprocessed=effects_off_sink
state_file=${XDG_STATE_HOME:-$HOME/.local/state}/effects-mode

stream_filter='
  .[]
  | select(.type == "PipeWire:Interface:Node" and .info.props["media.class"] == "Stream/Output/Audio")
  | select((.info.props["node.name"] // "" | test("^(output\\.|input\\.|easyeffects)"; "i")) | not)
  | .id
'

declare -A seen=()
last_prune=0

pw-dump -m -N | jq --unbuffered -r "$stream_filter" | while IFS= read -r stream_id; do
  [[ -z "$stream_id" ]] && continue
  [[ -n "${seen[$stream_id]+set}" ]] && continue
  seen[$stream_id]=1

  mode=$(cat "$state_file" 2>/dev/null || echo on)
  if [[ "$mode" == off ]]; then target=$unprocessed; else target=$processed; fi
  pw-metadata -n default "$stream_id" target.object "$target" Spa:String >/dev/null || true

  if (( SECONDS - last_prune > 60 )); then
    last_prune=$SECONDS
    declare -A live=()
    while IFS= read -r id; do
      [[ -n "$id" ]] && live[$id]=1
    done < <(pw-dump | jq -r "$stream_filter")
    for id in "${!seen[@]}"; do
      [[ -n "${live[$id]+set}" ]] || unset "seen[$id]"
    done
  fi
done
