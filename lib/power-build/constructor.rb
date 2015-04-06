require 'colorize'
require 'erb'
require 'ostruct'
require 'json'
require 'power-build/helper'
require 'power-build/i18n'

# module PowerBuild
  class Constructor
    def initialize(config=nil)
      @assets_base = "../../assets"
      variables_set if config
    end

    def build_config
      @assets_base = "../../assets"
      config = "power-build.config"
      FileUtils.cp File.expand_path("#{@assets_base}/power-build.config", __FILE__), config
      puts "Created: ".green + "power-build.config"
    end

    def copy_assets
      if File.directory? "assets"
        copy_assets_in_order
      else
        ["css", "js", "fonts"].each do |dir| 
          copy_assets_dir dir
          puts "Created: ".green + "assets/#{dir}"
        end
      end
    end

    def generate_site
      image_collection = collect_images
      @variables.image_collection = image_collection

      @variables.resource_prefix = "../../"
      update_partials
      image_collection.each do |category|
        create_page_by(category)
        category[:images].each do |image|
          create_page_by_each(category, image)
        end
      end

      @variables.title = @config["title"]
      @variables.resource_prefix = ""
      update_partials
      render_("index")
      puts "Created: ".green + "index.html"
    end

    def remove_config
      puts "remove config is executed".red
      if File.file? "power-build.config"
        FileUtils.remove "power-build.config"
        puts "Removed:".red + " power-build.config"
      end
      if File.directory? "assets"
        FileUtils.rm_rf "assets"
        puts "Removed:".red + " assets"
      end
      if File.file? "index.html"
        FileUtils.remove "index.html"
        puts "Removed:".red + " index.html"
      end
    end

  private

    def variables_set
      @config = Helper.read_config
      @variables = OpenStruct.new(title: @config["title"],
                                  root_folder: @config["root_folder"],
                                  site: @config["site"],
                                  host_link: @config["host_link"],
                                  host_display_text: @config["host_display_text"],
                                  resource_prefix: "",
                                  copyright_display: @config["Copyright Display"]
                                 )
      I18n.load(@config["language"]).each {|key, value| @variables.send("#{key.to_s}=".to_sym, value) }
    end

    def copy_assets_dir(dir_name)
      dir = File.expand_path("#{@assets_base}/#{dir_name}", __FILE__)
      Dir.mkdir "assets" unless File.directory? "assets"
      FileUtils.copy_entry dir, "assets/#{dir_name}"
    end

    def copy_assets_in_order
      ["css", "js", "fonts"].each do |dir|
        directory = File.expand_path("#{@assets_base}/#{dir}", __FILE__)
        Dir.entries(directory).each do |entry|
          next if [".", ".."].include? entry
          if File.file? "assets/#{dir}/#{entry}"
            puts "Skipped: assets/#{dir}/#{entry}"
          else
            FileUtils.copy "#{directory}/#{entry}", "assets/#{dir}/#{entry}"
            puts "Created: ".green + "assets/#{dir}/#{entry}"
          end
        end
      end
    end

    def update_partials
      add_partial("head")
      add_partial("navbar")
      add_partial("footer")
    end

    def add_partial(partial)
      content = File.read(File.expand_path("#{@assets_base}/partials/_#{partial}.html.erb", __FILE__))
      rendered = ERB.new(content).result(@variables.instance_eval{binding})
      @variables.send("#{partial}=".to_sym, rendered)
    end

    def collect_images
      collection = []
      root_dir = @config["root_folder"]
      dirs = Dir.entries(root_dir).delete_folder_extra
      dirs.each do |dir|
        if File.directory? "#{root_dir}/#{dir}"
          images = Dir.entries("#{root_dir}/#{dir}").delete_folder_extra
          category = {:tag => dir, :images => []}
          images.each do |image|
            if File.file?("#{root_dir}/#{dir}/#{image}")
              category[:images].push(image) if ["jpg", "png", "gif", "peg"].include? image[-3..-1].downcase
            end
          end
          collection.push(category)
        end
      end
      uncategorized = {:tag => @variables[:i_uncategorized], :images => []}
      dirs.each do |image|
        if File.file?("#{root_dir}/#{image}") && image.include?(".")
          uncategorized[:images].push(image) if ["jpg", "png", "gif", "peg"].include? image[-3..-1].downcase
        end
      end
      collection.push(uncategorized) if uncategorized[:images].length > 0

      return collection
    end

    def variables_set_by(category)
      @dir = FileUtils.mkdir_p("assets/#{category[:tag]}").first
      @variables.current_category = category
      if category[:tag] == @variables[:i_uncategorized] 
        @variables.bridge = ""
      else
        @variables.bridge = "/#{category[:tag]}"
      end
    end

    def variables_set_by_each(category, image)
      @variables.current_image = "#{@dir}/#{image}"
      bridge = category[:tag] == @variables[:i_uncategorized] ? "" : "/#{category[:tag]}"
      @variables.current_image_source = "../../#{@config["root_folder"]}#{bridge}/#{image}"
      @variables.current_title = image
      @variables.title = @variables.current_title
    end

    def create_page_by(category)
      variables_set_by(category)
      content = File.read(File.expand_path("#{@assets_base}/templates/category.html.erb", __FILE__))
      erb = ERB.new(content).result(@variables.instance_eval{binding})
      File.open("#{@dir}/index.html", "w") {|file| file.write(erb)}
      puts "Created: ".green + "#{@dir}/index.html"
    end

    def create_page_by_each(category, image)
      variables_set_by_each(category, image)
      content = File.read(File.expand_path("#{@assets_base}/templates/show.html.erb", __FILE__))
      erb = ERB.new(content).result(@variables.instance_eval{binding})
      File.open("#{@dir}/#{@variables.current_title}.html", "w") {|file| file.write(erb)}
      puts "Created: ".green + "#{@dir}/#{@variables.current_title}.html"
    end

    def render_(index)
      content = File.read(File.expand_path("#{@assets_base}/templates/index.html.erb", __FILE__))
      erb = ERB.new(content).result(@variables.instance_eval{binding})
      File.open("index.html", "w") {|file| file.write(erb)}
    end

  end
# end
