require 'rubygems'
require 'hpricot'
require 'open-uri'

module YoutubeTools
	FOLDER_PATH = File.join(ENV['HOME'],"/Musica/RTubeToMp3") # Folder Path from musics
	
	CHARACTERS = { " " => "+", "$" => "%24", "-" => "%2D", "_" => "%5F", "." => "%2E", "+" => "%2B",
									"!" => "%21", "*" => "%2A", "\"" => "%22", "'" => "%27", "(" => "%28", ")" => "%29",
									";" => "%3B", "/" => "%2F", "?" => "%3F", ":" => "%3A", "@" => "%40", "=" => "%3D",
									"&" => "%26", "|" => "%7C" }
	
	autoload :Searcher,   'youtube_tools/searcher'
  autoload :Downloader, 'youtube_tools/downloader'
  autoload :Converter,  'youtube_tools/converter'
end
