//// A lightweight wrapper library around built-in Unicode normalization functions.
////
//// For details on Unicode normalization, see:
//// https://unicode.org/reports/tr15/

/// Represents normalization forms accepted by the `normalize` function.
pub type Form {
  /// Canonical composition form
  NFC

  /// Canonical decomposition form
  NFD

  /// Compatibility composition form
  NFKC

  /// Compatibility decomposition form
  NFKD
}

/// Converts a `String` into its
/// canonical composition form (NFC).
///
/// ## Examples
///
/// ```gleam
/// // NFC: "e" with a combining acute -> single "é"
/// assert unicorn.to_nfc("e\u{0301}") == "é"
/// ```
///
@external(erlang, "er_ffi", "to_nfc")
@external(javascript, "./js_ffi.mjs", "to_nfc")
pub fn to_nfc(s: String) -> String

/// Converts a `String` into its
/// canonical decomposition form (NFD).
///
/// ## Examples
///
/// ```gleam
/// // NFD: single "が" -> "か" with a combining dakuten
/// assert unicorn.to_nfd("が") == "か\u{3099}"
/// ```
///
@external(erlang, "er_ffi", "to_nfd")
@external(javascript, "./js_ffi.mjs", "to_nfd")
pub fn to_nfd(s: String) -> String

/// Converts a `String` into its
/// compatibility composition form (NFKC).
///
/// ## Examples
///
/// ```gleam
/// // NFKC: half-width "ｶ" + half-width dakuten -> full-width "ガ"
/// assert unicorn.to_nfkc("ｶﾞ") == "ガ"
/// ```
///
@external(erlang, "er_ffi", "to_nfkc")
@external(javascript, "./js_ffi.mjs", "to_nfkc")
pub fn to_nfkc(s: String) -> String

/// Converts a `String` into its
/// compatibility decomposition form (NFKD).
///
/// ## Examples
///
/// ```gleam
/// // NFKD: single ḕ -> "e" + macron + grave
/// assert unicorn.to_nfkd("ḕ") == "e\u{0304}\u{0300}"
/// ```
///
@external(erlang, "er_ffi", "to_nfkd")
@external(javascript, "./js_ffi.mjs", "to_nfkd")
pub fn to_nfkd(s: String) -> String

/// Normalizes a `String` to the specified Unicode normalization `form`.
///
/// ## Examples
///
/// ```gleam
/// // NFKC: fraction "¼" -> separate "1" + "⁄" + "4"
/// assert unicorn.normalize("¼", NFKC) == "1⁄4"
/// ```
///
/// ```gleam
/// // NFKC: hangul conjoining jamo "ᄀ" + "ᅡ" + "ᆨ" -> single "각"
/// assert unicorn.normalize("ᄀ" <> "ᅡ" <> "ᆨ", NFKC) == "각"
/// ```
///
/// ```gleam
/// // NFD: single "が" -> "か" with a combining dakuten
/// // Note that `form` can be passed with a label in an explicit manner
/// assert unicorn.normalize("が", form: NFD) == "か\u{3099}"
/// ```
///
pub fn normalize(s: String, form kind: Form) -> String {
  case kind {
    NFC -> to_nfc(s)
    NFD -> to_nfd(s)
    NFKC -> to_nfkc(s)
    NFKD -> to_nfkd(s)
  }
}
