local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

return {
	-- Basic SELECT queries
	s("sel", { t("SELECT "), i(1, "*"), t(" FROM "), i(2, "table"), t(" WHERE "), i(3, "condition"), t(";") }),
	s("sela", { t("SELECT * FROM "), i(1, "table"), t(";") }),
	s("selc", { t("SELECT COUNT(*) FROM "), i(1, "table"), t(";") }),
	s("seld", { t("SELECT DISTINCT "), i(1, "column"), t(" FROM "), i(2, "table"), t(";") }),
	s("sell", {
		t("SELECT "),
		i(1, "*"),
		t(" FROM "),
		i(2, "table"),
		t({ "", "LIMIT " }),
		i(3, "10"),
		t(";"),
	}),
	s("selwl", {
		t("SELECT "),
		i(1, "*"),
		t(" FROM "),
		i(2, "table"),
		t({ "", "WHERE " }),
		i(3, "condition"),
		t({ "", "LIMIT " }),
		i(4, "10"),
		t(";"),
	}),

	-- JOINs
	s("join", {
		t("INNER JOIN "),
		i(1, "table2"),
		t(" ON "),
		i(2, "table1.id"),
		t(" = "),
		i(3, "table2.id"),
	}),
	s("leftjoin", {
		t("LEFT JOIN "),
		i(1, "table2"),
		t(" ON "),
		i(2, "table1.id"),
		t(" = "),
		i(3, "table2.id"),
	}),
	s("rightjoin", {
		t("RIGHT JOIN "),
		i(1, "table2"),
		t(" ON "),
		i(2, "table1.id"),
		t(" = "),
		i(3, "table2.id"),
	}),

	-- INSERT
	s("ins", {
		t("INSERT INTO "),
		i(1, "table"),
		t(" ("),
		i(2, "column1, column2"),
		t({ ")", "VALUES (" }),
		i(3, "value1, value2"),
		t(");"),
	}),
	s("inssel", {
		t("INSERT INTO "),
		i(1, "table"),
		t(" ("),
		i(2, "columns"),
		t({ ")", "SELECT " }),
		i(3, "columns"),
		t(" FROM "),
		i(4, "source_table"),
		t(";"),
	}),

	-- UPDATE
	s("upd", {
		t("UPDATE "),
		i(1, "table"),
		t({ "", "SET " }),
		i(2, "column"),
		t(" = "),
		i(3, "value"),
		t({ "", "WHERE " }),
		i(4, "condition"),
		t(";"),
	}),

	-- DELETE
	s("del", { t("DELETE FROM "), i(1, "table"), t(" WHERE "), i(2, "condition"), t(";") }),

	-- CREATE TABLE
	s("createtable", {
		t("CREATE TABLE "),
		i(1, "table_name"),
		t({ " (", "    " }),
		i(2, "id"),
		t(" INT AUTO_INCREMENT PRIMARY KEY,"),
		t({ "", "    " }),
		i(3, "column1"),
		t(" "),
		i(4, "VARCHAR(255)"),
		t(" NOT NULL,"),
		t({ "", "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP", ");" }),
	}),
	s("createtableif", {
		t("CREATE TABLE IF NOT EXISTS "),
		i(1, "table_name"),
		t({ " (", "    " }),
		i(2, "id"),
		t(" INT AUTO_INCREMENT PRIMARY KEY,"),
		t({ "", "    " }),
		i(3, "column1"),
		t(" "),
		i(4, "VARCHAR(255)"),
		t({ "", ");" }),
	}),

	-- ALTER TABLE
	s("addcol", {
		t("ALTER TABLE "),
		i(1, "table"),
		t(" ADD COLUMN "),
		i(2, "column_name"),
		t(" "),
		i(3, "VARCHAR(255)"),
		t(";"),
	}),
	s("dropcol", { t("ALTER TABLE "), i(1, "table"), t(" DROP COLUMN "), i(2, "column_name"), t(";") }),
	s("modcol", {
		t("ALTER TABLE "),
		i(1, "table"),
		t(" MODIFY COLUMN "),
		i(2, "column_name"),
		t(" "),
		i(3, "VARCHAR(255)"),
		t(";"),
	}),
	s("renamecol", {
		t("ALTER TABLE "),
		i(1, "table"),
		t(" RENAME COLUMN "),
		i(2, "old_name"),
		t(" TO "),
		i(3, "new_name"),
		t(";"),
	}),

	-- INDEXES
	s("createindex", {
		t("CREATE INDEX "),
		i(1, "idx_name"),
		t(" ON "),
		i(2, "table"),
		t(" ("),
		i(3, "column"),
		t(");"),
	}),
	s("createuniqueindex", {
		t("CREATE UNIQUE INDEX "),
		i(1, "idx_name"),
		t(" ON "),
		i(2, "table"),
		t(" ("),
		i(3, "column"),
		t(");"),
	}),
	s("dropindex", { t("DROP INDEX "), i(1, "idx_name"), t(" ON "), i(2, "table"), t(";") }),
	s("showindexes", { t("SHOW INDEXES FROM "), i(1, "table"), t(";") }),

	-- STATS / ANALYZE
	s("analyze", { t("ANALYZE TABLE "), i(1, "table"), t(";") }),
	s("optimize", { t("OPTIMIZE TABLE "), i(1, "table"), t(";") }),
	s("check", { t("CHECK TABLE "), i(1, "table"), t(";") }),
	s("repair", { t("REPAIR TABLE "), i(1, "table"), t(";") }),

	-- AGGREGATIONS
	s("count", { t("COUNT("), i(1, "*"), t(")") }),
	s("sum", { t("SUM("), i(1, "column"), t(")") }),
	s("avg", { t("AVG("), i(1, "column"), t(")") }),
	s("max", { t("MAX("), i(1, "column"), t(")") }),
	s("min", { t("MIN("), i(1, "column"), t(")") }),

	-- GROUP BY
	s("groupby", {
		t("SELECT "),
		i(1, "column"),
		t(", COUNT(*)"),
		t({ "", "FROM " }),
		i(2, "table"),
		t({ "", "GROUP BY " }),
		i(3, "column"),
		t(";"),
	}),
	s("groupbyhaving", {
		t("SELECT "),
		i(1, "column"),
		t(", COUNT(*) as cnt"),
		t({ "", "FROM " }),
		i(2, "table"),
		t({ "", "GROUP BY " }),
		i(3, "column"),
		t({ "", "HAVING cnt > " }),
		i(4, "1"),
		t(";"),
	}),

	-- ORDER BY
	s("orderby", { t("ORDER BY "), i(1, "column"), t(" "), c(2, { t("ASC"), t("DESC") }) }),

	-- CASE statement
	s("case", {
		t({ "CASE", "    WHEN " }),
		i(1, "condition1"),
		t(" THEN "),
		i(2, "result1"),
		t({ "", "    WHEN " }),
		i(3, "condition2"),
		t(" THEN "),
		i(4, "result2"),
		t({ "", "    ELSE " }),
		i(5, "default_result"),
		t({ "", "END" }),
	}),

	-- CTEs (Common Table Expressions)
	s("with", {
		t("WITH "),
		i(1, "cte_name"),
		t({ " AS (", "    SELECT " }),
		i(2, "*"),
		t(" FROM "),
		i(3, "table"),
		t({ "", ")" }),
		t({ "", "SELECT * FROM " }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t(";"),
	}),

	-- Window functions
	s("rownumber", {
		t("ROW_NUMBER() OVER (PARTITION BY "),
		i(1, "column"),
		t(" ORDER BY "),
		i(2, "column"),
		t(")"),
	}),
	s("rank", { t("RANK() OVER (ORDER BY "), i(1, "column"), t(")") }),
	s("denserank", { t("DENSE_RANK() OVER (ORDER BY "), i(1, "column"), t(")") }),

	-- DESCRIBE and SHOW
	s("desc", { t("DESCRIBE "), i(1, "table"), t(";") }),
	s("show", { t("SHOW TABLES;") }),
	s("showdb", { t("SHOW DATABASES;") }),
	s("showcreate", { t("SHOW CREATE TABLE "), i(1, "table"), t(";") }),

	-- TRANSACTIONS
	s("begin", { t("BEGIN;") }),
	s("commit", { t("COMMIT;") }),
	s("rollback", { t("ROLLBACK;") }),
	s("transaction", {
		t({ "BEGIN;", "" }),
		i(1, "-- SQL statements"),
		t({ "", "COMMIT;" }),
	}),

	-- CONSTRAINTS
	s("primarykey", { t("PRIMARY KEY ("), i(1, "column"), t(")") }),
	s("foreignkey", {
		t("FOREIGN KEY ("),
		i(1, "column"),
		t(") REFERENCES "),
		i(2, "table"),
		t("("),
		i(3, "column"),
		t(")"),
	}),
	s("unique", { t("UNIQUE ("), i(1, "column"), t(")") }),
	s("notnull", { t("NOT NULL") }),

	-- SUBQUERIES
	s("subquery", {
		t("SELECT "),
		i(1, "*"),
		t({ "", "FROM " }),
		i(2, "table1"),
		t({ "", "WHERE " }),
		i(3, "column"),
		t({ " IN (", "    SELECT " }),
		i(4, "column"),
		t(" FROM "),
		i(5, "table2"),
		t({ "", ")" }),
		t(";"),
	}),

	-- UNION
	s("union", {
		t("SELECT "),
		i(1, "*"),
		t(" FROM "),
		i(2, "table1"),
		t({ "", "UNION", "SELECT " }),
		i(3, "*"),
		t(" FROM "),
		i(4, "table2"),
		t(";"),
	}),
	s("unionall", {
		t("SELECT "),
		i(1, "*"),
		t(" FROM "),
		i(2, "table1"),
		t({ "", "UNION ALL", "SELECT " }),
		i(3, "*"),
		t(" FROM "),
		i(4, "table2"),
		t(";"),
	}),

	-- DROP
	s("droptable", { t("DROP TABLE IF EXISTS "), i(1, "table"), t(";") }),
	s("truncate", { t("TRUNCATE TABLE "), i(1, "table"), t(";") }),

	-- MYSQL/MariaDB specific
	s("usedb", { t("USE "), i(1, "database"), t(";") }),
	s("createdb", { t("CREATE DATABASE IF NOT EXISTS "), i(1, "database"), t(";") }),
	s("dropdb", { t("DROP DATABASE IF EXISTS "), i(1, "database"), t(";") }),
	s("explain", { t("EXPLAIN SELECT "), i(1, "*"), t(" FROM "), i(2, "table"), t(";") }),
	s("explainanalyze", { t("EXPLAIN ANALYZE SELECT "), i(1, "*"), t(" FROM "), i(2, "table"), t(";") }),

	-- Date/Time functions
	s("now", { t("NOW()") }),
	s("curdate", { t("CURDATE()") }),
	s("curtime", { t("CURTIME()") }),
	s("dateadd", { t("DATE_ADD("), i(1, "date"), t(", INTERVAL "), i(2, "1"), t(" "), c(3, { t("DAY"), t("MONTH"), t("YEAR"), t("HOUR") }), t(")") }),
	s("datesub", { t("DATE_SUB("), i(1, "date"), t(", INTERVAL "), i(2, "1"), t(" "), c(3, { t("DAY"), t("MONTH"), t("YEAR"), t("HOUR") }), t(")") }),
	s("datediff", { t("DATEDIFF("), i(1, "date1"), t(", "), i(2, "date2"), t(")") }),
}
