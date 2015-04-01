class I18n
  def self.load(setting) 
      #                   zh-tw           en
      text_object = {
        i_header:        ["總覽",         "Overview"],
        i_category:      ["類別",         "Categories"],
        i_copyright:     ["版權所有",     "Copyright"],
        i_download:      ["下載",         "Download"],
        i_home:          ["首頁",         "Home"],
        i_uncategorized: ["綜合",         "Uncategorized"],
        i_copy:          ["複製圖片連結", "Copy"]
      }

    case setting
    when "zh-tw"
      index = 0
    when "en"
      index = 1
    end

    text_object.each do |key, array|
      text_object[key] = array[index]
    end

    return text_object
  end
end

