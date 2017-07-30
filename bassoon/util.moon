--- Utility library for Bassoon
-- @author RyanSquared <vandor2012@gmail.com>
-- @module bassoon.util
-- @usage import {random_key, ensure_uniqueness} from require "bassoon.util"

_entropy_file = "/dev/random"

_set_entropy_file = (filename)-> _entropy_file = filename

--- Internal function for generating random bytes
-- @tparam number size number of bytes to generate
_random_key = (size)->
	if file = io.open _entropy_file
		str = file\read size
		file\close!
		str
	else
		math.randomseed os.clock! * os.time!
		table.concat {math.random(1, 255) for n=1, size}

--- Make sure there are no more than `max_duplicates duplicate characters
-- @tparam string text Text to scan for duplications
-- @tparam table opts
-- - `opts.max_duplicates: int = 2` - maximum duplicate characters before error
-- @usage assert ensure_uniqueness random_key!
ensure_uniqueness = (text, opts = {})->
	max_duplicates = do
			if opts.max_duplicates
				assert type opts.max_duplicates == "int"
				opts.max_duplicates
			else
				2
	hits = {}
	for byte in text\gmatch "."
		if not hits[byte]
			hits[byte] = 1
		else
			hits[byte] += 1
		if hits[byte] > max_duplicates
			false
	text

--- Generate a string of `size` bytes, guaranteed to be unique and random
-- @tparam table opts
-- - `opts.size: int = 24` - number of bytes to generate
-- @usage tbsp.secret_key = random_key!
random_key = (opts = {})->
	size = do
		if opts.size then
			assert type(opts.size) == "number"
			opts.size
		else
			24
	while true
		key = _random_key size
		return key if ensure_uniqueness key

return {:ensure_uniqueness, :random_key, :_set_entropy_file, :_random_key}
