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
