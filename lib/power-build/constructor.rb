require 'colorize'
require 'erb'
require 'ostruct'
require 'json'

module PowerBuild
  class Constructor

    def initialize(config=nil)
      @base = "../../assets"
      variables_set if config
    end

    def build_config
      if File.file? "power-build.config"
        puts "Config file already exists. Either:"
        puts "1. Run 'power build' to build."
        puts "2. Run 'power delete' to delete all."
      else
        @base = "../../assets"
        config = "power-build.config"
        FileUtils.cp File.expand_path("#{@base}/power-build.config", __FILE__), config
        puts "Created: ".green + "power-build.config"
      end
    end

    def copy_assets
      if File.directory? "assets"
        copy_assets_in_order
      else
        ["css", "js", "fonts"].each {|dir| copy_assets_dir dir}
      end
      # copy_assets_dir "css"
      # puts "Created: ".green + "assets/css"
      # copy_assets_dir "js"
      # puts "Created: ".green + "assets/js"
      # copy_assets_dir "fonts"
      # puts "Created: ".green + "assets/fonts"
    end

    def generate_site
      image_collection = collect_images
      @variables.image_collection = image_collection

      @variables.resource_prefix = "../../"
      update_partials
      image_collection.each do |category|
        dir = FileUtils.mkdir_p("assets/#{category[:tag]}").first
        @variables.current_category = category
        content = File.read(File.expand_path("#{@base}/templates/category.html.erb", __FILE__))
        erb = ERB.new(content).result(@variables.instance_eval{binding})
        File.open("#{dir}/index.html", "w") {|file| file.write(erb)}
        puts "Created: ".green + "#{dir}/index.html"
        category[:images].each do |image|
          @variables.current_image = "#{dir}/#{image}"
          @variables.current_image_source = "../../#{@config["root_folder"]}/#{category[:tag]}/#{image}"
          @variables.current_title = image
          @variables.title = @variables.current_title
          content = File.read(File.expand_path("#{@base}/templates/show.html.erb", __FILE__))
          erb = ERB.new(content).result(@variables.instance_eval{binding})
          File.open("#{dir}/#{@variables.current_title}.html", "w") {|file| file.write(erb)}
          puts "Created: ".green + "#{dir}/#{@variables.current_title}.html"
        end
      end

      @variables.title = @config["title"]
      @variables.resource_prefix = ""
      update_partials
      render_page("index")
      puts "Created: ".green + "index.html"
    end

    def remove_config
      if File.file? "power-build.config"
        FileUtils.remove "power-build.config"
        puts "Removed:".red + " power-build.config"
      else
        puts "Config file does not exist."
      end
      if File.directory? "assets"
        FileUtils.rm_rf "assets"
        puts "Removed:".red + " /assets"
      end
      if File.file? "index.html"
        FileUtils.remove "index.html"
        puts "Removed:".red + " index.html"
      end
    end

    def open_config
      if File.file? "power-build.config"
        %x[open power-build.config]
      else
        puts "Config file does not exist."
      end
    end

  private

    def variables_set
      @config = read_config
      @variables = OpenStruct.new(title: @config["title"],
                                  root_folder: @config["root_folder"],
                                  site: @config["site"],
                                  host_link: @config["host_link"],
                                  host_display_text: @config["host_display_text"],
                                  resource_prefix: ""
                                 )
      i18n(@config["language"]).each {|key, value| @variables.send("#{key.to_s}=".to_sym, value) }
    end

    def copy_assets_dir(dir_name)
      dir = File.expand_path("#{@base}/#{dir_name}", __FILE__)
      Dir.mkdir "assets" unless File.directory? "assets"
      FileUtils.copy_entry dir, "assets/#{dir_name}"
    end

    def copy_assets_in_order
      
    end

    def read_config
      begin
        JSON.parse(File.read("power-build.config"))
      rescue JSON::ParserError
        puts "============================================================"
        puts "Oops, make sure 'power-build.config' is in correct JSON format."
        puts "1. Wrap the whole content in brackets {}"
        puts "2. Wrap each key and value with quotes ''"
        puts "3. Separate each setting with comma ,"
        puts "If you can't fix it, run 'power delete' to start over again."
        puts "============================================================"
        raise JSON::ParserError
      end
    end

    def update_partials
      add_partial("head")
      add_partial("navbar")
      add_partial("footer")
    end

    def add_partial(partial)
      content = File.read(File.expand_path("#{@base}/partials/_#{partial}.html.erb", __FILE__))
      rendered = ERB.new(content).result(@variables.instance_eval{binding})
      @variables.send("#{partial}=".to_sym, rendered)
    end

    def render_page(page)
      content = File.read(File.expand_path("#{@base}/templates/#{page}.html.erb", __FILE__))
      erb = ERB.new(content).result(@variables.instance_eval{binding})
      File.open("#{page}.html", "w") {|file| file.write(erb)}
    end

    def collect_images
      collection = []
      root_dir = @config["root_folder"]
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
          collection.push(category)
        end
      end
      return collection
    end

    def i18n(setting)
      case setting
      when "zh-tw"
        {
          i_header: "總覽",
          i_category: "類別",
          i_copyright: "版權所有",
          i_download: "下載",
          i_home: "首頁"
        }
      when "en"
        {
          i_header: "Overview",
          i_category: "Categories",
          i_copyright: "Copyright",
          i_download: "Download",
          i_home: "Home"
        }
      end
    end
  end
end
