--- Implementation of hashing and signing short text, courtesy of luaossl
-- @author RyanSquared <vandor2012@gmail.com>
-- @classmod Signer
-- @usage import Signer from require "bassoon"

import to_url64 from require "basexx"
hmac = require "openssl.hmac"

import ensure_uniqueness from require "bassoon.util"

class Signer
	--- Create a new Signer class object with stored secret_key and other data
	-- @tparam string signing_key 24-byte unique-enforced key for signing text
	-- @tparam table opts
	-- - `opts.separator: str = "!"` - separator for signed text
	-- - `opts.digest_method: str = "sha512"` - hashing algorithm
	-- @usage signer = Signer random_key!, separator: "."
	--print signer\sign "hello world"
	new: (signing_key, opts = {})=>
		@signing_key = ensure_uniqueness signing_key
		@separator = do
			if opts.separator
				assert type opts.separator == "string"
				assert #opts.separator == 1
				assert opts.separator\match "[^A-Za-z0-9]"
				opts.separator
			else
				"!"
		@digest_method = if opts.digest_method
			--assert type(opts.digest_method) == "string"
			switch opts.digest_method and opts.digest_method\lower!
				when "md5"
					error "insecure digest method: #{opts.digest_method}"
				else
					opts.digest_method
		else
			"sha512"

	--- Return a signed version of the text to send to clients
	-- @tparam string text Text to sign. Should not include `@separator`
	-- @usage headers\set_cookie signer\sign "user=#{user}"
	sign: (text)=>
		signer = hmac.new @signing_key, @digest_method
		"#{text}#{@separator}#{to_url64 signer\final text}"

	--- Submethod used when verifying text without using @separator
	-- @tparam text Text to be used for verification
	-- @tparam signature Signature to match text
	verify_text: (text, signature)=>
		if @sign(text) == "#{text}#{@separator}#{signature}"
			return text
		else
			return false

	--- Verify that a text matches the resulting signature
	-- @tparam string signed_text Text with signature
	-- @see Signer\sign
	-- @usage cookie = headers\get_cookie_as_kv!
	-- if signer\verify headers\get_cookie!
	--   print("User signed in: #{cookie.user}")
	verify: (signed_text)=>
		pos = signed_text\find @separator, nil, true
		text = signed_text\sub 1, pos - 1
		if @sign(text) == signed_text then text else false

return :Signer
