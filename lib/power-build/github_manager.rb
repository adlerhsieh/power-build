require 'colorize'
require 'json'

module PowerBuild
  class GitHubManager
    def initialize
      
    end

    def checkout_branch
      command = %x[git branch]
      # if command.include? "gh-pages"
      #   %x[git checkout gh-pages]
      # else
      #   %x[git checkout -b gh-pages]
      # end
      puts command
    end
  end
end
