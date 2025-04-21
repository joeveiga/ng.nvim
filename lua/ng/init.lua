local req = require('ng.requests')

local tcb_content_provider = {
  _buffer = nil,
  _uri = nil,
  _ns = nil,

  update = function(self, uri, content)
    if not self._buffer or not vim.api.nvim_buf_is_loaded(self._buffer) then
      self._buffer = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_set_option_value('buftype', 'nofile', { buf = self._buffer })
      self._ns = vim.api.nvim_create_namespace('ng.nvim')
    end

    -- TODO: find a better way to do this (if it's even needed)
    uri = tostring(uri):gsub('file:///', 'ng:///')
    if self._uri ~= uri then
      self._uri = uri
      vim.api.nvim_buf_set_name(self._buffer, self._uri)
      vim.api.nvim_set_option_value('filetype', 'typescript', { buf = self._buffer })
    end

    vim.api.nvim_buf_set_lines(self._buffer, 0, -1, false, vim.fn.split(content, '\n'))
    vim.api.nvim_set_option_value('modified', false, { buf = self._buffer })
  end,

  show = function(self, ranges)
    vim.cmd.tabnew(self._uri)
    if ranges and #ranges ~= 0 then
      for _, range in ipairs(ranges) do
        vim.highlight.range(
          self._buffer,
          self._ns,
          'Visual',
          { range.start.line, range.start.character },
          { range['end'].line, range['end'].character }
        )
      end

      vim.api.nvim_win_set_cursor(0, { ranges[1].start.line + 1, ranges[1].start.character })
    end
  end,
}

local M = {}

--- Command finds the template for a component.
--
---@param opts table Keys:
--     reuse_window boolean: Jump to existing window if buffer is already open.
M.goto_template_for_component = function(opts)
  opts = opts or {}
  local reuse_window = opts.reuse_window or false
  req.get_template_location_for_component(function(err, result)
    if result then
      vim.lsp.util.show_document(result, 'utf-8', { reuse_win = reuse_window }) -- TODO: get encoding from client
    end
  end)
end

--- Command finds components which reference an external template in
--- their `templateUrl`s.
--
---@param opts table Keys:
--     reuse_window boolean: Jump to existing window if buffer is already open.
M.goto_component_with_template_file = function(opts)
  opts = opts or {}
  local reuse_window = opts.reuse_window or false
  req.get_component_for_open_external_template(function(err, result)
    if result and #result ~= 0 then
      -- If there is more than one component that references the template, show them all. Otherwise
      -- go to the component immediately.
      if #result == 1 then
        vim.lsp.util.show_document(result[1], 'utf-8', { reuse_win = reuse_window }) -- TODO: get encoding from client
      else
        vim.fn.setqflist({}, ' ', {
          title = 'Language Server',
          items = vim.lsp.util.locations_to_items(result, 'utf-8'),
        })
        vim.cmd.copen()
      end
    end
  end)
end

--- Command displays a typecheck block for the template a user has
--- an active selection over, if any.
M.get_template_tcb = function()
  req.get_tcb_under_cursor(function(err, result)
    if result then
      tcb_content_provider:update(result.uri, result.content)
      tcb_content_provider:show(result.selections)
    end
  end)
end

return M
