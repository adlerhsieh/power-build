require_relative '../lib/power-build'
# require_relative '../lib/power-build/constructor'
# path = "../../lib/power-build/" 
# dir = File.expand_path(path, __FILE__)
# Dir.entries(dir).each do |file|
#   require_relative "../lib/power-build/#{file}" if file.include? ".rb"
# end
RSpec.configure do |config|
  config.color = true
end
