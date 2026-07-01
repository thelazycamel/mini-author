FactoryBot.define do
  factory :structure do
    name { "Test Structure" }
    site
    structure_xml do
      file = Tempfile.new(["structure", ".xml"])
      file.write("<structure><node/></structure>")
      file.rewind
      Rack::Test::UploadedFile.new(file.path, "application/xml")
    end
  end
end
