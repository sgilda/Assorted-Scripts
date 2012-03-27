#!/usr/bin/env ruby -w

selection = ENV['TM_SELECTED_TEXT']

selection.each_line do |item|

	if item.start_with?("|:") then
		item = ""
	end

	if item.length > 0 then

	if item.start_with?("|") then
		item = "<row><entry><para>#{item[1..-1]}"
  	end

  	if item.end_with?("|\n") then
    		item = "#{item[0..-3]}</para></entry></row>"
  	end

  	item.gsub!("|", "</para></entry><entry><para>")

  	item.gsub!("<entry></entry>","<entry><para>-</para></entry>")  
  	item.gsub!("**", "")

  	item.gsub!(/\(.*\)/, '')
  	item.gsub!("[","<filename>")
  	item.gsub!("]","</filename>")

  	puts item
  end
end



