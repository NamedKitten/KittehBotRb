def print_stacktrace(e)
  stacktrace = e.backtrace.map do |call|
    if parts = call.match(/^(?<file>.+):(?<line>\d+):in `(?<code>.*)'$/)
      file = parts[:file].sub /^#{Regexp.escape(File.join(Dir.getwd, ""))}/, ""
      line = "#{file} (#{parts[:line]}) #{parts[:code]}"
    else
      line = call
    end
    #line
  end
  message = ""
  stacktrace.each { |line| message += line + "\n" }
  message
end
