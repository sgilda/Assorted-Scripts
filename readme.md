# Assorted Scripts

This repository is just a general dumping ground for various things I've cobbled
together to solve minor problems.

### JBoss-AS7/listModules.rb

A Ruby script that lists all the modules in a JBoss AS7 installation.
  
     [localhost]$ listModules.rb <directory>
     
It recurses through the specified directory looking for module.xml files and
retrieves the name attribute from the root module node of the file. It then
sorts them in descending alphabetical order and sends them to stdout.