require 'colorize'
require 'pry'
require 'erb'
require 'ostruct'

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

    def self.render_index
      @base = "../../assets"
      # read_config
      # @title = "圖片戰爭"
      variables = OpenStruct.new(title: "圖片戰爭")
      content = File.read File.expand_path("#{@base}/index.html.erb", __FILE__)
      rendered_erb = ERB.new(content).result(variables.instance_eval{binding})
      File.open("index.html", "w") {|file| file.write(rendered_erb)}
    end

  private
    def self.copy_assets_dir(dir_name)
      dir = File.expand_path("#{@base}/#{dir_name}", __FILE__)
      FileUtils.copy_entry dir, dir_name
    end

    def self.read_config
      json = File.read("power-build.config").as_json
    end
  end
end
