import Signer from require "bassoon"
import random_key from require "bassoon.util"

require("bassoon.util")._set_entropy_file "/dev/urandom"

describe "Signer", ->
	it "can create a default Signer object with proper values", ->
		key = random_key!
		assert.same {
			signing_key: key
			separator: "!"
			digest_method: "sha512"
		}, Signer key
	it "can create a customized Signer object with proper values", ->
		key = random_key!
		assert.same {
			signing_key: key
			separator: "."
			digest_method: "sha256"
		}, Signer key, separator: ".", digest_method: "sha256"
		assert.same {
			signing_key: key
			separator: "?"
			digest_method: "sha1"
		}, Signer key, separator: "?", digest_method: "sha1"

describe "Signer\\sign", ->
	nonrandom_key = ("a")\rep 24
	it "can sign SHA1 hashes", ->
		signer = Signer nonrandom_key, digest_method: "sha1"
		assert.same signer\sign("text"), "text!auacRER3vON3hc8pvpsZqLKEPaw"

	it "can sign SHA256 hashes", ->
		signer = Signer nonrandom_key, digest_method: "sha256"
		assert.same signer\sign("text"),
			"text!WpwLfcVFLaQK4adQ7YIGBGnk3fAsrJoZFdVjAvj01ZA"

	it "can sign SHA512 hashes", ->
		signer = Signer nonrandom_key, digest_method: "sha512"
		assert.same signer\sign("text"),
			"text!NevY9uGFUMlrepM_VDrOrT7XcpMfWM5xbD2s75HOdDVaYeNrNddcPcXnX" ..
			"eavw186O4o_ciagcpp2Q5ZkEey7ew"

describe "Signer\\verify", ->
	it "can verify texts signed by SHA1", ->
		signer = Signer random_key!, digest_method: "sha1"
		assert.same (signer\verify signer\sign "text"), "text"
		assert.same (signer\verify signer\sign("text")\gsub("^.", "a")), false

	it "can verify texts signed by SHA256", ->
		signer = Signer random_key!, digest_method: "sha256"
		assert.same (signer\verify signer\sign "text"), "text"
		assert.same (signer\verify signer\sign("text")\gsub("^.", "a")), false

	it "can verify texts signed by SHA512", ->
		signer = Signer random_key!, digest_method: "sha512"
		assert.same (signer\verify signer\sign "text"), "text"
		assert.same (signer\verify signer\sign("text")\gsub("^.", "a")), false
