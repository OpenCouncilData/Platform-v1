
# Generate some seed data to feed into the database

require 'open-uri'
require 'json'
require 'awesome_print'

seed_json = %w(
  http://data.gov.au/geoserver/hrcc-dog-walking-zones/wfs?request=GetFeature&typeName=ckan_5d904cc1_b419_4bef_8777_94da6cb69e4b&outputFormat=json
  http://data.gov.au/geoserver/hrcc-dog-walking-zones/wfs?request=GetFeature&typeName=ckan_5d904cc1_b419_4bef_8777_94da6cb69e4b&outputFormat=json
  )


def sql_header
  "INSERT INTO DATA(type, geometry, date, payload)" \
  " values('test', "
end

def create_insert_sql(dog_area)
  geo = dog_area["geometry"].to_json
  # payload = dog_area.delete_if { |key, _| key == "geometry" }.to_json
  payload = dog_area["properties"].to_json
  sql = "#{sql_header} ST_GeomFromGeoJSON( '#{geo}' ), 'now', '#{payload}' );"
  puts sql + "\n\n"
end

seed_json.each do |json|
  open(json) do |f|
    f.each_line do |line|
      dog_areas = JSON.parse(line)
      dog_areas["features"].each do |dog_area|
        create_insert_sql(dog_area)
      end
    end
  end
end

# RESULT

# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[607123.43036143,5935441.89561979],[607123.37808827,5935309.3081312],[606957.58917645,5935315.37656502],[606968.4856831,5935443.94506618],[607123.43036143,5935441.89561979]]]]}' ), 'now', '{"id":0,"status":"no","name":"Botanical Gardens","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[604966.19632326,5934460.19362866],[604995.94957667,5934446.73615882],[604949.22097658,5934372.3063496],[604922.15816323,5934393.94108059],[604966.19632326,5934460.19362866]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Weir Park","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[607650.37537469,5935040.84527926],[607807.89679123,5935080.80186444],[607808.99783547,5935026.4211232],[607655.91062209,5935026.46272535],[607650.37537469,5935040.84527926]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Lions Park","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[607350.98205315,5935382.06954264],[607350.5867253,5935376.70273463],[607349.53852671,5935371.38500033],[607347.84543601,5935366.15681071],[607345.52033977,5935361.05795509],[607342.58093439,5935356.12723837],[607339.0495914,5935351.40218567],[607334.95318718,5935346.91875682],[607330.32289838,5935342.71107263],[607325.19396463,5935338.8111553],[607319.60542034,5935335.24868471],[607313.59979761,5935332.05077255],[607307.22280257,5935329.24175604],[607300.52296748,5935326.84301271],[607293.55128145,5935324.87279773],[607286.36080235,5935323.34610501],[607279.00625309,5935322.2745531],[607271.54360511,5935321.6662968],[607264.02965247,5935321.52596506],[607256.52157968,5935321.85462581],[607249.07652647,5935322.6497778],[607241.751153,5935323.90536965],[607234.60120865,5935325.61184591],[607227.6811078,5935327.75621974],[607221.0435157,5935330.32217175],[607214.73894773,5935333.2901742],[607208.81538491,5935336.63763957],[607203.3179088,5935340.33909245],[607198.28835838,5935344.36636339],[607193.76501166,5935348.68880329],[607189.78229433,5935353.27351661],[607186.37051778,5935358.08561168],[607183.5556484,5935363.08846627],[607181.35910988,5935368.24400625],[607179.79762022,5935373.51299533],[607178.88306439,5935378.85533372],[607178.62240392,5935384.23036323],[607179.01762381,5935389.59717671],[607180.06571742,5935394.91492942],[607181.75870933,5935400.14314983],[607184.08371597,5935405.24204769],[607187.02304365,5935410.17281682],[607190.55432321,5935414.89793049],[607194.6506802,5935419.38142704],[607199.28093939,5935423.58918359],[607204.40986207,5935427.48917574],[607209.99841416,5935431.05172134],[607216.00406331,5935434.24970642],[607222.38110261,5935437.05879155],[607229.08099844,5935439.45759711],[607236.05275984,5935441.42786604],[607243.24332665,5935442.95460279],[607250.59797332,5935444.02618746],[607258.06072542,5935444.63446428],[607265.57478574,5935444.77480366],[607273.0829665,5935444.44613745],[607280.52812468,5935443.65096705],[607287.85359695,5935442.3953444],[607295.0036309,5935440.6888259],[607301.92380945,5935438.54439967],[607308.56146497,5935435.97838668],[607314.86608017,5935433.01031653],[607320.7896726,5935429.66277881],[607326.28715978,5935425.96125111],[607331.31670241,5935421.93390515],[607335.8400227,5935417.61139233],[607339.82269578,5935413.02661039],[607343.23441159,5935408.21445309],[607346.0492056,5935403.21154456],[607348.2456564,5935398.05596056],[607349.80704866,5935392.78693869],[607350.72150036,5935387.44457979],[607350.98205315,5935382.06954264]]]]}' ), 'now', '{"id":0,"status":"no","name":"City Oval","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[605595.1035,5936459.7424],[605540.1377,5936460.5246],[605469.2684,5936434.9152],[605464.8995,5936433.3369],[605454.6146,5936461.8007],[605441.8677,5936497.0761],[605435.5978,5936514.4295],[605595.2957,5936571.9209],[605597.1029,5936572.5709],[605595.1035,5936459.7424]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Jenkinson Reserve","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[606238.3429,5937261.0501],[606172.9197,5937261.5821],[606172.9266,5937262.4264],[606173.0735,5937279.8884],[606173.212,5937296.3874],[606173.3505,5937312.8864],[606173.489,5937329.3865],[606173.6283,5937345.8822],[606173.8295,5937369.8807],[606174.0985,5937401.8736],[606174.4446,5937443.1156],[606239.5097,5937442.5515],[606238.3429,5937261.0501]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Langlands Park","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[607123.43036143,5935441.89561979],[607123.37808827,5935309.3081312],[606957.58917645,5935315.37656502],[606968.4856831,5935443.94506618],[607123.43036143,5935441.89561979]]]]}' ), 'now', '{"id":0,"status":"no","name":"Botanical Gardens","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[604966.19632326,5934460.19362866],[604995.94957667,5934446.73615882],[604949.22097658,5934372.3063496],[604922.15816323,5934393.94108059],[604966.19632326,5934460.19362866]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Weir Park","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[607650.37537469,5935040.84527926],[607807.89679123,5935080.80186444],[607808.99783547,5935026.4211232],[607655.91062209,5935026.46272535],[607650.37537469,5935040.84527926]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Lions Park","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[607350.98205315,5935382.06954264],[607350.5867253,5935376.70273463],[607349.53852671,5935371.38500033],[607347.84543601,5935366.15681071],[607345.52033977,5935361.05795509],[607342.58093439,5935356.12723837],[607339.0495914,5935351.40218567],[607334.95318718,5935346.91875682],[607330.32289838,5935342.71107263],[607325.19396463,5935338.8111553],[607319.60542034,5935335.24868471],[607313.59979761,5935332.05077255],[607307.22280257,5935329.24175604],[607300.52296748,5935326.84301271],[607293.55128145,5935324.87279773],[607286.36080235,5935323.34610501],[607279.00625309,5935322.2745531],[607271.54360511,5935321.6662968],[607264.02965247,5935321.52596506],[607256.52157968,5935321.85462581],[607249.07652647,5935322.6497778],[607241.751153,5935323.90536965],[607234.60120865,5935325.61184591],[607227.6811078,5935327.75621974],[607221.0435157,5935330.32217175],[607214.73894773,5935333.2901742],[607208.81538491,5935336.63763957],[607203.3179088,5935340.33909245],[607198.28835838,5935344.36636339],[607193.76501166,5935348.68880329],[607189.78229433,5935353.27351661],[607186.37051778,5935358.08561168],[607183.5556484,5935363.08846627],[607181.35910988,5935368.24400625],[607179.79762022,5935373.51299533],[607178.88306439,5935378.85533372],[607178.62240392,5935384.23036323],[607179.01762381,5935389.59717671],[607180.06571742,5935394.91492942],[607181.75870933,5935400.14314983],[607184.08371597,5935405.24204769],[607187.02304365,5935410.17281682],[607190.55432321,5935414.89793049],[607194.6506802,5935419.38142704],[607199.28093939,5935423.58918359],[607204.40986207,5935427.48917574],[607209.99841416,5935431.05172134],[607216.00406331,5935434.24970642],[607222.38110261,5935437.05879155],[607229.08099844,5935439.45759711],[607236.05275984,5935441.42786604],[607243.24332665,5935442.95460279],[607250.59797332,5935444.02618746],[607258.06072542,5935444.63446428],[607265.57478574,5935444.77480366],[607273.0829665,5935444.44613745],[607280.52812468,5935443.65096705],[607287.85359695,5935442.3953444],[607295.0036309,5935440.6888259],[607301.92380945,5935438.54439967],[607308.56146497,5935435.97838668],[607314.86608017,5935433.01031653],[607320.7896726,5935429.66277881],[607326.28715978,5935425.96125111],[607331.31670241,5935421.93390515],[607335.8400227,5935417.61139233],[607339.82269578,5935413.02661039],[607343.23441159,5935408.21445309],[607346.0492056,5935403.21154456],[607348.2456564,5935398.05596056],[607349.80704866,5935392.78693869],[607350.72150036,5935387.44457979],[607350.98205315,5935382.06954264]]]]}' ), 'now', '{"id":0,"status":"no","name":"City Oval","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[605595.1035,5936459.7424],[605540.1377,5936460.5246],[605469.2684,5936434.9152],[605464.8995,5936433.3369],[605454.6146,5936461.8007],[605441.8677,5936497.0761],[605435.5978,5936514.4295],[605595.2957,5936571.9209],[605597.1029,5936572.5709],[605595.1035,5936459.7424]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Jenkinson Reserve","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
#
# INSERT INTO DATA(type, geometry, date, payload) values('test',  ST_GeomFromGeoJSON( '{"type":"MultiPolygon","coordinates":[[[[606238.3429,5937261.0501],[606172.9197,5937261.5821],[606172.9266,5937262.4264],[606173.0735,5937279.8884],[606173.212,5937296.3874],[606173.3505,5937312.8864],[606173.489,5937329.3865],[606173.6283,5937345.8822],[606173.8295,5937369.8807],[606174.0985,5937401.8736],[606174.4446,5937443.1156],[606239.5097,5937442.5515],[606238.3429,5937261.0501]]]]}' ), 'now', '{"id":0,"status":"offleash","name":"Langlands Park","regulation":"Horsham Rural City Council","comment":null,"off_rules":null,"on_rules":null,"no_rules":null,"url":null,"ref":null}' );
