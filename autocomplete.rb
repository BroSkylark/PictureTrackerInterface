#!/usr/bin/ruby

require 'cgi'
require_relative 'rxml'

class AutoComplete
	def initialize
		@cgi = CGI.new

		if not @cgi.has_key?("m") or not @cgi.has_key?("p")
			return cgi_error	
		end

		input = retrieve_input
		
		if input == ''
			return cgi_error	
		end

#		@tags = `../dpt/dpt --profile=../dpt/test --list-tags --plain`.split(/\n/)

		@cgi.out() {
			if input.start_with?('.')
				complete_absolute(input)
			else
				complete_relative(input)	
			end
		}
	end

	def complete_absolute(input)
		tags = RXML.new('tags_tree.xml')[0]
		id = input.gsub(/\A\.(\w+\.)*/, '')
	
		input.gsub!(/\.\w*\Z/, '')
		input.slice!(0) if input.start_with?('.')
		ids = input.split(/\./)

		ids.each do |name|
			tags = tags[:name, name]
		end

		result = ""

		tags.tags.each do |tag|
			result += tag.attributes[:name] + "<br />" if tag.attributes[:name].start_with?(id)
		end

		result
	end

	def complete_relative(input)
		result = ""
		
		read_tags("tags.list").each do |tag|
			if tag.start_with?(input) and not tag == input
				result += tag + '<br />'
			end
		end

		return result
	end

	def read_tags(file_name)
		tags = ""
		File.open(file_name, "r") do |file|
			tags = file.read.split(/\n/)
		end
		return tags
	end

	def retrieve_input
		input = CGI::unescape(@cgi["m"])

		ind = Integer(@cgi["p"])
		beg = input[0...ind].to_s
		ed  = input[ind..-1].to_s
		beg.gsub!(/\A([\.\w]+[\~\!\&\|\^\(\)]+)+/, '')
		ed.gsub!(/([\~\!\&\|\^\(\)]+[\w\.]+)+\Z/, '')
	
		input = beg + ed

		return input
	end

	def cgi_error
		@cgi.out() {
			""
		}

		return
	end
end

AutoComplete.new

