namespace :assets  do
  desc 'convert app/assets/templates to public/template'

  task :compile_templates do |t, args|
    source_files = Dir.glob('app/assets/templates/**/*.haml')

    source_files.each do |source|
      target = source.gsub('app/assets/', 'public/').gsub('haml', 'html')
      puts "Compiling #{source} to #{target}"

      path = File.dirname(target)
      FileUtils.mkdir_p(path) unless File.directory?(path)
      FileUtils.rm_rf Dir.glob(target)


      haml = File.read(source)
      File.open(target, 'w') do |target_file|  
        target_file.puts Haml::Engine.new(haml).to_html
      end  
    end
  end
end
