watch( 'test/test_.*\.rb' )  {|md| system("ruby #{md[0]}") }

def compile_files
   system('coffee -wc -o spec/javascripts/ spec/coffeescripts/')
end

watch('spec/coffeescripts/(.*)\.coffee') { run_tests }

compile_files
