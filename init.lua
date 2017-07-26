local to_base64, from_base64
do
  local _obj_0 = require("basexx")
  to_base64, from_base64 = _obj_0.to_base64, _obj_0.from_base64
end
local digest = require("openssl.digest")
local hmac = require("openssl.hmac")
local ensure_uniqueness
ensure_uniqueness = require("bassoon.util").ensure_uniqueness
local Signer
do
  local _class_0
  local _base_0 = {
    sign = function(self, text)
      local hasher = digest.new(self.digest_method)
      local signer = hmac.new(self.signing_key, self.digest_method)
      return tostring(text) .. tostring(self.separator) .. tostring(to_base64(signer:final(hasher:final(text))))
    end,
    verify = function(self, signed_text)
      local pos = signed_text:find(self.separator, nil, true)
      local text = signed_text:sub(1, pos - 1)
      if self:sign(text) == signed_text then
        return text
      else
        return false
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, signing_key, opts)
      if opts == nil then
        opts = { }
      end
      self.signing_key = ensure_uniqueness(signing_key)
      do
        if opts.separator then
          assert(type(opts.separator == "string"))
          assert(#opts.separator == 1)
          assert(opts.separator:match("[^A-Za-z0-9]"))
          self.separator = opts.separator
        else
          self.separator = "!"
        end
      end
      if opts.digest_method then
        local _exp_0 = opts.digest_method and opts.digest_method:lower()
        if "md5" == _exp_0 then
          self.digest_method = error("insecure digest method: " .. tostring(opts.digest_method))
        else
          self.digest_method = opts.digest_method
        end
      else
        self.digest_method = "sha512"
      end
    end,
    __base = _base_0,
    __name = "Signer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Signer = _class_0
end
return {
  Signer = Signer
}
