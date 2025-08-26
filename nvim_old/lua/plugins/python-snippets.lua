-- Enhanced Python snippets
return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    -- Python-specific snippets
    ls.add_snippets("python", {
      -- Main guard
      s("main", {
        t("if __name__ == \"__main__\":"),
        t({"", "    "}),
        i(1, "main()"),
      }),
      
      -- Class with init
      s("class", {
        t("class "),
        i(1, "ClassName"),
        t("("),
        i(2, "object"),
        t("):"),
        t({"", "    \"\"\""}),
        i(3, "Class description"),
        t({"\"\"\"", "    ", "    def __init__(self"}),
        i(4),
        t("):"),
        t({"", "        "}),
        i(5, "pass"),
      }),
      
      -- Function with docstring
      s("def", {
        t("def "),
        i(1, "function_name"),
        t("("),
        i(2),
        t("):"),
        t({"", "    \"\"\""}),
        i(3, "Function description"),
        t({"", "    ", "    Args:", "        "}),
        i(4, "arg: Description"),
        t({"", "    ", "    Returns:", "        "}),
        i(5, "Description"),
        t({"", "    \"\"\"", "    "}),
        i(6, "pass"),
      }),
      
      -- Try-except block
      s("try", {
        t("try:"),
        t({"", "    "}),
        i(1, "# code that might raise an exception"),
        t({"", "except "}),
        i(2, "Exception"),
        t(" as "),
        i(3, "e"),
        t(":"),
        t({"", "    "}),
        i(4, "# handle exception"),
      }),
      
      -- Type hints import
      s("typing", {
        t("from typing import "),
        i(1, "List, Dict, Optional, Union"),
      }),
      
      -- Dataclass
      s("dataclass", {
        t("from dataclasses import dataclass"),
        t({"", "", "@dataclass"}),
        t({"", "class "}),
        i(1, "ClassName"),
        t(":"),
        t({"", "    "}),
        i(2, "field: str"),
      }),
      
      -- Pytest test function
      s("test", {
        t("def test_"),
        i(1, "function_name"),
        t("():"),
        t({"", "    \"\"\"Test "}),
        f(function(args) return args[1][1] end, {1}),
        t(".\"\"\""),
        t({"", "    # Arrange", "    "}),
        i(2, "# setup test data"),
        t({"", "    # Act", "    "}),
        i(3, "# call function under test"),
        t({"", "    # Assert", "    "}),
        i(4, "assert result == expected"),
      }),
      
      -- Property decorator
      s("property", {
        t("@property"),
        t({"", "def "}),
        i(1, "property_name"),
        t("(self):"),
        t({"", "    \"\"\""}),
        i(2, "Property description"),
        t(".\"\"\""),
        t({"", "    return self._"}),
        f(function(args) return args[1][1] end, {1}),
      }),
      
      -- Lambda function
      s("lambda", {
        t("lambda "),
        i(1, "x"),
        t(": "),
        i(2, "x"),
      }),
      
      -- List comprehension
      s("lc", {
        t("["),
        i(1, "item"),
        t(" for "),
        i(2, "item"),
        t(" in "),
        i(3, "iterable"),
        t("]"),
      }),
      
      -- Dictionary comprehension
      s("dc", {
        t("{"),
        i(1, "key"),
        t(": "),
        i(2, "value"),
        t(" for "),
        i(3, "key, value"),
        t(" in "),
        i(4, "iterable"),
        t("}"),
      }),
      
      -- Import statement
      s("imp", {
        t("import "),
        i(1, "module"),
      }),
      
      -- From import statement
      s("from", {
        t("from "),
        i(1, "module"),
        t(" import "),
        i(2, "function"),
      }),
      
      -- Print with f-string
      s("pf", {
        t("print(f\""),
        i(1, "text {variable}"),
        t("\")"),
      }),
      
      -- Context manager (with statement)
      s("with", {
        t("with "),
        i(1, "expression"),
        t(" as "),
        i(2, "variable"),
        t(":"),
        t({"", "    "}),
        i(3, "pass"),
      }),
    })
  end,
}
