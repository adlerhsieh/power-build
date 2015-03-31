require 'colorize'
require 'pry'
require 'erb'
require 'ostruct'
require 'json'

module PowerBuild
  class Constructor

    def self.build_config
      if File.file? "power-build.config"
        puts "Config file already exists. Either:"
        puts "1. Run 'power build' to build."
        puts "2. Run 'power clean' to delete the config file."
      else
        @base = "../../assets"
        config = "power-build.config"
        FileUtils.cp File.expand_path("#{@base}/power-build.config", __FILE__), config
        puts "Created: ".green + "power-build.config"
      end
    end

    def self.copy_assets
      @base = "../../assets"
      copy_assets_dir "css"
      copy_assets_dir "js"
      copy_assets_dir "fonts"
      puts "Created: ".green + "/assets"
    end

    def self.render_index
      @base = "../../assets"
      config = read_config

      image_collection = []
      root_dir = config["root_folder"]
      dirs = Dir.entries(root_dir)
      dirs.delete(".")
      dirs.delete("..")
      dirs.each do |dir|
        if File.directory? "#{root_dir}/#{dir}"
          images = Dir.entries("#{root_dir}/#{dir}")
          images.delete(".")
          images.delete("..")
          category = {:tag => dir, :images => []}
          images.each do |image|
            if File.file? "#{root_dir}/#{dir}/#{image}"
              if ["jpg", "png", "gif", "peg"].include? image[-3..-1].downcase
                category[:images].push(image)
              end
            end
          end
          image_collection.push(category)
        end
      end

      @variables = OpenStruct.new(title: config["title"],
                                  root_folder: root_dir,
                                  site: config["site"],
                                  image_collection: image_collection
                                 )
      add_partial("head")
      add_partial("navbar")
      add_partial("footer")
      render_page("index")
    end

    def self.remove_config
      if File.file? "power-build.config"
        FileUtils.remove "power-build.config"
        puts "Removed:".red + " power-build.config"
      else
        puts "Config file does not exist."
      end
    end

    def self.open_config
      if File.file? "power-build.config"
        %x[open power-build.config]
      else
        puts "Config file does not exist."
      end
    end

  private
    def self.copy_assets_dir(dir_name)
      dir = File.expand_path("#{@base}/#{dir_name}", __FILE__)
      FileUtils.copy_entry dir, dir_name
    end

    def self.read_config
      JSON.parse(File.read("power-build.config"))
    end

    def self.add_partial(partial)
      content = File.read(File.expand_path("#{@base}/partials/_#{partial}.html.erb", __FILE__))
      @variables.send("#{partial}=".to_sym, ERB.new(content).result(@variables.instance_eval{binding}))
    end

    def self.render_page(page)
      content = File.read(File.expand_path("#{@base}/#{page}.html.erb", __FILE__))
      erb = ERB.new(content).result(@variables.instance_eval{binding})
      File.open("#{page}.html", "w") {|file| file.write(erb)}
    end
  end
end
