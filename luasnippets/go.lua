local parse = require("luasnip.util.parser").parse_snippet

return {
  parse({ trig = "pp", dscr = "Pretty-print" }, [[fmt.Printf("${1:var}: %+v\n", $1)]]),

  parse(
    { trig = "tf", dscr = "Test function" },
    [[
      func Test${1:Name}(t *testing.T) {
          ${2:t.Fatal("TODO")}
      }
    ]]
  ),

  parse(
    { trig = "tt", dscr = "Test table" },
    [[
      tests := []struct {
          name string
      }{
          {
              name: "NAME",
          },
      }

      for _, tt := range tests {
          t.Run(tt.name, func(t *testing.T) {
              t.Fatal("TODO")
          })
      }
      ]]
  ),

  parse(
    { trig = "cmp", dscr = "go-cmp diff assertion" },
    [[
      if diff := cmp.Diff(${1:want}, ${2:got}); diff != "" {
          t.Fatalf("mismatch (-want +got):\n%s", diff)
      }
    ]]
  ),

  parse(
    { trig = "hh", dscr = "HTTP handler" },
    [[
      func $1(w http.ResponseWriter, r *http.Request) {
          $0
      }
    ]]
  ),

  parse({ trig = "jt", dscr = "JSON struct tag" }, [[`json:"${1:name}"`]]),

  parse(
    { trig = "werr", dscr = "Return wrapped error" },
    [[return $2fmt.Errorf("$1: %w", err)]]
  ),
}
