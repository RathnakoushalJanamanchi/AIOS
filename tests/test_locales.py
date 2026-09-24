import importlib.util
import unittest
from pathlib import Path


MODULE_PATH = Path(__file__).resolve().parents[1] / "scripts" / "check_locales.py"
SPEC = importlib.util.spec_from_file_location("check_locales", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
check_locales = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(check_locales)


REGISTRY = {
    "defaultLocale": "en-IN",
    "locales": {
        "en-IN": {"name": "English", "language": "en", "region": "IN", "direction": "ltr"},
        "hi-IN": {"name": "Hindi", "language": "hi", "region": "IN", "direction": "ltr"},
    },
}
CATALOGS = {
    "en-IN": {"welcome": "Hello {{name}}", "close": "Close"},
    "hi-IN": {"welcome": "नमस्ते {{name}}", "close": "बंद करें"},
}


class LocaleValidationTests(unittest.TestCase):
    def test_valid_catalogs_pass(self):
        self.assertEqual(check_locales.validate_catalogs(REGISTRY, CATALOGS), [])

    def test_missing_key_is_reported(self):
        catalogs = {**CATALOGS, "hi-IN": {"welcome": "नमस्ते {{name}}"}}
        errors = check_locales.validate_catalogs(REGISTRY, catalogs)
        self.assertIn("hi-IN: missing key close", errors)

    def test_placeholder_mismatch_is_reported(self):
        catalogs = {**CATALOGS, "hi-IN": {"welcome": "नमस्ते {{user}}", "close": "बंद करें"}}
        errors = check_locales.validate_catalogs(REGISTRY, catalogs)
        self.assertTrue(any("placeholder mismatch" in error for error in errors))

    def test_empty_translation_is_reported(self):
        catalogs = {**CATALOGS, "hi-IN": {"welcome": "   ", "close": "बंद करें"}}
        errors = check_locales.validate_catalogs(REGISTRY, catalogs)
        self.assertIn("hi-IN: welcome must be a non-empty string", errors)

    def test_invalid_text_direction_is_reported(self):
        registry = {
            **REGISTRY,
            "locales": {
                **REGISTRY["locales"],
                "hi-IN": {**REGISTRY["locales"]["hi-IN"], "direction": "sideways"},
            },
        }
        errors = check_locales.validate_catalogs(registry, CATALOGS)
        self.assertIn("hi-IN: direction must be 'ltr' or 'rtl'", errors)


if __name__ == "__main__":
    unittest.main()

