require 'rubygems'
require 'minitest/unit'
require 'minitest/spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'youtube_tools'

class MiniTest::Unit::TestCase
end

MiniTest::Unit.autorun
