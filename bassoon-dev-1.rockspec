package = "bassoon"
version = "dev-1"

source = {
	url = "https://github.com/RyanSquared/bassoon";
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
		["bassoon"] = "init.lua";
		["bassoon.util"] = "util.lua";
	};
}
