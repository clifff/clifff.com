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

task :download_read => :update_read do
  conn = Faraday.new('http://api.diffbot.com')
  read_data = JSON.parse(File.read('_data/read.json'))
  tmp_dir = "./tmp"
  FileUtils.mkdir(tmp_dir) unless Dir.exists?(tmp_dir)
  read_data.each do |item|
    next unless item['toread'] == 'no'
    # Lets see if we've already gotten this data
    tmp_file = File.join(tmp_dir, item['hash'] + '.json')
    if File.exist?(tmp_file)
      next
    end
    puts "Processing #{item['href']}"
    resp = conn.get("/v3/article", :url => item['href'], :token => ENV['DIFFBOT_TOKEN'])
    if resp.status == 200
      json = JSON.parse(resp.body)['objects'][0]
      if json != nil
        File.open(tmp_file, 'w') do |file|
          file.write(
            JSON.dump({
              :plain_text => json['text'],
              :html => json['html'],
              :siteName => json['siteName'],
              :url => json['url'],
              :title => json['title'],
              :tags => json['tags']
            })
          )
        end
      else
        puts JSON.parse(resp.body)
      end
    else
      puts resp.inspect
    end
  end
end

