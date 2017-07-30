import JWTSerializer from require "bassoon.jwt"

require("bassoon.util")._set_entropy_file "/dev/urandom"

describe "JWTSerializer", ->
	jwt = JWTSerializer!
	sha256jwt = JWTSerializer "HS256", ("a")\rep 24
	sha512jwt = JWTSerializer "HS512", ("a")\rep 24
	_256 = "eyJhbGciOiJIUzI1NiJ9.eyJhIjoiYiJ9.SeNel0xgZT7cEGBgVzx4COdp-ilsZRB0ylrgYjXUXz8"
	_512 = "eyJhbGciOiJIUzUxMiJ9.eyJhIjoiYiJ9.bmCYGSLIqPLOBNsgqyaV177TusfjkT9u0DzEgtbUKvj5J35V1NFKRo4HglM9TxsrGs87UPw76SJEkkydQcEt_A"
	unsigned = "eyJhbGciOiJIUzUxMiJ9.eyJhIjoiYiJ9"

	it "can encode to signed JSON web tokens", ->
		assert.same _256, sha256jwt\encode a: 'b'
		assert.same _512, sha512jwt\encode a: 'b'

	it "can encode to unsigned JSON web tokens", ->
		assert.same unsigned, jwt\encode {a: 'b'}, true
	
	it "can decode from signed JSON web tokens", ->
		assert.same {a: 'b'}, sha256jwt\decode _256
		assert.same {a: 'b'}, sha512jwt\decode _512
		
	it "can decode from unsigned JSON web tokens", ->
		assert.same {a: 'b'}, jwt\decode unsigned, true

	it "can detect invalid JSON web tokens, and error on failure", ->
		assert.errors ->
			-- a single bit is incremented, but that makes the sign fail
			assert.same {a: 'c'}, jwt\decode unsigned, true
		assert.errors ->
			-- invalidate the signature instead, also errors
			assert.same {a: 'b'}, jwt\decode unsigned\gsub(".$", "a"), true
