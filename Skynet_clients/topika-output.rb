#!/usr/bin/env ruby -W0
$LOAD_PATH.unshift File.dirname(__FILE__)

require "json"
require "erb"
require "skynet-restlib.rb"
require "optparse"


def getTemplateOutputForTopics(template_file, topics)
  begin
    template = ERB.new File.new(template_file).read, nil, "%"
    template.result(binding)
    return template.result(binding)
  rescue => error
    puts "\nERROR PROCESSING TEMPLATE:\n"
    fatalError("\t#{error.to_s}")
    exit
  end
end

def processCommandLine
  options = {}

  optparse = OptionParser.new do |opts|
    opts.banner = "topika-output [options]"

    options[:file] = ""
    opts.on( '-f FILE', '--template FILE', 'template to use. Optional. Defaults to stdout' ) do | file | 
      options[:file] = file
    end
    
    options[:server] = ""
    opts.on( '-s SERVER', '--server SERVER', 'Topika Server name' ) do | server |
      options[:server] = server
    end

    options[:protocol] = ""
    opts.on( '-t PROTOCOL', '--protocol PROTOCOL', 'protocol.  Optional. Defaults to http' ) do | protocol |
      options[:protocol] = protocol
    end

    options[:port] = ""
    opts.on( '-p PORT', '--port PORT', 'Topika Server port. Optional. Defaults to 8080' ) do | port |
      options[:port] = port
    end
    
    options[:query] = ""
    opts.on( '-q QUERY', '--query QUERY', 'query parameter' ) do | query |
      options[:query] = query
    end
      
    options[:expand] = ""
    opts.on( '-e EXPAND', '--expand ''EXPAND''', 'expand parameter - must be in single quotes, double quotes within.  Defaults to: {"branches":[{"trunk":{"name":"topics"}}]}' ) do | expand |
      options[:expand] = expand
    end
    
    opts.on( '-h', '--help', 'Display this screen' ) do
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
  
  if (options[:query] == "" or 
      options[:server] == "") then
    puts "ERROR PARSING COMMANDLINE: query and server must be supplied."
    puts optparse
    exit
  end
  
  if options[:port] == "" then
    options[:port] = "8080"
  end

  if options[:protocol] == "" then
    options[:protocol] = "http"
  end
  
  if options[:expand] == "" then
    options[:expand] = '{"branches":[{"trunk":{"name":"topics"}}]}' #expand topics only
  end
  
  return options
end

# ======================================== 
options = processCommandLine

sn = SkyNetREST.new
#sn.baseurl = "http://skynet.cloud.lab.eng.bne.redhat.com:8080/TopicIndex/seam/resource/rest/1"
sn.baseurl = "#{options[:protocol]}://#{options[:server]}:#{options[:port]}/TopicIndex/seam/resource/rest/1"

result = sn.get_topics_for_query_expanded_json(options[:query], options[:expand]) 
topics = result["items"]

if options[:file] == "" then
  puts topics
else
    puts getTemplateOutputForTopics(options[:file], topics)
end

# example: ./topika-output.rb -f test.erb -t http -s skynet.cloud.lab.eng.bne.redhat.com -p 8080 -q "tag129=1&tag89=1&tag119=1&tag134=1&tag133=1&tag132=1&tag14=0" -e '{ "branches": [ { "trunk": { "name":"topics" }, "branches": [ { "trunk": { "name": "tags" } , "branches": [ { "trunk": { "name": "categories" } } ] } ] } ] }'

# topics/tags expand = '{ "branches": [ { "trunk": { "name":"topics" }, "branches": [ { "trunk": {"name": "tags" } } ] } ] }'
# expand = '{ "branches": [ { "trunk": { "name":"topics" }, "branches": [ { "trunk": { "name": "tags" } , "branches": [ { "trunk": { "name": "categories" } } ] } ] } ] }' # topics/tags/categories 
# expand = '{"branches":[{"trunk":{"name":"topics"}}]}' #expand topics 


