Site.find_or_create_by!(name: "Magnet Local Importer on Docker") do |site|
  site.domain = "http://default.importer.magnet.test"
  site.port = ""
  site.path = "d2l/api/lr/1.0/objects"
  site.structure_path = "internal/api/v1/structures"
end

Site.find_or_create_by!(name: "Localhost") do |site|
  site.domain = "http://localhost"
  site.port = "3004"
  site.path = "d2l/api/lr/1.0/objects"
  site.structure_path = "internal/api/v1/structures"
end
