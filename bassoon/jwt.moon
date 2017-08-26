--- JSON Web Token implementation
-- @author RyanSquared <vandor2012@gmail.com>
-- @classmod JWTSerializer

import json from require "cereal"
import from_url64, to_url64 from require "basexx"

import Signer from require "bassoon"
import random_key from require "bassoon.util"

signers = {}

_get_signer = (key, algo)->
	name = "#{algo}.#{key}"
	if not signers[name]
		signers[name] = Signer key, digest_method: algo, separator: "."
	return signers[name]

_get_ossl_algorithm = (algo)->
	switch algo
		when "HS256"
			"sha256"
		when "HS512"
			"sha512"
		when "none"
			nil
		else
			error "Unknown JWT algorithm: #{algo}"

class JWTSerializer
	--- Create a new JWTSerializer object
	-- @tparam string algorithm JWT algorithm, can be any of:
	-- `["HS256", "HS512"]`
	-- @tparam string key HMAC encryption key
	new: (algorithm = "HS512", key = random_key!)=>
		@key = key
		@algorithm = algorithm
		@ossl_algorithm = _get_ossl_algorithm algorithm
		@signer = _get_signer key, @ossl_algorithm

	--- Encode data into a formatted JWT. Current supported formats are:
	-- `["HS256", "HS512", "none"]`
	-- @tparam table data JSON-serializable table
	encode: (data, plain)=>
		header = to_url64 json.encode alg: @algorithm
		b64json = to_url64 json.encode data
		text = "#{header}.#{b64json}"

		if plain
			return text
		else
			return @signer\sign text

	_decode_json = (data)-> json.decode from_url64 data

	--- Verify and decode formatted JWT
	-- @tparam string b64data URL base64-formatted JWT
	decode: (b64data, plain)=>
		return _decode_json b64data\match "^.-%.(.+)$" if plain

		header_string, pos = b64data\match "^(.-)%.()"
		body_string = b64data\match "^(.-)%.", pos
		header = _decode_json header_string
		body = _decode_json body_string

		algorithm = _get_ossl_algorithm header.alg
		assert @signer\verify_text b64data\match "^(.+)%.(.-)$"
		return body

return {:JWTSerializer}
