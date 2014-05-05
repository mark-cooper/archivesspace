require_relative 'utils'

Sequel.migration do

  up do
    $stderr.puts("Adding public and staff interface advanced search field enums")
    create_enum("field_query_field", ["fullrecord", "title", "creators_text", "notes", "subjects_text"], "fullrecord")
    create_enum("staff_field_query_field", ["fullrecord", "title", "creators_text", "notes", "subjects_text"], "fullrecord")
  end

end