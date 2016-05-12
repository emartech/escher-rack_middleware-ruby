require 'spec_helper'

describe Escher::RackMiddleware do

  let(:escher_rack_middleware) { described_class }

  it 'serves correct, Escher signed requests only' do
    expect(get('/any_path').status).to eq 401
  end

  it 'allow pass on valid request' do
    expect(escher_signed_get('/').status).to eq 200
  end

  it 'should exclude the excluded paths' do
    expect(get('/not_protected').status).to eq 200
  end

  it 'should include the included paths alike' do
    expect(get('/protected').status).to eq 401
    expect(escher_signed_get('/protected').status).to eq 200
  end

  it 'should include the included paths even on partial matching with exclude paths' do
    expect(get('/unprotected_namespace/except_this_endpoint_which_is_included').status).to eq 401
    expect(escher_signed_get('/unprotected_namespace/except_this_endpoint_which_is_included').status).to eq 200
  end

end