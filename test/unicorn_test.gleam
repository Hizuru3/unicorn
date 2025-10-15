import gleam/list
import gleam/result
import gleam/string.{utf_codepoint}
import gleeunit
import unicorn.{NFD, NFKC}

pub fn main() -> Nil {
  gleeunit.main()
}

// Assuming all the given ints are valid codepoints,
// converts them into a string.
fn char_ints_to_string(cp: List(Int)) -> String {
  let assert Ok(result) =
    cp
    |> list.try_map(utf_codepoint)
    |> result.map(string.from_utf_codepoints)
  result
}

pub fn unicorn_test() {
  // NFC: "e" with a combining acute -> single "é"
  assert unicorn.to_nfc("e\u{0301}") == "é"
  assert unicorn.to_nfc("e\u{0301}") == char_ints_to_string([0x00E9])

  // NFD: single "が" -> "か" with a combining dakuten
  assert unicorn.to_nfd("が") == "か\u{3099}"
  assert unicorn.to_nfd("が") == char_ints_to_string([0x304B, 0x3099])

  // NFKC: half-width "ｶ" + half-width dakuten -> full-width "ガ"
  assert unicorn.to_nfkc("ｶﾞ") == "ガ"
  assert unicorn.to_nfkc("ｶﾞ") == char_ints_to_string([0x30AC])

  // NFKD: single ḕ -> "e" + macron + grave
  assert unicorn.to_nfkd("ḕ") == "e\u{0304}\u{0300}"
  assert unicorn.to_nfkd("ḕ") == char_ints_to_string([0x0065, 0x0304, 0x0300])

  // NFKC: fraction "¼" -> separate "1" + "⁄" + "4"
  assert unicorn.normalize("¼", NFKC) == "1⁄4"
  assert unicorn.normalize("¼", NFKC)
    == char_ints_to_string([0x0031, 0x2044, 0x0034])

  // NFKC: hangul conjoining jamo "ᄀ" + "ᅡ" + "ᆨ" -> single "각"
  assert unicorn.normalize("ᄀ" <> "ᅡ" <> "ᆨ", NFKC) == "각"
  assert unicorn.normalize("ᄀ" <> "ᅡ" <> "ᆨ", NFKC)
    == char_ints_to_string([0xAC01])

  // NFD: single "が" -> "か" with a combining dakuten
  // Note that `form` can be passed with a label in an explicit manner
  assert unicorn.normalize("が", form: NFD) == "か\u{3099}"
}
