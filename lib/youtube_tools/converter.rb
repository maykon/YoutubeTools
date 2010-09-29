module YoutubeTools
	class Converter
		attr_accessor :file, :folder, :file_name, :format
		
		def initialize(file, options={})			
			@folder = options[:path].nil? ? FOLDER_PATH : options[:path]
			@format = options[:format].nil? ? :mp3 : options[:format]
			
			@file = "#{@folder}/#{file}"
			
			converter_to(@format)
		end
		
		protected
		def converter_to(format=:mp3)
			@file_name = "#{@file}.#{format}"
			
			case format
				when :avi
					system "ffmpeg -i #{@file} -ab 56 -ar 22050 -b 500 -s 320x240 -vcodec xvid -acodec mp3 #{@file_name}"
				when :mp4
					system "ffmpeg -i #{@file} -ar 22050 #{@file_name}"
				when :mpg
					system "ffmpeg -i #{@file} -ab 56 -ar 22050 -b 500 -s 320x240 #{@file_name}"					
				else
					system "ffmpeg -i #{@file} -ab 128k -ac 2 -acodec libmp3lame -vn -y #{@file_name}"					
			end
			system "rm -Rf #{@file}" if File.exist? @file
		end
	end
end
