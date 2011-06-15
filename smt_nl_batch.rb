#!/usr/bin/env ruby

require "rubygems"
require "hominid"
require "net/http"
require "yaml"

# set so we can get a unique campaign name
run_date = "06/11"

config = YAML.load(File.open('config.yml'))

api_key = config["mail_chimp"]["api_key"]

nl_sites = {"MVP" => ["My Venture Pad","myventurepad.com"],
  "SBF" => ["Sustainable Business Forum","sustainablebusinessforum.com"],
  "SCC" => ["Sustainable Cities Collective","sustainablecitiescollective.com"],
  "SDC" => ["Smart Data Collective","smartdatacollective.com"],
  "TCC" => ["The Customer Collective","thecustomercollective.com"],
  "TSC" => ["The Social Customer","thesocialcustomer.com"],
  "TEC" => ["The Energy Collective","theenergycollective.com"],
  "SMT" => ["Social Media Today","socialmediatoday.com"]}



nl_base =  config["nl_backend"]["nl_base_url"]


h = Hominid::API.new(api_key)

i = 1

nl_sites.each do |s,v|

  puts "Processing #{s} ..."

  l = h.find_list_by_name("#{s} Bloggers Only Newsletter")
  nl_subject_line = "A letter to our bloggers from #{v[0]}"
  campaign_name = "#{s} Bloggers Newsletter, #{run_date}"

  list_id = l['id']
  nl_url = "#{nl_base}#{s.downcase}"
  puts "#{nl_url}"
  from_name = v[0]
  from_address = "info@#{v[1]}"


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
