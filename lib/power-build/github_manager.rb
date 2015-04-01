require 'colorize'
require 'json'

module PowerBuild
  class GitHubManager
    def initialize
      
    end

    # def checkout_branch
    #   command = %x[git branch]
    #   if command.include? "gh-pages"
    #     command = %x[git checkout gh-pages]
    #   else
    #     command = %x[git checkout -b gh-pages]
    #   end
    #   add_and_commit
    # end
    #
    # def add_and_commit
    #   status = %x[git status]
    #   if status.include? "assets"
    #     %x[git add assets] 
    #     @commit = true
    #   end
    #   if status.include? "index.html"
    #     %x[git add index.html] 
    #     @commit = true
    #   end
    #   if status.include? "power-build.config"
    #     %x[git add power-build.config] 
    #     @commit = true
    #   end
    #   if @commit
    #     %x[git commit -m "regenerate site"]
    #   end
    # end
    #
    # def push
    #   %x[git push]
    # end
  end
end
