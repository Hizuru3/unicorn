export function to_nfc(s) {
    return s.normalize("NFC")
}

export function to_nfd(s) {
    return s.normalize("NFD")
}

export function to_nfkc(s) {
    return s.normalize("NFKC")
}

export function to_nfkd(s) {
    return s.normalize("NFKD")
}
