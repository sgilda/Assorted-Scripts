# Assorted Scripts

This repository is just a general dumping ground for various things I've cobbled
together to solve minor problems.

### JBoss-AS7/listModules.rb

A Ruby script that lists all the modules in a JBoss AS7 installation.
  
     [localhost]$ listModules.rb <directory>
     
It recurses through the specified directory looking for module.xml files and
retrieves the name attribute from the root module node of the file. It then
sorts them in descending alphabetical order and sends them to stdout.

### findtags.rb

A Ruby script that searches a specified set of files for one specified XML element that 
contains a second specified XML element.  Note that if a second tag is not specified it 
uses the first tag as the second as well.

      findtags.rb [options]
         -p, --pattern "PATTERN"          File pattern to match.  Defaults to *
         -f, --firsttag TAG               first tag to search for
         -s, --secondtag TAG              second tag to search for
         -h, --help                       Display help

Example:

 * find instances of `<para>` inside of other `<para>`s in XML files
  
   `[localhost]$ findtags.rb -p "/home/dmison/testbook/en-US*.xml" -f para`

 * find instances of `<command>` in `<entry>` in any file in current working directory
    
   `[localhost]$ findtags.rb -f "entry" -s "command"`