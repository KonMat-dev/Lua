package = "serpent"
version = "0.25-1"
source = {
  url = "git://github.com/pkulchenko/serpent.git",
  tag = "0.25"
}

description = {
  summary = "Lua serializer and pretty printer",
  homepage = "https://github.com/pkulchenko/serpent",
  maintainer = "Paul Kulchenko <paul@kulchenko.com>",
  license = "MIT",
}

dependencies = {
  "lua >= 5.1, < 5.3",
}

build = {
  type = "builtin",
  modules = {
    ["serpent"] = "src/serpent.lua",
  },
  copy_directories = { "t" },
}
