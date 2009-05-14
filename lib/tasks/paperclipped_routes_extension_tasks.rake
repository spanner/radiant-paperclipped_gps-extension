namespace :radiant do
  namespace :extensions do
    namespace :paperclipped_gps do
      
      desc "Runs the migration of the Paperclipped GPS extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PaperclippedGpsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PaperclippedGpsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Paperclipped Gps to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from PaperclippedGpsExtension"
        Dir[PaperclippedGpsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PaperclippedGpsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
