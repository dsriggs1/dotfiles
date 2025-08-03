local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {

	s(
		"for",
		{
			t("for (int "),
			i(1, "i"),
			t(" = 0; "),
			i(2, "i < 10"),
			t("; "),
			i(3, "++i"),
			t({ ") {", "    " }),
			i(4, "// code"),
			t({ "", "}" }),
		}
	),
	s("while", { t("while ("), i(1, "condition"), t({ ") {", "    " }), i(2, "// code"), t({ "", "}" }) }),
	s(
		"func",
		{
			i(1, "void"),
			t(" "),
			i(2, "functionName"),
			t("("),
			i(3, "int x"),
			t({ ") {", "    " }),
			i(4, "// code"),
			t({ "", "}" }),
		}
	),
	s("struct", { t("struct "), i(1, "MyStruct"), t({ " {", "    " }), i(2, "int value;"), t({ "", "};" }) }),
	s("typedef", { t("typedef "), i(1, "int"), t(" "), i(2, "myint"), t(";") }),
	s("enum", { t("enum "), i(1, "Color"), t({ " {", "    RED,", "    GREEN,", "    BLUE", "};" }) }),
	s(
		"ife",
		{
			t("if ("),
			i(1, "condition"),
			t({ ") {", "    " }),
			i(2, "// code"),
			t({ "", "} else {", "    " }),
			i(3, "// code"),
			t({ "", "}" }),
		}
	),
	s("main", { t({ "int main() {", "    " }), i(1, "return 0;"), t({ "", "}" }) }),
	s("inc", { t("#include <"), i(1, "stdio.h"), t(">") }),
	s("define", { t("#define "), i(1, "NAME"), t(" "), i(2, "value") }),
	s("macro", { t("#define "), i(1, "SQUARE(x)"), t(" ((x)*(x))") }),
	s("ptr", { i(1, "int"), t(" *"), i(2, "ptr"), t(";") }),
	s("printf", { t('printf("'), i(1, "%d\\n"), t('", '), i(2, "value"), t(");") }),
	s("scanf", { t('scanf("'), i(1, "%d"), t('", &'), i(2, "var"), t(");") }),
	s(
		"guard",
		{
			t("#ifndef "),
			i(1, "HEADER_H"),
			t({ "", "#define " }),
			i(2, "HEADER_H"),
			t({ "", "", "#endif /* " }),
			i(3, "HEADER_H"),
			t(" */"),
		}
	),
}

