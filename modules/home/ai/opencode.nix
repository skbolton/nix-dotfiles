builtins.toJSON {
  "$schema" = "https://opencode.ai/config.json";
  model = "zionlab/MiniMax-M2";
  keybinds = {
    input_newline = "return";
    input_submit = "ctrl+y";
  };
  provider.zionlab = {
    npm = "@ai-sdk/openai-compatible";
    options = {
      baseURL = "https://zaia.zionlab.online/v1";
      headers = {
        CF-Access-Client-Secret = "{env:ZAIA_CLIENT_SECRET}";
        CF-Access-Client-Id = "{env:ZAIA_CLIENT_ID}";
      };
    };
    models = {
      "qwen3-coder:30b-a3b" = {
        tools = true;
      };
      "MiniMax-M2" = {
        tools = true;
        reasoning = true;
        tool_call = true;
        cost = {
          input = 0.255;
          output = 1.02;
        };
      };
    };
  };
}
