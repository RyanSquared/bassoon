# Bassoon - MoonScript HMAC (via OpenSSL) and JWT

## Signing

SHA-1 and SHA-2 methods are used for hashing text to an irreversible output and
HMAC is used for signing text with a 24-bit key. There is a `Signer()` class
and a `util.random_key` function.

It is not recommended to use any other methods that aren't ensured to exist
in your system's OpenSSL library. `md5` is also proven to be vulnerable to
multiple attacks and will raise an error if is attempted to be used.

```moon
import Signer from require "bassoon"
import random_key from require "signer.util"

signer = Signer random_key!, separator: ".", digest_method: "sha1"

text = signer\sign "user=ryan"
assert signer\verify(text) == "user=ryan"

```

Basically, `signer\sign()` should be sent to a client, and `signer\verify()`
should be used to verify content received from a client.

## JWT - JSON Web Tokens

JSON Web Tokens are pieces of data that can be understood by web browsers and
other utilities. They're different to the above signing in that the algorithm
used for verification is stored in a header for the request and uses three
segments instead of two. The format also uses JSON for transferring data,
meaning data can be expected to deserialize into JSON-compatible values.

```moon
import JWTSerializer from require "bassoon.jwt"
serializer = JWTSerializer!
data = serializer\encode {
	a: "b"
	c: {"hello", "world"}
} -- produces a JWT with tbe body as {"a": "b", "c": ["hello", "world"]}
print table.concat serializer\decode data.c
```

## Purpose

Web applications often use cookies to store login information such as tokens
that can be used for authentication. However, this data can be brute-forced by
the server. By using a cryptographically random key for signing the text, this
means that both a login token **and** a signature are required for gaining
access. While it's not impossible to brute force, it's much harder. It can also
be impossible to detect which is invalid - the token or the signature - making
this method much more secure than simply providing a token and allowing an
attacker to brute force a token.

## Documentation

... can be found in ./docs, or compiled with LDoc.
