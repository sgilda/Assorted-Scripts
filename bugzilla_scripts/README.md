## bug_report.rb

This script retreives the id, summary and status from bugs in the specified Bugzilla shared search.  It just sends them to stdout.  

Just run the script with the required five parameters:

    bug_report.rb HOSTNAME LOGIN PASSWORD FILTER SHARER_ID

e.g. 

    $ ./bug_report.rb bugzilla.redhat.com lsmithers m4lbib0 "last weeks bug updates" 345344

