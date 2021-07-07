require 'json'

while gets
  f = JSON.parse($_.strip)
  %w{fillColor fillOpacity opacity}.each {|k|
    f['properties'].delete("_#{k}")
  }
  w = f['properties']['作業年度']
  year = case w[0]
         when 'H'
           w[1..-1].to_i + 1988
         when 'R'
           w[1..-1].to_i + 2018
         end
  f['properties']['year'] = year
  print "\x1e#{JSON.dump(f)}\n"
end
