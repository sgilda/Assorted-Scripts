#!/usr/bin/env ruby

require "cgi"
require "open-uri"
require "json"

class SkyNetREST
  attr_accessor :baseurl

  def get_topics_for_query_expanded_json(query, expand)
    query=query.gsub("&",";")
    expand = CGI::escape(expand)
    
    puts "#{@baseurl}/topics/get/json/query;#{query}?expand=#{expand}"
    
    request = open("#{@baseurl}/topics/get/json/query;#{query}?expand=#{expand}")
    result = request.read
    return JSON.parse(result)
    
  end

  def get_topics_for_query_json(query)
    node_to_expand="topics"
    request = URI("#{@baseurl}/topics/get/json/query;#{query}")
    result = Net::HTTP.get(request) 
    return JSON.parse(result)
  end


  def get_topic_for_id_json(id)
    request = URI("#{@baseurl}/topic/get/json/#{id}")
    result = Net::HTTP.get(request) 
    return JSON.parse(result)
  end

end

