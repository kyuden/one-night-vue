# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', input: 'coffee', output: 'www/javascripts'

guard "haml", input: "haml", output: "www", notifications: true do
  watch(/^.+(\.html\.haml)$/)
end

guard 'sass', input: 'sass', output: 'www/stylesheets'
