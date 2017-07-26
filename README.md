# Bassoon - MoonScript SHA-1, SHA-2, and HMAC

SHA-1 and SHA-2 methods are used for hashing text to an irreversible output and
HMAC is used for signing text with a 24-bit key. There is a `Signer()` class
and a `util.random_key` function.

```moon
import Signer from require "bassoon"
import random_key from require "signer.util"

signer = Signer random_key!, separator: ".", digest_method: "sha1"

text = signer\sign "user=ryan"
assert signer\verify(text) == "user=ryan"
```

Basically, `signer\sign()` should be sent to a client, and `signer\verify()`
should be used to verify content received from a client.

## Purpose

Web applications often use cookies to store login information such as tokens
that can be used for authentication. However, just storing data related to
authentication inside of the client can be easier. By using a cryptographically
random key, it is possible to ensure that the text `user=ryan` has been sent by
the server to the client, as well as verify that it has not been tampered with.
If someone were to just edit the cookie to instead say `user=dave`, the server
would know it has been tampered with, because the signed hash would not be
the same as the one that the client originally has stored.

## Documentation

... can be found in ./docs, or compiled with LDoc.
