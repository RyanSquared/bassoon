import ensure_uniqueness from require "bassoon.util"

describe "bassoon.util.ensure_uniqueness", ->
	it "can find repeated characters in strings", ->
		assert.is ensure_uniqueness("aaadefg"), false
		assert.is ensure_uniqueness("abcdefg"), "abcdefg"
