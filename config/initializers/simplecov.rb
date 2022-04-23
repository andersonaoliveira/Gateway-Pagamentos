if Rails.env.test?
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter(/channels/)
    add_filter(/jobs/)
    add_filter(/mailers/)
    add_filter(/helpers/)
  end
end
