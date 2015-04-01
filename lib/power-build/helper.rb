module PowerBuild
  class Helper

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
end
