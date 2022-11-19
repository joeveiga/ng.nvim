local M = {}

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

M.is_in_angular_project = function(callback)
  execute_command('angular/isAngularCoreInOwningProject', callback)
end

return M
