class Helper
  def self.read_config
    begin
      JSON.parse(File.read("power-build.config"))
    rescue JSON::ParserError
      puts "Syntax Error in config file".red
      puts "Make sure 'power-build.config' is in correct JSON format."
      puts "1. Wrap the whole content in brackets {}"
      puts "2. Wrap each key and value with quotes ''"
      puts "3. Separate each setting with comma ,"
      puts "If you can't fix it, run 'power delete' to start over again."
      abort
    end
  end
end

class I18n
  def self.load(setting) 
    case setting
    when "zh-tw"
      {
        i_header: "總覽",
        i_category: "類別",
        i_copyright: "版權所有",
        i_download: "下載",
        i_home: "首頁",
        i_uncategorized: "綜合",
        i_copy: "複製圖片連結"
      }
    when "en"
      {
        i_header: "Overview",
        i_category: "Categories",
        i_copyright: "Copyright",
        i_download: "Download",
        i_home: "Home",
        i_uncategorized: "Uncategorized",
        i_copy: "Copy"
      }
    end
  end
end

class Array
  def delete_folder_extra
    array = self
    array.delete(".")
    array.delete("..")
    array.delete(".DS_Store")
    array.delete(".gitignore")
    return array
  end
end
