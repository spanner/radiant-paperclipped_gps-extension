namespace :radiant do
  namespace :extensions do
    namespace :paperclipped_routes do
      
      desc "Runs the migration of the Paperclipped Routes extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PaperclippedRoutesExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PaperclippedRoutesExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Paperclipped Routes to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from PaperclippedRoutesExtension"
        Dir[PaperclippedRoutesExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PaperclippedRoutesExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
