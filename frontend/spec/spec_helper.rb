require 'jsonmodel'
require 'frontend_enum_source'
JSONModel::init(:client_mode => false, :strict_mode => false, :enum_source => FrontendEnumSource.new)
include JSONModel

