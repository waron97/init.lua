local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("javascript", {
	s(
		"rnhc",
		fmt(
			[[
import React from 'react'
import {{ StyleSheet, View, Text }} from "react-native"

// ----------------------------------------------------------------------------

/**
 * @param {{Object}} props
 * @param {{import('react-native').StyleProp<import('react-native').ViewStyle>}} [props.style]
 */
export default function {1}(props) {{

	// -------------------------------------
	// Props Destructuring
	// -------------------------------------

	const {{style}} = props

	// -------------------------------------
	// Hooks
	// -------------------------------------



	// -------------------------------------
	// Effects
	// -------------------------------------



	// -------------------------------------
	// Component Functions
	// -------------------------------------



	// -------------------------------------
	// Component Local Variables
	// -------------------------------------



	// -------------------------------------

	return <View style={{[styles.root, style]}}><Text>Component</Text></View>
}}

// ----------------------------------------------------------------------------

const styles = StyleSheet.create({{root: {{flex: 1}}}})
  ]],
			{
				i(1, "ComponentName"), -- Maps to the {1} placeholder above
			}
		)
	),

	-- Styled View
	s(
		"sv",
		fmt("<View style={{styles.{1}}}>{2}</View>", {
			i(1, "container"),
			i(0), -- This is the 2nd item in the list, so it uses {2}
		})
	),

	-- useEffect
	s(
		"effect",
		fmt("useEffect(() => {{{1}}}, [])", {
			i(0), -- This is the 1st item in the list, so it uses {1}
		})
	),

	-- useMemo
	s(
		"memo",
		fmt("useMemo(() => {{{1}}}, [])", {
			i(0), -- 1st item = {1}
		})
	),

	-- Semantic Log
	s(
		"semlog",
		fmt("console.log('{1}', {2})", {
			i(1, "variable"),
			rep(1), -- 2nd item = {2}
		})
	),

	-- ESLint Disable
	s("esdis", t("// eslint-disable-next-line")),

	-- Redux Token
	s(
		"token",
		fmt("const {{token}} = useSelector{1}(state => state.auth)", {
			i(0), -- 1st item = {1}
		})
	),

	-- Import Toolkit
	s("imtk", t("import * as toolkit from '@toolkit'")),
})
