require 'spec_helper'

describe "GET '/'" do
  it 'return ok status' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'return json' do
    get '/'
    expect(last_response.header['Content-Type']).to include 'application/json'
  end

  it 'invoke proper Exchanger method' do
    expect_any_instance_of(Exchanger).to receive(:coins)
    get '/'
  end
end

describe "GET '/exchange'" do
  it 'return ok status' do
    get '/exchange?amount=12'
    expect(last_response).to be_ok
  end

  it 'return json' do
    get '/exchange?amount=12'
    expect(last_response.header['Content-Type']).to include 'application/json'
  end

  it 'invoke proper method on Exchanger' do
    expect_any_instance_of(Exchanger).to receive(:exchange)
    get '/exchange?amount=12'
  end

  it 'doesnt fail without parameter' do
    get '/exchange'
    expect(last_response).to be_ok
  end
end

describe "POST '/add'" do
  it 'return ok status' do
    post '/add', { 1 => 12, 3 => 23 }.to_json
    expect(last_response).to be_ok
  end

  it 'invoke proper method on Exchanger' do
    expect_any_instance_of(Exchanger).to receive(:add)
    post '/add', { 1 => 12, 3 => 23 }.to_json
  end

  it 'return 400 for empty body' do
    post '/add'
    expect(last_response.status).to be(400)
  end

  it 'return 400 for incorrect body' do
    post '/add', { qwe: { 1 => 12, 3 => 23 } }.to_json
    expect(last_response.status).to be(400)
  end

  it 'return json' do
    post '/add', { 1 => 12, 3 => 23 }.to_json
    expect(last_response.header['Content-Type']).to include 'application/json'
  end
end
