package = "bassoon"
version = "dev-1"

source = {
	url = "git+https://github.com/RyanSquared/bassoon";
}

description = {
	summary = "A library for hashing and signing short texts";
}

dependencies = {
	"luaossl";
}

build = {
	type = "builtin";
	modules = {
		["bassoon"] = "bassoon/init.lua";
		["bassoon.util"] = "bassoon/util.lua";
		["bassoon.jwt"] = "bassoon/jwt.lua";
	};
}
