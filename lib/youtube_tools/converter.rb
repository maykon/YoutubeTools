module YoutubeTools
	class Converter
		attr_accessor :file, :folder, :file_name
		
		def initialize(file, path=nil)			
			@folder = path.nil? ? FOLDER_PATH : path
			
			@file = "#{@folder}/#{file}"
			converter_to
		end
		
		protected
		def converter_to(format=:mp3)
			@file_name = "#{@file}.#{format}"			
			system "ffmpeg -i #{@file} -ab 128k -ac 2 -acodec libmp3lame -vn -y #{@file_name}"
			system "rm -Rf #{@file}" if File.exist? @file
		end
	end
end
