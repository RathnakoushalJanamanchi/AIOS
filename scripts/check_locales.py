#!/usr/bin/env python3
"""Validate locale metadata and translation catalogs using only the Python stdlib."""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any

PLACEHOLDER = re.compile(r"{{\s*([A-Za-z0-9_.-]+)\s*}}")


def validate_catalogs(registry: dict[str, Any], catalogs: dict[str, dict[str, Any]]) -> list[str]:
    """Return validation errors for a locale registry and its string catalogs."""
    errors: list[str] = []
    locales = registry.get("locales")
    if not isinstance(locales, dict) or not locales:
        return ["registry must define at least one locale"]

    default_locale = registry.get("defaultLocale")
    if default_locale not in locales:
        errors.append("defaultLocale must name a locale in the registry")

    expected_ids = set(locales)
    if set(catalogs) != expected_ids:
        missing = sorted(expected_ids - set(catalogs))
        extra = sorted(set(catalogs) - expected_ids)
        if missing:
            errors.append("missing catalogs: " + ", ".join(missing))
        if extra:
            errors.append("catalogs absent from registry: " + ", ".join(extra))

    for locale_id, metadata in locales.items():
        if not isinstance(metadata, dict):
            errors.append(f"{locale_id}: locale metadata must be an object")
            continue
        for field in ("name", "language", "region"):
            if not isinstance(metadata.get(field), str) or not metadata[field].strip():
                errors.append(f"{locale_id}: {field} must be a non-empty string")
        if metadata.get("direction") not in ("ltr", "rtl"):
            errors.append(f"{locale_id}: direction must be 'ltr' or 'rtl'")

    baseline = catalogs.get(default_locale, {})
    if not isinstance(baseline, dict):
        return errors + [f"{default_locale}: catalog must be an object"]
    expected_keys = set(baseline)

    for locale_id, catalog in catalogs.items():
        if not isinstance(catalog, dict):
            errors.append(f"{locale_id}: catalog must be an object")
            continue
        keys = set(catalog)
        for key in sorted(expected_keys - keys):
            errors.append(f"{locale_id}: missing key {key}")
        for key in sorted(keys - expected_keys):
            errors.append(f"{locale_id}: unexpected key {key}")
        for key, value in catalog.items():
            if not isinstance(value, str) or not value.strip():
                errors.append(f"{locale_id}: {key} must be a non-empty string")
        if locale_id != default_locale:
            for key in sorted(expected_keys & keys):
                reference = baseline.get(key)
                translated = catalog.get(key)
                if isinstance(reference, str) and isinstance(translated, str):
                    reference_tokens = set(PLACEHOLDER.findall(reference))
                    translated_tokens = set(PLACEHOLDER.findall(translated))
                    if reference_tokens != translated_tokens:
                        errors.append(
                            f"{locale_id}: {key} placeholder mismatch "
                            f"(expected {sorted(reference_tokens)}, got {sorted(translated_tokens)})"
                        )
    return errors


def load_json(path: Path) -> Any:
    with path.open(encoding="utf-8") as source:
        return json.load(source)


def main() -> int:
    project_root = Path(__file__).resolve().parents[1]
    locale_dir = project_root / "localization"
    try:
        registry = load_json(locale_dir / "languages.json")
        catalogs = {
            path.stem: load_json(path)
            for path in locale_dir.glob("*.json")
            if path.name != "languages.json"
        }
    except (OSError, json.JSONDecodeError) as error:
        print(f"Locale loading failed: {error}", file=sys.stderr)
        return 2

    errors = validate_catalogs(registry, catalogs)
    if errors:
        print("\n".join(f"ERROR: {error}" for error in errors), file=sys.stderr)
        return 1
    print(f"Validated {len(catalogs)} locale catalogs.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

