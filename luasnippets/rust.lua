local parse = require("luasnip.util.parser").parse_snippet

return {
  parse({ trig = "pp", dscr = "Pretty-print" }, [[println!("${1:var}: {$1:?}");]]),
  parse({ trig = "dd", dscr = "Derive Debug" }, "#[derive(Debug)]"),
}
