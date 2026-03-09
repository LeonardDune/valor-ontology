#!/bin/sh
# fix-trig-prefixes.sh (v2) — ook @prefix zonder inspringing

for f in *.trig; do
  [ -f "$f" ] || continue

  # Extraheer ALLE @prefix-regels (ongeacht inspringing)
  prefixes=$(grep -E '^[[:space:]]*@prefix ' "$f" | sed 's/^[[:space:]]*//')

  if [ -z "$prefixes" ]; then
    echo "OK (geen fix nodig): $f"
    continue
  fi

  # Verwijder alle @prefix-regels uit de body
  body=$(grep -v -E '^[[:space:]]*@prefix ' "$f")

  # Schrijf: prefixes bovenaan, dan rest
  printf '%s\n%s\n' "$prefixes" "$body" > "$f"

  echo "Gefixt: $f"
done
