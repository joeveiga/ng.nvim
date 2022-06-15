local tcb_content_provider = {
  _buffer = nil,
  _uri = nil,

  update = function(self, uri, content)
    if not self._buffer or not vim.api.nvim_buf_is_loaded(self._buffer) then
      self._buffer = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(self._buffer, 'buftype', 'nofile')
    end

    -- TODO: find a better way to do this (if it's even needed)
    uri = tostring(uri):gsub('file:///', 'ng:///')
    if self._uri ~= uri then
      self._uri = uri
      vim.api.nvim_buf_set_name(self._buffer, self._uri)
      vim.api.nvim_buf_set_option(self._buffer, 'filetype', 'typescript')
    end

    vim.api.nvim_buf_set_lines(self._buffer, 0, -1, false, vim.fn.split(content, '\n'))
    vim.api.nvim_buf_set_option(self._buffer, 'modified', false)
  end,

  show = function(self, ranges)
    vim.cmd('tabnew ' .. self._uri)
    if ranges and #ranges ~= 0 then
      P(ranges)
      -- TODO: fix this
      -- for _, range in ipairs(ranges) do
      -- 	vim.highlight.range(
      -- 		self._buffer,
      -- 		-1,
      -- 		"Visual",
      -- 		{ range.start.line, range.start.character },
      -- 		{ range["end"].line, range["end"].character }
      -- 	)
      -- end

      vim.api.nvim_win_set_cursor(0, { ranges[1].start.line + 1, ranges[1].start.character })
    end
  end,
}

local M = {}

--

local execute_command = function(command, callback)
  vim.lsp.buf_request(0, command, vim.lsp.util.make_position_params(0), callback)
end

M.get_template_location_for_component = function(callback)
  execute_command('angular/getTemplateLocationForComponent', callback)
end

M.get_component_for_open_external_template = function(callback)
  execute_command('angular/getComponentsWithTemplateFile', callback)
end

--- Requests a template typecheck block at the current cursor location.
M.get_tcb_under_cursor = function(callback)
  execute_command('angular/getTcb', callback)
end

--

--- Command finds the template for a component.
M.goto_template_for_component = function()
  M.get_template_location_for_component(function(err, result)
    if result then
      vim.lsp.util.jump_to_location(result, 'utf-8') -- TODO: check encoding
    end
  end)
end

--- Command finds components which reference an external template in
--- their `templateUrl`s.
M.goto_component_with_template_file = function()
  M.get_component_for_open_external_template(function(err, result)
    if result then
      -- If there is more than one component that references the template, show them all. Otherwise
      -- go to the component immediately.
      if #result == 1 then
        vim.lsp.util.jump_to_location(result[1], 'utf-8') -- TODO: check encoding
      else
        vim.fn.setqflist({}, ' ', {
          title = 'Language Server',
          items = vim.lsp.util.locations_to_items(result, 'utf-8'),
        })
        vim.api.nvim_command('copen')
      end
    end
  end)
end

--- Command displays a typecheck block for the template a user has
--- an active selection over, if any.
M.get_template_tcb = function()
  M.get_tcb_under_cursor(function(err, result)
    if result then
      tcb_content_provider:update(result.uri, result.content)
      tcb_content_provider:show(result.selections)
    end
  end)
end

return M
