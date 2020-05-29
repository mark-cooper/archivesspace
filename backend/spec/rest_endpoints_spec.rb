require 'spec_helper'
# ./build/run backend:test -Dexample='REST Endpoints'

RSpec.describe 'REST Endpoints' do
  describe 'GET /endpoints' do
    it 'returns a list of endpoints' do
      get '/endpoints'
      parsed = JSON.parse(last_response.body)
      expect(last_response.status).to eq(200)
      expect(parsed.count).to eq(RESTHelpers::Endpoint.all.uniq.count)
      expect(parsed.first.key?('uri')).to be_truthy
    end
  end

  it 'returns a single endpoint when specifying a unique uri' do
    uri = '/users/:username/login'
    get '/endpoints', uri: uri
    parsed = JSON.parse(last_response.body)
    expect(last_response.status).to eq(200)
    expect(parsed.count).to eq(1)
    expect(parsed.first['uri']).to eq(uri)
  end

  it 'returns not found when specifying a non-existent uri' do
    get '/endpoints', uri: '/nope/:no/such/endpoint'
    parsed = JSON.parse(last_response.body)
    expect(last_response.status).to eq(404)
    expect(parsed['error']).to eq('NotFoundException')
  end
end
