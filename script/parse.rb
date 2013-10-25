require 'json'

h = JSON.parse( IO.read('../data/d69395e3dac827c408fb2512dc69f97b.json') )

Dir.glob('../data/*.json') do |json_file|
  h = JSON.parse( IO.read(json_file) )  
  values = h['values'].map {|k,v| {time: k, value: v} }

  new_filename = json_file.sub('/data/', '/data/parsed_')
  File.open(new_filename, 'w') { |file| file.write(values.to_json) }
end

