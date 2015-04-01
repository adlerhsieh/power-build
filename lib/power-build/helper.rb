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
