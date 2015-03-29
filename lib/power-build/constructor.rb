require 'colorize'

module PowerBuild
  class Constructor
    def self.build_config
      base = "../../assets/"
      config = "power-build.config"
      FileUtils.cp File.expand_path("#{base}power-build.config", __FILE__), config
      puts "'power-build.config' is created!"
    end
  end
end
