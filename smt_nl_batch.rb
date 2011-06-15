#!/usr/bin/env ruby

require "rubygems"
require "hominid"
require "net/http"
require "yaml"

# set so we can get a unique campaign name
run_date = "06/11"

config = YAML.load(File.open('config.yml'))

api_key = config["mail_chimp"]["api_key"]
nl_sites = config["sites"]
nl_base =  config["nl_backend"]["nl_base_url"]

h = Hominid::API.new(api_key)

nl_sites.each do |s|
  
  next if s[1]['blogger_nl'] == false
  name = s[0]
  abbrev = s[1]['abbrev']
  url = s[1]['url']

  puts "Processing #{name} ..."

  l = h.find_list_by_name("#{abbrev} Bloggers Only Newsletter")
  list_id = l['id'] 

  nl_subject_line = "A letter to our bloggers from #{name}"
  campaign_name = "#{abbrev} Bloggers Newsletter, #{run_date}"
  nl_url = "#{nl_base}#{abbrev.downcase}"
  from_name = name
  from_address = "info@#{url}"

 nl_markup = Net::HTTP.get_response(URI.parse(nl_url)).body

  h.campaign_create('regular', {:list_id => list_id, 
     :subject => nl_subject_line,
     :title => campaign_name,
     :generate_text => true,
     :from_email => from_address,
     :from_name => from_name},
     {:html => nl_markup}
     )
end
