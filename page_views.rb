#!/usr/bin/env ruby

require 'dotenv'
require 'canvas-api'
require 'json'

# Set up the environment
Dotenv.load
CANVAS_URL = ENV['CANVAS_URL']
CANVAS_TOKEN = ENV['CANVAS_TOKEN']

if (ARGV.length <= 0)
    puts "ERROR\n"
    puts "Usage:./page_views.rb canvas_user_id"
    exit
end

# Take the user id from argument
user_id = ARGV[0]

canvas = Canvas::API.new(:host => CANVAS_URL, :token => CANVAS_TOKEN)
page_views = canvas.get("/api/v1/users/" + user_id + "/page_views?per_page=100")

# Keep loading the page views till we get them all!
while page_views.more?  do
    page_views.next_page!
end

# Output as CSV
puts 'url,action,created_at,interaction_seconds,remote_ip'
page_views.each { |x| puts x['url'] + ',' + x['action'] + ',' + x['created_at'] + ',' + x['interaction_seconds'].to_s + ',' + x['remote_ip'] }
