local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {

	s("for", {
		t("for (int "),
		i(1, "i"),
		t(" = 0; "),
		i(2, "i < 10"),
		t("; "),
		i(3, "++i"),
		t({ ") {", "    " }),
		i(4, "// code"),
		t({ "", "}" }),
	}),
	s("while", { t("while ("), i(1, "condition"), t({ ") {", "    " }), i(2, "// code"), t({ "", "}" }) }),
	s("func", {
		i(1, "void"),
		t(" "),
		i(2, "functionName"),
		t("("),
		i(3, "int x"),
		t({ ") {", "    " }),
		i(4, "// code"),
		t({ "", "}" }),
	}),
	s(
		"class",
		{ t("class "), i(1, "ClassName"), t({ " {", "public:", "    " }), i(2, "ClassName();"), t({ "", "};" }) }
	),
	s("try", {
		t({ "try {", "    " }),
		i(1, "// code"),
		t({ "", "} catch (" }),
		i(2, "std::exception& e"),
		t({ ") {", "    " }),
		i(3, "std::cerr << e.what();"),
		t({ "", "}" }),
	}),
	s("ife", {
		t("if ("),
		i(1, "condition"),
		t({ ") {", "    " }),
		i(2, "// code"),
		t({ "", "} else if (" }),
		i(3, "other_condition"),
		t({ ") {", "    " }),
		i(4, "// code"),
		t({ "", "} else {", "    " }),
		i(5, "// code"),
		t({ "", "}" }),
	}),
	s("main", { t({ "int main() {", "    " }), i(1, "return 0;"), t({ "", "}" }) }),
	s("inc", { t("#include <"), i(1, "iostream"), t(">") }),
	s("define", { t("#define "), i(1, "NAME"), t(" "), i(2, "value") }),
	s("typedef", { t("typedef "), i(1, "int"), t(" "), i(2, "myint"), t(";") }),
	s("enum", { t("enum class "), i(1, "Color"), t({ " {", "    RED,", "    GREEN,", "    BLUE", "};" }) }),
	s("struct", { t("struct "), i(1, "MyStruct"), t({ " {", "    " }), i(2, "int value;"), t({ "", "};" }) }),
	s("lambda", { t("auto "), i(1, "func"), t(" = []("), i(2, "int x"), t(") { return "), i(3, "x * 2"), t("; };") }),
	s(
		"template",
		{ t("template <typename "), i(1, "T"), t({ ">", "" }), i(2, "T func(T a) {"), t({ "", "    return a;", "}" }) }
	),
	s("noexcept", {
		t("try {"),
		t({ "", "    " }),
		i(1, "// code"),
		t({ "", "} catch (...) noexcept {", "    " }),
		i(2, "// handle error"),
		t({ "", "}" }),
	}),
	s("using", { t("using "), i(1, "IntList"), t(" = std::vector<"), i(2, "int"), t(">;") }),
}
