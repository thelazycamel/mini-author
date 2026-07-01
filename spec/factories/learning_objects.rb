FactoryBot.define do
  factory :learning_object do
    name { "Test Learning Object" }
    site
    lo do
      file = Tempfile.new(["test", ".zip"])
      file.write("zip content")
      file.rewind
      Rack::Test::UploadedFile.new(file.path, "application/zip")
    end

    trait :with_info_xml do
      info_xml do
        file = Tempfile.new(["info", ".xml"])
        file.write("<info/>")
        file.rewind
        Rack::Test::UploadedFile.new(file.path, "application/xml")
      end
    end
  end
end
