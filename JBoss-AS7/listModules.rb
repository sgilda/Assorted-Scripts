#!/usr/bin/ruby

require 'find'
require 'rexml/document'

def isPathModule(path)
  return File.basename(path) == "module.xml"
end

def getModuleName(path)
  moduleFile = REXML::Document.new(File.open(path))
  moduleElement = moduleFile.elements["/module"]
  moduleName = moduleElement.attributes["name"]
  return moduleName
end

unsorted_modules = Array.new

Find.find(ARGV[0]) do |path|
  if FileTest.directory?(path)
    if File.basename(path)[0] == ?.
      Find.prune       # Don't look any further into this directory.
    else
      next
    end
  else
    if isPathModule(path) 
    then 
      unsorted_modules << getModuleName(path)
    end
  end
end

modules = unsorted_modules.sort { |x,y| x <=> y }

modules.each do |thismodule| 
  puts thismodule
end

puts "\n#{modules.size} modules"