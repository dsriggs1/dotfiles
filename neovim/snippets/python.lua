local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("for", {
    t("for "), i(1, "i"), t(" in "), i(2, "range(10)"), t({ ":", "\t" }),
    i(3, "pass"),
  }),
}
