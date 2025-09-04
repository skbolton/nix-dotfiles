builtins.toJSON {
  "$schema" = "https://opencode.ai/config.json";
  model = "zionlab/qwen3-coder:30b-a3b";
  provider.zionlab = {
    npm = "@ai-sdk/openai-compatible";
    options = {
      baseURL = "http://zen5950.home.arpa:11434/v1";
    };
    models = {
      "qwen3-coder:30b-a3b" = {
        tools = true;
      };
    };
  };
}
