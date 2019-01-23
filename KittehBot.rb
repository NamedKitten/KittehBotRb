require "discordrb"
require "yaml"

CONFIG = YAML.load_file("config.yaml")
require "redis"
redis = Redis.new

require_relative "lib/print_stacktrace"

def save_config()
  File.open("config.yaml", "w") { |file| file.write(CONFIG.to_yaml) }
end

prefix_proc = proc do |message|
  bot_mention = "<@#{CONFIG["bot_id"]}> "
  if message.content =~ /\A#{bot_mention}/
    message.content[bot_mention.size..-1]
  else
    prefix = redis.get(String(message.author.id) + "-prefix")
    if (!message.channel.pm?)
      prefix = prefix || redis.get(String(message.channel.server.id) + "-prefix")
    end
    prefix = prefix || CONFIG["default_prefix"]
    message.content[prefix.size..-1] if message.content.start_with?(prefix)
  end
end

rescue_proc = proc do |event, e|
  message = "```rb\n"
  message += print_stacktrace(e)
  message += "```"
  event.send(message)
end

bot = Discordrb::Commands::CommandBot.new token: CONFIG["token"], prefix: prefix_proc, advanced_functionality: true, rescue: rescue_proc
require_relative "commands/prefixes"
require_relative "commands/info_utils"
require_relative "commands/debug"
bot.include! Prefixes
bot.include! InfoUtils
bot.include! Debug

bot.run
