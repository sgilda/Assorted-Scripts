#!/usr/bin/env ruby -W0

require 'xmlrpc/client'

if ARGV.count != 5 
    puts "\nHelp:"
    puts "\tbug_report.rb HOSTNAME LOGIN PASSWORD FILTER SHARER_ID\n\n"
    puts "\te.g. $ ./bug_report.rb bugzilla.company.com lsmithers m4lbib0 \"last weeks bug updates\" 345344"
    exit

end

$_bz_server = ARGV[0]
$_login = ARGV[1]
$_password = ARGV[2]
$_filter = ARGV[3]
$_sharer = ARGV[4]

def get_search(proxy, search_name, sharer_id)
    bugs = Array.new
    begin
      result = proxy.search(
          'savedsearch' => search_name,
          'sharer_id' =>  sharer_id,
          'include_fields' =>
              [
                  'id',   #bug_id
                  'status',
                  'assigned_to',
                  'resolution',
                  'summary',
                  'assigned_to'
              ],
          'Bugzilla_login' => $_login,
          'Bugzilla_password' => $_password
      )
      bugs = result['bugs']

    rescue XMLRPC::FaultException => e
      puts 'Error: '
      puts "Code: #{e.faultCode}"
      puts "Message: #{e.faultString}"

    rescue Exception => e
      puts 'Error: '
      puts "Message: #{e.message}"
    end
    return bugs
end

bz_server = "https://#{$_bz_server}/xmlrpc.cgi"
bz_client = XMLRPC::Client.new_from_uri( bz_server, nil, 300)
bz_client.instance_variable_get(:@http).instance_variable_set(:@verify_mode, OpenSSL::SSL::VERIFY_NONE)

proxy = bz_client.proxy('Bug')
bugs = get_search(proxy , $_filter, $_sharer) 
bugs.sort! { |x,y| x['status'] <=> y['status']}

maxwidth = 4
bugs.each do | bug |
    width =  bug['status'].length + bug['resolution'].length
    maxwidth = width if width > maxwidth
end
maxwidth = maxwidth + 2


bugs.each do | bug |
    print "BZ##{bug['id']} - #{bug['status']} #{bug['resolution']}"
    width = bug['status'].length + bug['resolution'].length
    (width..maxwidth).each do |i|
        print " "
    end
    puts "#{bug['summary']}"
end
