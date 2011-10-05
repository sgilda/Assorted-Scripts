#!/usr/bin/env ruby

require 'rexml/document'
require 'optparse'

def processCommandLine
  options = {}

  optparse = OptionParser.new do |opts|
    opts.banner = "findtags.rb [options]"

    options[:pattern] = "*"
    opts.on( '-p PATTERN', '--pattern "PATTERN"', 'File pattern to match.  Defaults to *' ) do |pattern|
      options[:pattern] = pattern
    end
    
    options[:tagone] = ""
    opts.on( '-f TAG', '--firsttag TAG', 'first tag to search for' ) do | tagone | 
      options[:tagone] = tagone
    end
    
    options[:tagtwo] = ""
    opts.on( '-s TAG', '--secondtag TAG', 'second tag to search for' ) do | tagtwo | 
      options[:tagtwo] = tagtwo
    end
    
    opts.on( '-h', '--help', 'Display help' ) do
      puts opts
      exit
    end

    if (ARGV.size == 0) then
      puts opts
      exit
    end

  end

  begin
    optparse.parse!
  rescue => error
    puts "ERROR PARSING COMMANDLINE:"
    puts "\t"+error.to_s
    puts
    puts optparse
    exit
  end

  return options
    
end

options = processCommandLine

if options[:tagtwo] == "" then
  options[:tagtwo] = options[:tagone]
end

allfiles=Dir.glob(options[:pattern].to_s)

allfiles.each do |file|  
  
  if not File.directory?(file) then
    begin
      inputdoc = REXML::Document.new(File.open(file))
      inputdoc.elements.each("//#{options[:tagone].to_s}/#{options[:tagtwo].to_s}") do |c|
        para_doc = REXML::Document.new(c.to_s)
        puts "Filename: " + file 
        puts c.parent.to_s
        puts
      end
    rescue REXML::ParseException => msg
      puts " === ERROR: "+ file +" failed to validate as valid XML"
    end
  end
  
end
