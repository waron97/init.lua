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
		fmt("<View style={{styles.{1}}}>{0}</View>", {
			i(1, "container"),
			i(0), -- $0: The cursor ends up here inside the tags when you finish
		})
	),

	-- useEffect
	s(
		"effect",
		fmt("useEffect(() => {{{0}}}, [])", {
			i(0), -- $0: Cursor lands right inside the block
		})
	),

	-- useMemo
	s(
		"memo",
		fmt("useMemo(() => {{{0}}}, [])", {
			i(0),
		})
	),

	-- Semantic Log (requires the `rep` node to mirror the first input!)
	s(
		"semlog",
		fmt("console.log('{1}', {2})", {
			i(1, "variable"),
			rep(1),
		})
	),

	-- ESLint Disable
	-- (Since this is just plain text, we don't need `fmt`, just a text node)
	s("esdis", t("// eslint-disable-next-line")),

	-- Redux Token
	s(
		"token",
		fmt("const {{token}} = useSelector{0}(state => state.auth)", {
			i(0),
		})
	),

	-- Import Toolkit
	s("imtk", t("import * as toolkit from '@toolkit'")),
})
