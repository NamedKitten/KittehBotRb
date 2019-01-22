require "redis"

module Prefixes
  extend Discordrb::Commands::CommandContainer
  redis = Redis.new
  
  command(:prefix, help_available: true, description: "Manage prefixes.") do |event, *args|
    if args[0] == "global"
      if args[1] == "set"
        break unless event.user.id == CONFIG["owner"]
        CONFIG["default_prefix"] = args[2]
        event.respond("Prefix has been set to '" + args[2] + "'")
      else
        event.respond("The current global prefix is '" + CONFIG["default_prefix"] + "'")
      end
    elsif args[0] == "server"
      if args[1] == "set"
        break unless event.channel.server.owner.id == event.author.id || event.user.id == CONFIG["owner"]
        redis.set(String(event.channel.server.id) + "-prefix", args[2])
        event.respond("Prefix has been set to '" + args[2] + "'")
      elsif args[1] == "reset"
        break unless event.channel.server.owner.id == event.author.id || event.user.id == CONFIG["owner"]
        redis.del(String(event.channel.server.id) + "-prefix")
      else
        if redis.get(String(event.channel.server.id) + "-prefix") != nil && redis.get(String(event.channel.server.id) + "-prefix").length.zero
          event.respond("The current server prefix is '" + redis.get(String(event.channel.server.id) + "-prefix") + "'")
        else
          event.respond("This server is using the global prefix of '" + CONFIG["default_prefix"] + "'")
        end
      end
    elsif args[0] == "user"
      if args[1] == "set"
        redis.set(String(event.author.id) + "-prefix", args[2])
        event.respond("Prefix has been set to '" + args[2] + "'")
      elsif args[1] == "reset"
        redis.del(String(event.author.id) + "-prefix")
      else
        if redis.get(String(event.author.id) + "-prefix") != nil && redis.get(String(event.author.id) + "-prefix").length.zero
          event.respond("The current user prefix is '" + redis.get(String(event.author.id) + "-prefix") + "'")
        else
          event.respond("The prefix is currently either the server's default or the global default.")
        end
      end
    else
      event << "```"
      event << "Command Group Help:"
      event << "prefix global set: Sets global bot prefix."
      event << "prefix global: Shows global bot prefix."
      event << "prefix server set: Sets server prefix."
      event << "prefix server reset: Resets server prefix and uses global prefix instead."
      event << "prefix server: Shows current server prefix,"
      event << "prefix user set: Sets current user prefix."
      event << "prefix user reset: Resets user prefix to use either the server's default or the global default."
      event << "prefix user: Shows current user prefix."
      event << "prefix help: Shows this help."
      event << "```"
    end
  end
end
