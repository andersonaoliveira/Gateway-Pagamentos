class ProductGroup
  attr_accessor :id, :name, :key, :description, :icon

  def initialize(id:, name:, key:, description:, icon:)
    @id = id
    @name = name
    @key = key
    @description = description
    @icon = icon
  end

  def self.all
    response = Faraday.get("#{ProductGroup.domain}/api/v1/product_groups")

    return nil unless response.status == 200

    generate(response)
  rescue StandardError
    nil
  end

  def self.find(id)
    response = Faraday.get("#{ProductGroup.domain}/api/v1/product_groups/#{id}")
    return nil unless response.status == 200

    product_group = JSON.parse(response.body)
    ProductGroup.new(id: product_group['id'], name: product_group['name'], key: product_group['key'],
                     description: product_group['description'], icon: product_group['icon'])
  rescue StandardError
    nil
  end

  def self.generate(response)
    result = []
    product_groups = JSON.parse(response.body)
    product_groups.each do |p|
      result << ProductGroup.new(id: p['id'], name: p['name'], key: p['key'],
                                 description: p['description'], icon: p['icon'])
    end
    result
  end

  def self.domain
    Rails.configuration.apis['products_api']
  end
end
