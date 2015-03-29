require 'colorize'
require 'pry'

module PowerBuild
  class Constructor

    
    def self.build_config
      @base = "../../assets"
      config = "power-build.config"
      FileUtils.cp File.expand_path("#{@base}/power-build.config", __FILE__), config
      puts "'power-build.config' is created!"
    end

    def self.copy_assets
      @base = "../../assets"
      copy_assets_dir "css"
      copy_assets_dir "js"
      copy_assets_dir "fonts"
      puts "Assets folders are copied!"
    end

  private
    def self.copy_assets_dir(dir_name)
      dir = File.expand_path("#{@base}/#{dir_name}", __FILE__)
      FileUtils.copy_entry dir, dir_name
    end
  end
end
