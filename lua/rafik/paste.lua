local M = {}

local paste_phase = {
  -- c.f. `:help vim.paste()`
  NON_STREAMING = -1,
  START = 1,
  CONTINUE = 2,
  END = 3,
}

-- Given an implementation of the `vim.paste()` handler, override it so that
-- streaming paste is treated as non-streaming paste.
--
-- This is done by accumulating streamed lines and emitting them as a single
-- non-streaming paste when the streaming paste is ended.
M.force_non_streaming = function(paste)
  local chunks = {}
  return function(lines, phase)
    -- already non-streaming paste: pass-through
    if phase == paste_phase.NON_STREAMING then
      return paste(lines, phase)
    end

    -- start streaming paste: reset chunks
    if phase == paste_phase.START then
      chunks = {}
    end

    -- accumulate lines
    vim.list_extend(chunks, lines)

    -- end streaming paste: paste accumulated chunks and reset
    if phase == paste_phase.END then
      local result = paste(chunks, paste_phase.NON_STREAMING)
      chunks = {}
      return result
    end

    return true
  end
end

return M
