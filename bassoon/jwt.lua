local json
json = require("cereal").json
local from_url64, to_url64
do
  local _obj_0 = require("basexx")
  from_url64, to_url64 = _obj_0.from_url64, _obj_0.to_url64
end
local Signer
Signer = require("bassoon").Signer
local random_key
random_key = require("bassoon.util").random_key
local signers = { }
local _get_signer
_get_signer = function(key, algo)
  local name = tostring(algo) .. "." .. tostring(key)
  if not signers[name] then
    signers[name] = Signer(key, {
      digest_method = algo,
      separator = "."
    })
  end
  return signers[name]
end
local _get_ossl_algorithm
_get_ossl_algorithm = function(algo)
  local _exp_0 = algo
  if "HS256" == _exp_0 then
    return "sha256"
  elseif "HS512" == _exp_0 then
    return "sha512"
  elseif "none" == _exp_0 then
    return nil
  else
    return error("Unknown JWT algorithm: " .. tostring(algo))
  end
end
local JWTSerializer
do
  local _class_0
  local _decode_json
  local _base_0 = {
    encode = function(self, data, plain)
      local header = to_url64(json.encode({
        alg = self.algorithm
      }))
      local b64json = to_url64(json.encode(data))
      local text = tostring(header) .. "." .. tostring(b64json)
      if plain then
        return text
      else
        return self.signer:sign(text)
      end
    end,
    decode = function(self, b64data, plain)
      if plain then
        return _decode_json(b64data:match("^.-%.(.+)$"))
      end
      local header_string, pos = b64data:match("^(.-)%.()")
      local body_string = b64data:match("^(.-)%.", pos)
      local header = _decode_json(header_string)
      local body = _decode_json(body_string)
      local algorithm = _get_ossl_algorithm(header.alg)
      assert(self.signer:verify_text(b64data:match("^(.+)%.(.-)$")))
      return body
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, algorithm, key)
      if algorithm == nil then
        algorithm = "HS512"
      end
      if key == nil then
        key = random_key()
      end
      self.key = key
      self.algorithm = algorithm
      self.ossl_algorithm = _get_ossl_algorithm(algorithm)
      self.signer = _get_signer(key, self.ossl_algorithm)
    end,
    __base = _base_0,
    __name = "JWTSerializer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  _decode_json = function(data)
    return json.decode(from_url64(data))
  end
  JWTSerializer = _class_0
end
return {
  JWTSerializer = JWTSerializer
}
