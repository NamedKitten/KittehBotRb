module Debug
  extend Discordrb::Commands::CommandContainer
  command(:eval, help_available: true, description: "Evaluates code.") do |event, *code|
    break unless event.user.id == CONFIG["owner"]

    begin
      eval code.join(" ")
    end
  end
  command(:ping, help_available: false) do |event|
    time = Time.now
    m = event.respond("...")
    ping = ((Time.now - time) * 1000)
    m.edit "Pong! #{ping}ms "
  end
  command(:echo, help_available: true, description: "Echo.") do |event, *text|
    text.join(" ")
  end
end
