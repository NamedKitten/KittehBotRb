require "execjs"

module Debug
  extend Discordrb::Commands::CommandContainer
  command(:eval, help_available: true, description: "Evaluates code.") do |event, *code|
    break unless event.user.id == CONFIG["owner"]

    begin
      eval code.join(" ")
    rescue => e
      message = "```rb\n"
      message += print_stacktrace(e)
      message += "```"
      message
    end
  end

  command(:evaljs, help_available: true, description: "Evaluates code.") do |event, *code|
    break unless event.user.id == CONFIG["owner"]

    begin
      event.respond(ExecJS.eval code.join(" "))
    rescue => e
      message = "```rb\n"
      message += print_stacktrace(e)
      message += "```"
      message
    end
  end
  command(:ping, help_available: false) do |event|
    m = event.respond("Boop!")
    ping = ((Time.now - event.timestamp) * 1000)
    m.edit "Pong! #{ping}ms "
  end
  command(:echo, help_available: true, description: "Echo.") do |event, *text|
    text.join(" ")
  end
end
