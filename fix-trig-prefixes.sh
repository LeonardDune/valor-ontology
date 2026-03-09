#!/bin/sh
# fix-trig-prefixes.sh
# Verplaatst @prefix-regels van binnen graph-blocks naar document-niveau

for f in *.trig; do
  # Controleer of het bestand @prefix binnenin een block heeft
  if ! grep -qE '^\s+@prefix ' "$f"; then
    echo "OK (geen fix nodig): $f"
    continue
  fi

  # Extraheer alle @prefix-regels (inclusief inspringing weggooien)
  prefixes=$(grep -E '^\s+@prefix ' "$f" | sed 's/^\s*//')

  # Verwijder @prefix-regels uit de body
  body=$(grep -v -E '^\s+@prefix ' "$f")

  # Schrijf: prefixes bovenaan, dan rest
  printf '%s\n%s\n' "$prefixes" "$body" > "$f"

  echo "Gefixt: $f"
done
