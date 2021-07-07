require 'yaml'
require 'json'

HEIGHTS = YAML.load <<EOS
4302: 3.66
4301: 60
3111: 3.66
3112: 20
3101: 3.66
3102: 20
3103: 60
EOS
keys = HEIGHTS.keys.map {|v| "buildings#{v}"}

s = JSON.parse($stdin.read)

s['layers'].each {|l|
  l.delete('metadata')  
  l['maxzoom'] = 24 if l['maxzoom'] >= 17
  if keys.include?(l['id'])
    ftCode = l['id'][-4..-1].to_i
    l['paint']['fill-extrusion-height'] = HEIGHTS[ftCode]
  end
}

s['sources']['h'] = YAML.load <<EOS
type: raster-dem
minzoom: 3
maxzoom: 13
tileSize: 512
tiles:
  - https://optgeo.github.io/10b512-7-113-50/zxy/{z}/{x}/{y}.webp
EOS

s['sources']['v'] = YAML.load <<EOS
type: vector
minzoom: 8
maxzoom: 8
tiles:
  - https://optgeo.github.io/kengyu/zxy/{z}/{x}/{y}.pbf
attribution: 国土地理院
EOS

s['layers'].prepend YAML.load <<EOS
id: kengyu
type: fill
source: v
source-layer: kengyu
paint:
  fill-color:
    - match
    -
      - get
      - year
    - 2020
    - "#FFF8E1"
    - 2019
    - "#FFECB3"
    - 2018
    - "#FFE082"
    - 2017
    - "#FFD54F"
    - 2016
    - "#FFCA28"
    - 2015
    - "#FFC107"
    - 2014
    - "#FFB300"
    - 2013
    - "#FFA000"
    - 2012
    - "#FF8F00"
    - "#FF6F00"
EOS

s['layers'].prepend YAML.load <<EOS
id: background
type: background
paint:
  background-color:
    - rgb
    - 255
    - 255
    - 255
EOS

s['layers'].prepend YAML.load <<EOS
id: sky
type: sky
paint:
  sky-type: atmosphere
EOS

s['terrain'] = {
  :source => 'h'
}

s['fog'] = {
  :range => [-2, 10],
  :color => [
    'rgb',
    255,
    255,
    255
  ]
}

print JSON.dump(s)

