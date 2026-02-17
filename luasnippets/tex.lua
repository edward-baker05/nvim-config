local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- Helper function to get current date
local function get_date(format)
  return os.date(format)
end

return {
  -- Boilerplate document
  s({trig = "bp", dscr = "Boilerplate LaTeX document"},
    fmta([[
\documentclass[12pt, letterpaper]{article}

\title{<> \\[1ex] \large <>}
\author{Edward Baker}
\date{<>}

\begin{document}
    \maketitle
    <>
\end{document}
    ]], {
      i(1),
      i(2),
      f(function() return get_date("%d-%m-%Y") end, {}),
      i(0),
    })
  ),

  -- Begin/end environment
  s({trig = "beg", dscr = "begin{} / end{}"},
    fmta([[
\begin{<>}
    <>
\end{<>}
    ]], {
      i(1),
      i(0),
      rep(1),
    })
  ),

  -- Today's date
  s({trig = "today", dscr = "Current date"},
    f(function() return get_date("%d-%m-%Y") end, {})
  ),

  -- Inline math with smart spacing
  s({trig = "mk", dscr = "Inline math", wordTrig = true},
    fmta("$<>$<>", {
      i(1),
      d(2, function(args, snip)
        -- Get the character after the snippet
        local line = snip.env.LINE or ""
        local col = snip.env.COL or 1
        local next_char = line:sub(col, col)

        -- Add space if next character is not punctuation or space
        if next_char and next_char ~= "" and not next_char:match("[,.?%-%s]") then
          return sn(nil, { t(" "), i(1) })
        else
          return sn(nil, { i(1) })
        end
      end)
    })
  ),

  -- Display math
  s({trig = "dm", dscr = "Display math", wordTrig = true},
    fmta([[
\[
<>
.\] <>
    ]], {
      i(1),
      i(0),
    })
  ),

  -- Lecture
  s({trig = "lec", dscr = "Lecture"},
    fmta([[\lecture{<>}{<>}{<>}]], {
      i(1),
      f(function() return get_date("%d-%m-%y") end, {}),
      i(0),
    })
  ),
}
