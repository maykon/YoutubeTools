require 'rubygems'
require 'hpricot'
require 'open-uri'

module YoutubeTools
	FOLDER_PATH = File.join(ENV['HOME'],"/Musica/RTubeToMp3") # Folder Path from musics
	
	autoload :Searcher,   'youtube_tools/searcher'
  autoload :Downloader, 'youtube_tools/downloader'
  autoload :Converter,  'youtube_tools/converter'
end
