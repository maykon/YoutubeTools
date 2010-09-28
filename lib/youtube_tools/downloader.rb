module YoutubeTools
	class Downloader
		attr_accessor	:href, :name, :quality, :full_path, :link_dw, :links
		
		LINK_PATTERN = /"fmt_stream_map": ("[\w |:\/\\.?=&\,%-]+")/
		NAME_PATTERN = /-\s+(.*)\s*/
		QUALITY = { :low => 5, :mp4 => 18, :mid => 34, :hd => 22, :hight => 35 }
	
		def initialize(href, options={})
			@href = href
			@video_folder = options[:path].nil? ? FOLDER_PATH : options[:path]
			@quality = options[:quality].nil? ? set_quality(:low) : set_quality(options[:quality])
			@error_quality = 0
			@links = {}
			
			create_folder
			init_information
		end
		
		def set_quality(quality)
			return QUALITY[quality] if QUALITY.include? quality
			QUALITY[:low]
		end
				
		# method dowload video from selected folder
		def download_video
			@percent = @total = 0
			print "Downloading...0%"
			open(@full_path, 'wb') do |file|
				file.write(open(@link_dw, :content_length_proc => lambda {|t|
			 			if t && 0 < t
					 		@total = t        
				 		end
					}, :progress_proc => lambda {|s|
						old_percent = @percent
						@percent = (s * 100)/@total
						print "..#{@percent}%" if @percent != old_percent
					}).read)
			end
			puts "Download complete!"
		end
		
		protected
		def init_information
			content = open(@href)
			doc = Hpricot(content)
			@name = search_name(doc.search("//title").first)
			@link_dw = search_link(doc)
			@full_path = File.join(@video_folder, @name.split("/").last)
		end
		
		def quality_key(value)
			case value
				when 18
					return :mp4
				when 22
					return :hd
				when 34, 4
					return :mid
				when 35
					return :hight
				else
					return :low
			end
		end
		
		# method for search name for video
		def search_name(content)
			name = content.to_plain_text.gsub(NAME_PATTERN).first
			name = name[1..name.length].gsub(/[\n\s()`'"\/,;<>?!&%$@*+=.\[\]]/, "")
			name[0..name.length-1]
		end
		
		def search_link(doc)
			fmt = doc.to_html.gsub(LINK_PATTERN).first
			fmt = fmt.gsub!(/([^,]+)/)
			fmt.each_with_index do |l, i|
				l.gsub!(/"fmt_stream_map": "/, "") if i == 0
				ql = l.gsub(/^(\d)+|$/).first
				qlk = quality_key(ql.to_i)
				l.gsub!(/(^(\d)+\|)/, "").gsub!(/[\\,"]/, "").gsub!(/(\|\|.*)/, "")
				@links[qlk] = l
			end
			quality_present = @links.keys.include? quality_key(@quality)
			return @links[quality_key(@quality)] if quality_present
			@links[:low]
		end
		
		# method create folder case not exist
		def create_folder
			#create folder if no exist
			unless File.exist? @video_folder
				puts "Creating #{@video_folder}"
				FileUtils.mkdir_p(@video_folder)
			end
		end
	end
end
