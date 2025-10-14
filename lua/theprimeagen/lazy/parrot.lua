return {
	"frankroeder/parrot.nvim",
	dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
	-- optionally include "folke/noice.nvim" or "rcarriga/nvim-notify" for beautiful notifications
	config = function()
		require("parrot").setup({
			-- Providers must be explicitly set up to make them available.
			providers = {
				openai = {
					name = "openai",
					api_key = os.getenv("OPENAI_API_KEY"),
					endpoint = "https://api.openai.com/v1/chat/completions",
					params = {
						chat = { temperature = 1.1, top_p = 1 },
						command = { temperature = 1.1, top_p = 1 },
					},
					topic = {
						model = "gpt-4.1-nano",
						params = { max_completion_tokens = 64 },
					},
					models = {
						"gpt-4o",
						"o4-mini",
						"gpt-4.1-nano",
					},
				},
			},
			-- Local chat buffer shortcuts
			chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
			chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
			chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
			chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

			-- Option to move the cursor to the end of the file after finished respond
			chat_free_cursor = false,

			-- Default target for  PrtChatToggle, PrtChatNew, PrtContext and the chats opened from the ChatFinder
			-- values: popup / split / vsplit / tabnew
			toggle_target = "popup",

			-- The interactive user input appearing when can be "native" for
			-- vim.ui.input or "buffer" to query the input within a native nvim buffer
			-- (see video demonstrations below)
			user_input_ui = "native",

			hooks = {
				CodeAsk = function(prt, params)
					local chat_prompt = [[
					  Your task is to analyze the provided {{filetype}} code and understand it 
					  throughly to answer questions in the upcoming exchange.
			
					  Here is the code
					  ```{{filetype}}
					  {{filecontent}}
					  ```
					]]
					prt.ChatNew(params, chat_prompt)
				end,
			},
		})
	end,
}
