local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	-- Minimal NixOS submodule snippet
	s("submod", {
		t("{ ... }:"),
		t({ "", "", "{" }),
		t({ "  programs." }),
		i(1, "name"),
		t(" = {"),
		t({ "", "    enable = true;" }),
		t({ "", "  };" }),
		t({ "", "}" }),
	}),
}

