# unicorn

A lightweight wrapper library around built-in Unicode normalization functions for both Erlang and JavaScript targets.

You can use either Erlang-style (`to_nfc`, `to_nfd`, `to_nfkc`, `to_nfkd`) or JavaScript-style (`normalize`) APIs, with type safety provided by Gleam.


## Usage

```gleam
import gleam/int
import gleam/list
import gleam/string

import unicorn.{NFKC}

pub fn main() {
  // **Erlang style**

  // NFC: "e" with a combining acute -> single "é"
  let s = unicorn.to_nfc("e\u{0301}")
  echo #(s, unicode_notations(s))
  // #("é", ["U+00E9"])

  // NFD: single "が" -> "か" with a combining dakuten
  let s = unicorn.to_nfd("が")
  echo #(s, unicode_notations(s))
  // #("が", ["U+304B", "U+3099"])

  // NFKC: half-width "ｶ" + half-width dakuten -> full-width "ガ"
  let s = unicorn.to_nfkc("ｶﾞ")
  echo #(s, unicode_notations(s))
  // #("ガ", ["U+30AC"])

  // NFKD: single ḕ -> "e" + macron + grave
  let s = unicorn.to_nfkd("ḕ")
  echo #(s, unicode_notations(s))
  // #("ḕ", ["U+0065", "U+0304", "U+0300"])

  // **JavaScript style**
  // To use it, pass (unicorn.)`Form` to the 2nd argument

  // NFKC: fraction "¼" -> separate "1" + "⁄" + "4"
  let s = unicorn.normalize("¼", NFKC)
  echo #(s, unicode_notations(s))
  // #("1⁄4", ["U+0031", "U+2044", "U+0034"])

  // NFKC: hangul conjoining jamo "ᄀ" + "ᅡ" + "ᆨ" -> single "각"
  let s = unicorn.normalize("ᄀ" <> "ᅡ" <> "ᆨ", NFKC)
  echo #(s, unicode_notations(s))
  // #("각", ["U+AC01"])
}

fn unicode_notations(s: String) -> List(String) {
  list.map(string.to_utf_codepoints(s), fn(cp) {
    let cp = string.utf_codepoint_to_int(cp)
    "U+" <> string.pad_start(int.to_base16(cp), 4, "0")
  })
}
```

For details on Unicode normalization, see:
[https://unicode.org/reports/tr15/](https://unicode.org/reports/tr15/)
