---@diagnostic disable: undefined-global

return {
  s({ trig = "mt", snippetType = "autosnippet" }, fmta("$<>$ ", { i(1) })),
  s({ trig = "mmt", snippetType = "autosnippet" }, fmta("$ <> $ ", { i(1) })),
  s({ trig = "cent" }, fmta("#align(center)[<>]", { i(1) })),
  s({ trig = "v" }, fmta("#let <> = <>", { i(1), i(2) })),
}
