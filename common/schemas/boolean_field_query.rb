{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "properties" => {

      "field" => {"type" => "string", "dynamic_enum" => "boolean_field_query_field", "ifmissing" => "error"},
      "value" => {"type" => "boolean", "ifmissing" => "error"},

    },
  },
}
