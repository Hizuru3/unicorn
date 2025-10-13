-module(er_ffi).
-export([to_nfc/1, to_nfd/1, to_nfkc/1, to_nfkd/1]).

to_nfc(S) ->
    unicode:characters_to_nfc_binary(S).

to_nfd(S) ->
    unicode:characters_to_nfd_binary(S).

to_nfkc(S) ->
    unicode:characters_to_nfkc_binary(S).

to_nfkd(S) ->
    unicode:characters_to_nfkd_binary(S).
