#/usr/bin/ruby

class XMLNode
	attr_reader :name, :attributes, :tags

	def initialize(xml)
		xml.gsub!(/\A +/, '')

		raise "Invalid beginning: #{xml[0..8]}" unless xml.start_with?('<')

		xml.slice!(0)

		xml.gsub!(/\A /, '')

		@name = xml[0...(xml =~ /[^\w]/)]

		xml.gsub!(/\A#{@name} +/, '')

		@attributes = {}
		@tags = []

		until xml.start_with?('>')
			raise 'ERR: Empty!' if xml.empty?

#			puts ""
#			puts "XML:|" + (xml.length < 48 ? xml : xml[0...48]) + "|"

			if xml.start_with?('/>')
				xml.slice!(0)
				xml.slice!(0)

				xml.gsub!(/\A +/, '')

#				puts "TAGEND:" + (xml.length < 42 ? xml : xml[0...42])

				return
			end

			att = xml[0...(xml =~ /[^\.\w_=\"]/)]
			att.length.times do xml.slice!(0) end
			xml.gsub!(/\A +/, '')

#			puts "ATT:" + att

#			puts "RXML:" + (xml.length < 32 ? xml : xml[0...32])

			@attributes[att[0...(att =~ /=/)].intern] = att[((att =~ /=/) + 1)..-1].gsub!(/\"/, '')
		end

		xml.gsub!(/\A> */, '')

		until xml.start_with?("</#{@name}>")
			tags << XMLNode.new(xml)
		end

		xml.gsub!(/\A<\/#{@name}> */, '')
	end

	def [](ind, val = nil)
		if ind.is_a?(Integer)
			return @tags[ind]
		elsif ind.is_a?(Symbol) and not val.nil?
			@tags.each do |tag|
				return tag if tag.attributes[ind].intern == val.intern
			end
			puts "ERR: No tag named '#{ind}'"
		end

		raise 'ERR: Invalid parameter!'
	end
end

class RXML
	attr_reader :tags, :file_name

	def initialize(file_name)
		@file_name = file_name

		xml = nil
		File.open(@file_name, "r") do |file|
			xml = file.read
		end

		@tags = xml.nil? ? nil : extract_data(xml)
	end

	def extract_data(xml)
		nodes = []

		xml.gsub!(/[\s\n]+/, ' ')

		until xml.empty?
			nodes << XMLNode.new(xml)
		end

		return nodes
	end

	def [](ind)
		return @tags[ind]
	end
end

