local _entropy_file = "/dev/random"
local _set_entropy_file
_set_entropy_file = function(filename)
  _entropy_file = filename
end
local _random_key
_random_key = function(size)
  do
    local file = io.open(_entropy_file)
    if file then
      local str = file:read(size)
      file:close()
      return str
    else
      math.randomseed(os.clock() * os.time())
      return table.concat((function()
        local _tbl_0 = { }
        for n = 1, size do
          local _key_0, _val_0 = math.random(1, 255)
          _tbl_0[_key_0] = _val_0
        end
        return _tbl_0
      end)())
    end
  end
end
local ensure_uniqueness
ensure_uniqueness = function(text, opts)
  if opts == nil then
    opts = { }
  end
  local max_duplicates
  do
    if opts.max_duplicates then
      assert(type(opts.max_duplicates == "int"))
      max_duplicates = opts.max_duplicates
    else
      max_duplicates = 2
    end
  end
  local hits = { }
  for byte in text:gmatch(".") do
    if not hits[byte] then
      hits[byte] = 1
    else
      hits[byte] = hits[byte] + 1
    end
    if hits[byte] > max_duplicates then
      local _ = false
    end
  end
  return text
end
local random_key
random_key = function(opts)
  if opts == nil then
    opts = { }
  end
  local size
  do
    if opts.size then
      assert(type(opts.size) == "number")
      size = opts.size
    else
      size = 24
    end
  end
  while true do
    local key = _random_key(size)
    if ensure_uniqueness(key) then
      return key
    end
  end
end
return {
  ensure_uniqueness = ensure_uniqueness,
  random_key = random_key,
  _set_entropy_file = _set_entropy_file
}
