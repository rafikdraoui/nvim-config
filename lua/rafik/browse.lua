local M = {}

-- Open a web browser at the given URL. If no URL is provided, then it uses the
-- one under the cursor.
M.url = function(url)
  if url == nil or url == "" then
    -- include extra characters that are valid for URLs (`@-@` is used for `@`)
    local isf_save = vim.o.isfname
    vim.opt.isfname:append({ ":", "@-@", "?", "&" })
    url = vim.fn.expand("<cfile>")
    vim.o.isfname = isf_save
  end

  if not string.match(url, "^https?://") then
    return
  end

  vim.ui.open(url)
end

-- Open a web browser for code documentation. The `patterns` table contains URL
-- patterns for a given documentation site. Values derived from `doc`
-- (corresponding to a package/module for which documentation is needed) are
-- interpolated into the patterns to get the documentation URL.
local browse_docs = function(patterns, doc)
  doc = doc or vim.fn.expand("<cword>")
  if doc == "" then
    return
  end
  local package, section = unpack(vim.split(doc, "#"))

  local interpolate = function(pattern)
    return string.gsub(pattern, "{(%w+)}", { package = package, section = section })
  end

  local url = interpolate(patterns.base_url)
  if section then
    local fragment = interpolate(patterns.fragment)
    url = url .. fragment
  end

  M.url(url)
end

-- Open a web browser for the Go documentation of the given package name and
-- (optionally) section. If no argument is given, then it uses the word under
-- the cursor as the package name.
--
-- Examples:
--  1. `golang_docs("http")` opens https://pkg.go.dev/net/http
--  2. `golang_docs("http#Server")` opens https://pkg.go.dev/net/http#Server
M.golang_docs = function(doc)
  local patterns = {
    base_url = "https://pkg.go.dev/{package}",
    fragment = "#{section}",
  }
  browse_docs(patterns, doc)
end

-- Open a web browser for the Python documentation of the given standard
-- library module name and (optionally) section. If no argument is given, then
-- it uses the word under the cursor as the package name.
--
-- Examples:
--  1. `python_docs("json")` opens https://docs.python.org/3/library/json.html
--  2. `python_docs("json#loads")` opens
--      https://docs.python.org/3/library/json.html#json.loads
M.python_docs = function(doc)
  local patterns = {
    base_url = "https://docs.python.org/3/library/{package}.html",
    fragment = "#{package}.{section}",
  }
  browse_docs(patterns, doc)
end

-- Call `rustup doc <topic>`.
M.rust_docs = function(topic)
  local args = vim.split(topic, " ", { trimempty = true })
  local cmd = vim.list_extend({ "rustup", "doc" }, args)
  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify(
          string.format("rustup doc: could not open topic %q", topic),
          vim.log.levels.ERROR
        )
      end
    end,
  })
end

return M
