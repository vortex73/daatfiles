local lsp= require("lsp-zero")
lsp.preset("recommended")

local cmp = require("cmp")
local cmp_sel = {behaviour = cmp.SelectBehavior.Select}
local cmp_maps = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_sel),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_sel),
	['<C-c>'] = cmp.mapping.confirm({select = true}),
	['<C-Space>'] = cmp.mapping.complete(),
})
lsp.setup_nvim_cmp({
	mapping = cmp.maps
})
lsp.setup()

