require "filesize"

module InfoUtils
  extend Discordrb::Commands::CommandContainer
  command(:serverinfo, help_available: true, description: "Tells stuff about the server.") do |event|
    event.channel.send_embed do |e|
      e.title = "Server info"
      e.description = "Thanks for using KittehBotRb"
      e.color = "FFAAFF"
      verif_level = " "
      case event.channel.server.verification_level
      when :none
        verif_level = "None"
      when :low
        verif_level = "Low"
      when :medium
        verif_level = "Medium"
      when :high
        verif_level = "(╯°□°）╯︵ ┻━┻"
      when :very_high
        verif_level = "┻━┻ミヽ(ಠ益ಠ)ﾉ彡┻━┻"
      end
      e.add_field(name: "Verification Level", value: verif_level, inline: true)
      e.add_field(name: "ID", value: event.channel.server.id, inline: true)
      e.thumbnail = {url: event.channel.server.icon_url} unless event.channel.server.icon_url.length.zero?
      e.add_field(name: "Members", value: event.channel.server.member_count, inline: true)
      bots = 0
      humans = 0
      event.channel.server.members.each do |member|
        if (member.bot_account)
          bots += 1
        else
          humans += 1
        end
      end
      if (bots == 0)
        e.add_field(name: "Humans to Bots ratio", value: "No bots.", inline: true)
      elsif (bots < humans)
        e.add_field(name: "Bots to Humans ratio", value: "1:" + String(humans / bots), inline: true)
      else
        e.add_field(name: "Humans to Bots ratio", value: "1:" + String(bots / humans), inline: true)
      end
      e.add_field(name: "Owner", value: event.channel.server.owner.distinct, inline: true)
      e.add_field(name: "Region", value: event.channel.server.region, inline: true)
      e.add_field(name: "Channels Count", value: event.channel.server.channels.length, inline: true)
    end
  end

  command(:attachmentsInfo, help_available: true, description: "Tells you info about all attachments in the command message.") do |event|
    event.message.attachments.each do |attachment|
      event.channel.send_embed do |e|
        e.title = "Attachment"
        e.add_field(name: "Filename", value: attachment.filename, inline: true)
        e.add_field(name: "Image?", value: attachment.image?, inline: true)
        e.add_field(name: "Height", value: attachment.height, inline: true) unless !attachment.image?
        e.add_field(name: "Width", value: attachment.width, inline: true) unless !attachment.image?
        e.add_field(name: "Size", value: Filesize.from(String(attachment.size) + "B").pretty, inline: true)
        e.image = {url: attachment.url} unless !attachment.image?
      end
    end
  end

  command(:about, help_available: true, description: "Tells stuff about the boat.") do |event|
    event.channel.send_embed do |e|
      e.title = "Bot Info"
      e.description = "Thanks for using KittehBotRb"
      e.color = "FFAAFF"
      e.add_field(name: "Ruby Version", value: RUBY_DESCRIPTION, inline: true)
      e.add_field(name: "DiscordRb Version", value: Gem.loaded_specs["discordrb"].version, inline: true)
      e.add_field(name: "Redis Version", value: Gem.loaded_specs["redis"].version, inline: true)

      if (RUBY_DESCRIPTION.include? "+JIT")
        jitText = "Running at the speed of JIT"
      else
        jitText = "JIT disabled. 3:"
      end
      e.add_field(name: "JIT", value: jitText, inline: true)
    end
  end

  command(:inxi, help_available: true, description: "Shows info about my system.") do |event|
    event.respond((("```apache\n" + `inxi -v1` + "\n```").gsub! "[", "").gsub! "]", "")
  end
end
