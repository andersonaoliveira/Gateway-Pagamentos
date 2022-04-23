require 'rails_helper'

api_domain = Rails.configuration.apis['products_api']

RSpec.describe ProductGroup, type: :model do
  it '.all' do
    product_groups = File.read(Rails.root.join('spec', 'support', 'api_resources', 'product_groups.json'))
    response = Faraday::Response.new(status: 200, response_body: product_groups)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/product_groups").and_return(response)

    result = ProductGroup.all

    expect(result[0].name).to include 'Email'
    expect(result[1].name).to include 'Cloud'
  end

  it '.find' do
    product_group = File.read(Rails.root.join('spec', 'support', 'api_resources', 'product_group.json'))
    response = Faraday::Response.new(status: 200, response_body: product_group)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/product_groups/1").and_return(response)

    result = ProductGroup.find('1')

    expect(result.name).to include 'Email'
    expect(result.description).to include 'Serviços de Email'
    expect(result.id).to eq 1
  end

  it '.all failure' do
    product_groups = []
    response = Faraday::Response.new(status: 200, response_body: product_groups)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/product_groups").and_return(response)
    result = ProductGroup.all

    expect(result).to eq nil
  end

  it '.find failure' do
    product_group = []
    response = Faraday::Response.new(status: 200, response_body: product_group)
    allow(Faraday).to receive(:get).with("#{api_domain}/api/v1/product_groups/578").and_return(response)
    result = ProductGroup.find('578')

    expect(result).to eq nil
  end
end
