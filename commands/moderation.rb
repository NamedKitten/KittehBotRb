module Moderation
  extend Discordrb::Commands::CommandContainer

  command(:prune, min_args: 1, help_available: true, description: "Prune messages from a channel.") do |event, count|
    if event.author.permission?(:delete_messages, event.channel)
      if event.bot.profile.on(event.server).permission?(:delete_messages, event.channel)
        event.message.delete
        event.channel.prune(count.to_i)
        event.respond("Done!")
      else
        event.respond("I need the delete messages permission so I can provide this service to you.")
      end
    else
      event.respond("You need the delete messages permission to use this command.")
    end
  end
  command(:kick, help_available: true, description: "Kick a member.") do |event|
    if event.author.permission?(:kick_members, event.channel)
      if event.bot.profile.on(event.server).permission?(:kick_members, event.channel)
        if event.message.mentions.length == 0
          return "You need to specify a member to kick."
        else
          event.message.mentions.each do |mention|
            begin
              event.server.kick(mention)
            rescue Discordrb::Errors::NoPermission
              event.respond("Unable to kick " + mention.distinct)
            else
              event.respond("Kicked " + mention.distinct + " Successfully.")
            end
          end
        end
      else
        event.respond("I need the kick members permission so I can provide this service to you.")
      end
    else
      event.respond("You need the kick members permission to use this command.")
    end
    return ""
  end
end
