import Signer from require "bassoon"
import random_key from require "bassoon.util"

require("bassoon.util")._set_entropy_file "/dev/urandom"

describe "Signer", ->
	it "can create a default Signer object with proper values", ->
		key = random_key!
		assert.is {
			signing_key: key
			separator: "!"
			digest_method: "sha512"
		}, Signer key
	it "can create a customized Signer object with proper values", ->
		key = random_key!
		assert.is {
			signing_key: key
			separator: "."
			digest_method: "sha256"
		}, Signer key, separator: ".", digest_method: "sha256"
		assert.is {
			signing_key: key
			separator: "?"
			digest_method: "sha1"
		}, Signer key, separator: "?", digest_method: "sha1"

describe "Signer\\sign", ->
	nonrandom_key = ("a")\rep 24
	it "can sign SHA1 hashes", ->
		signer = Signer nonrandom_key, digest_method: "sha1"
		assert.is signer\sign "text", "text!nEt/wqnuT053t9o+AdNCCBRHsok="

	it "can sign SHA256 hashes", ->
		signer = Signer nonrandom_key, digest_method: "sha256"
		assert.is signer\sign "text",
			"text!j3OLJxNJBRJh2V6z7sGAKtzdBQbqbL9n9CsNa+z2H1U="

	it "can sign SHA512 hashes", ->
		signer = Signer nonrandom_key, digest_method: "sha512"
		assert.is signer\sign "text",
			"text!sKag4s0hespwmuGWbw2bYvF0Zs5+lSHq9No5fiF4xiBoC62M5OOjGfq" ..
			"7X0x4BOSW/22EPH9Vu/pAc6CdoCCvaQ=="

describe "Signer\\verify", ->
	it "can verify texts signed by SHA1", ->
		signer = Signer random_key!, digest_method: "sha1"
		assert.is (signer\verify signer\sign "text"), "text"
		assert.is (signer\verify signer\sign("text")\gsub("^.", "a")), false
	
	it "can verify texts signed by SHA256", ->
		signer = Signer random_key!, digest_method: "sha256"
		assert.is (signer\verify signer\sign "text"), "text"
		assert.is (signer\verify signer\sign("text")\gsub("^.", "a")), false

	it "can verify texts signed by SHA512", ->
		signer = Signer random_key!, digest_method: "sha512"
		assert.is (signer\verify signer\sign "text"), "text"
		assert.is (signer\verify signer\sign("text")\gsub("^.", "a")), false
