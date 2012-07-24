require 'fileutils'
require 'haml'

def map_source_to_target_path(source)
  source.gsub('app/assets/', 'public/').gsub('haml', 'html')
end

def compile_file(source)
  target = map_source_to_target_path(source)
  FileUtils.rm_rf Dir.glob(target)
  haml = File.read(source)

  File.open(target, 'w') do |target_file|  
    target_file.puts Haml::Engine.new(haml).to_html
  end  
end

def compile_templates(md = nil)
  source = md[0] if md
  if source
    target = map_source_to_target_path(source)
    source_files = [source]
  else
    source_files = Dir.glob('app/assets/templates/*.haml')
  end

  p "compiling #{source_files}"

  source_files.each do |source|
    compile_file(source)
  end
end

watch('app/assets/templates/(.*)\.haml') { |md|compile_templates(md) }

compile_templates
