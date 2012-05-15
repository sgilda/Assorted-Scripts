#!/usr/bin/env ruby
#require 'find'
require 'rexml/document'

def doLink(fp)
  fp = fp.to_s
  if fp == "" then 
    return ""
  end
  
  startpos = fp.index('&lt;')
  endpos = fp.index('&gt;') 
  fp = fp[startpos+4..endpos-1]
  fp = "[#{fp} link]"
  
  return fp
end

def removeTag(sme)
  sme = sme.to_s
  if sme == "" then 
    return ""
  end
  
  sme = sme.gsub(/&lt;.*?&gt;/,"")
  
  return sme
  
end

inFile = REXML::Document.new(File.open(ARGV[0]))

inFile.elements.each("/opml/body/outline[@text='Planned Content']") do | outline |
  title = outline.elements["@text"]
  pages = outline.elements["@Pages"]
  puts "== #{title} - #{pages} pages total =="
  
  puts "|| '''Chapter'''												|| '''Subsection'''									|| '''~# pages''' || '''Feature Page''' || '''SME'''					|| '''Release'''			|| '''Bug / Ticket'''					||"
  
  outline.elements.each("outline") do | chapter |
    
    title = chapter.elements["@text"];
    pages = chapter.elements["@Pages"];
    featurepage = doLink(chapter.elements["@FeaturePage"]);
    sme = removeTag(chapter.elements["@SME"]);
    avail = chapter.elements["@FeatureAvailable"];
    
    puts "|| '''#{title}'''									|| -									|| '''#{pages}'''        || #{featurepage}                  ||   #{sme}                          || #{avail} || -                  ||"
    
    chapter.elements.each("outline") do | section |

      title = section.elements["@text"];
      pages = section.elements["@Pages"];
      featurepage = doLink(section.elements["@FeaturePage"]);
      sme = removeTag(section.elements["@SME"]);
      avail = section.elements["@FeatureAvailable"];
      puts "|| -									|| #{title}									|| #{pages}        || #{featurepage}                  ||             #{sme}                || #{avail}  || -                  ||"

      section.elements.each("outline") do | subsection |

        title = subsection.elements["@text"];
        pages = subsection.elements["@Pages"];
        featurepage = doLink(subsection.elements["@FeaturePage"]);
        sme = removeTag(subsection.elements["@SME"]);
        avail = subsection.elements["@FeatureAvailable"];
        puts "|| -									|| - #{title}									|| #{pages}        ||#{featurepage}                   ||               #{sme}              ||#{avail} || -                  ||"

        subsection.elements.each("outline") do | subsubsection |

          title = subsubsection.elements["@text"];
          pages = subsubsection.elements["@Pages"];
          featurepage = doLink(subsubsection.elements["@FeaturePage"]);
          sme = removeTag(subsubsection.elements["@SME"]);
          avail = subsubsection.elements["@FeatureAvailable"];
          puts "|| -									|| --> #{title}									|| #{pages}        || #{featurepage}                  ||                 #{sme}            || #{avail}|| -                  ||"

        end

      end
      
    end
    
  end
  
end