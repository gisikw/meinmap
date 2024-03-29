require 'rubygems'
require 'bundler'

Bundler.require

COLOR_MAP = %q{
  255,255,255
  255,255,255
  255,255,255
  255,255,255

  89,125,39
  109,153,48
  127,178,56
  109,153,48

  174,164,115
  213,201,140
  247,233,163
  213,201,140

  117,117,117
  144,144,144
  167,167,167
  144,144,144

  180,0,0
  220,0,0
  255,0,0
  220,0,0

  112,112,180
  138,138,220
  160,160,225
  138,138,220

  117,117,117
  144,144,144
  167,167,167
  144,144,144

  0,87,0
  0,106,0
  0,124,0
  0,106,0

  180,180,180
  220,220,220
  255,255,255
  220,220,220

  115,118,129
  141,144,158
  164,168,184
  141,144,158

  129,74,33
  157,91,40
  183,106,47
  157,91,40

  79,70,70
  96,96,96
  112,112,112
  96,96,96

  45,45,180
  55,55,220
  64,64,255
  55,55,220

  73,58,35
  89,71,43
  104,83,50
  89,71,43
}.split("\n").map(&:strip).reject{|line| line.empty?}

get '/' do
  @pixel_map = {}
  NBTFile.load(File.read('map_0.dat'))[1]['data']['colors'].split('').each_with_index do |pixel,i|
    if pixel.ord > 3
      color = COLOR_MAP[pixel.ord] || '0,0,0'
      (@pixel_map[color.strip]||=[]) << [i % 128, i / 128]
    end
  end
  haml :index
end

post '/' do
  begin
    @pixel_map = {}
    NBTFile.load(params['mapfile'][:tempfile].read)[1]['data']['colors'].split('').each_with_index do |pixel,i|
      if pixel.ord > 3
        color = COLOR_MAP[pixel.ord] || '0,0,0'
        (@pixel_map[color.strip]||=[]) << [i % 128, i / 128]
      end
    end
  rescue Exception => e
    @error = true
  end
  haml :index
end

get '/style.css' do
  content_type 'text/css'
  sass :style
end
