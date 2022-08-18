require 'rails_helper'

RSpec.describe Quote, type: :model do
  context 'Validation' do
    it { should validate_presence_of :title }
  end
end
