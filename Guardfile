# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard :rspec, cli: "--color --format nested" do
guard :rspec, cmd: 'rspec --color --format nested' do
  watch(%r{^spec/.+_spec\.rb$})
  #watch(%r{^spec/support/(.+)\.rb$'}) { |m| p m }
  watch('spec/support/models.rb') { "spec" }
  watch(%r{^lib/(.+)\.rb$}) { |m|
    "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

end
