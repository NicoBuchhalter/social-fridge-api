require 'rails_helper'

describe Fridge, :vcr do
  it_behaves_like 'locatable'
end
