require 'rubygems'
require 'bundler'
require 'faraday'
require 'json'

task :update_read do
  conn = Faraday.new("https://api.pinboard.in")
  resp = conn.get("/v1/posts/all", { 'auth_token' => ENV['PINBOARD_API_KEY'], 'format' => 'json' })
  json = JSON.parse(resp.body)
  data_dir = "./_data"
  FileUtils.mkdir(data_dir) unless Dir.exists?(data_dir)
  File.open("#{data_dir}/read.json", 'w'){ |file| file.write(JSON.dump(json)) }
end

task :deploy => :update_read do
  sh "jekyll build"
  sh "s3_website push"
end

