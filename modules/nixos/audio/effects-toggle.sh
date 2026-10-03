hardware=alsa_output.pci-0000_00_1f.3.analog-stereo
processed=bankstown_sink
unprocessed=effects_off_sink
state_file=${XDG_STATE_HOME:-$HOME/.local/state}/effects-mode

usage() {
  echo "Usage: effects [on|off|toggle|status]" >&2
  exit 2
}

snapshot=$(pw-dump)
find_id() {
  jq -r --arg name "$1" '
    .[] | select(.type == "PipeWire:Interface:Node" and .info.props["node.name"] == $name) | .id
  ' <<< "$snapshot" | head -n 1
}

hardware_id=$(find_id "$hardware")
processed_id=$(find_id "$processed")
unprocessed_id=$(find_id "$unprocessed")
if [[ -z "$hardware_id" || -z "$processed_id" || -z "$unprocessed_id" ]]; then
  echo "The hardware sink, bankstown_sink, and effects_off_sink must be running." >&2
  exit 1
fi

current_mode=$(cat "$state_file" 2>/dev/null || echo on)
case "${1:-toggle}" in
  status)
    echo "effects $current_mode"
    exit 0
    ;;
  toggle)
    if [[ "$current_mode" == on ]]; then mode=off; else mode=on; fi
    ;;
  on|off) mode=$1 ;;
  *) usage ;;
esac

if [[ "$mode" == on ]]; then
  target=$processed
else
  target=$unprocessed
fi

wpctl set-default "$hardware_id"
mkdir -p "$(dirname "$state_file")"
printf '%s\n' "$mode" > "$state_file"

while IFS= read -r stream_id; do
  [[ -z "$stream_id" ]] && continue
  pw-metadata -n default "$stream_id" target.object "$target" Spa:String >/dev/null
done < <(jq -r '
  .[]
  | select(.type == "PipeWire:Interface:Node" and .info.props["media.class"] == "Stream/Output/Audio")
  | select((.info.props["node.name"] // "" | test("^(output\\.|input\\.|easyeffects)"; "i")) | not)
  | .id
' <<< "$snapshot")

echo "effects $mode"
