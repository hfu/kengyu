BASE_URL = 'https://maps.gsi.go.jp/xyz/fgd_dem5a_area_dtil'
Z = 8
URL = "https://gsi-cyberjapan.github.io/gsivectortile-3d-like-building/building3d.json"

desc 'download mokuroku'
task :mokuroku do
  sh "curl -O #{BASE_URL}/mokuroku.csv.gz"
end

desc 'create a huge geojsons'
task :geojsons do
  sh [
    'zcat mokuroku.csv.gz | ',
    "grep -o '^12\/.*\.geojson' | ",
    "parallel --line-buffer 'curl --output - --silent #{BASE_URL}/{} | ",
    "tippecanoe-json-tool' > a.geojsons"
  ].join
end

desc 'create tiles'
task :tiles do
  sh [
    'ruby filter.rb a.geojsons |',
    "tippecanoe --minimum-zoom=#{Z} --maximum-zoom=#{Z} ",
    "--force --layer=kengyu ",
    "--coalesce --detect-shared-borders ",
    "-o tiles.mbtiles; ",
    "tile-join --force --no-tile-compression ",
    "--output-to-directory=docs/zxy --no-tile-size-limit tiles.mbtiles"
  ].join
end

desc 'host the site'
task :host do
  sh 'budo -d docs'
end

desc 'run vt-optimizer'
task :optimize do
  sh "node ../vt-optimizer/index.js -m tiles.mbtiles"
end

desc 'build style'
task :style do
  sh "curl #{URL} | ruby style.rb > docs/style.json"
  sh "gl-style-validate docs/style.json"
end

