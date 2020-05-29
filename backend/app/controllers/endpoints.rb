# frozen_string_literal: true

class ArchivesSpaceService < Sinatra::Base
  Endpoint.get('/endpoints')
          .description('ArchivesSpace Endpoints')
          .example('shell') do
            <<~SHELL
              curl "http://localhost:8089/endpoints"
              curl "http://localhost:8089/endpoints?uri=/users"
              curl "http://localhost:8089/endpoints?uri=/users/:username/login"
            SHELL
          end
          .documentation do
            <<~DOCS
              This route returns all ArchivesSpace endpoints, or only those matching
              the `uri` parameter if specified.
            DOCS
          end
          .params(['uri', String, 'URI filter', optional: true])
          .permissions([])
          .returns([200, 'ArchivesSpace Endpoints'], [404, "Endpoint not found"]) \
  do
    endpoints = find_endpoints(params[:uri])
    raise NotFoundException.new if endpoints.empty?
    json_response(endpoints)
  end

  def find_endpoints(uri)
    Endpoint.all
            .sort { |a, b| a[:uri] <=> b[:uri] }
            .find_all { |e| uri ? e[:uri].start_with?(uri) : true }
            .uniq
  end
end
