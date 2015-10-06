require 'minitest'
require 'minitest/autorun'
require 'json'

data = JSON.parse(File.open("test/sample_data.json","r") {|f| f.read})
SAMPLE_DATA = data.map {|h| h.inject({}) {|x, (k,v)| x[k.to_sym] = v; x} }

