require 'rails_helper'

RSpec.describe Quote, type: :model do
  context 'Validation' do
    it { should validate_presence_of :title }
  end

  context '.random' do
    before { FactoryBot.create_list(:quote, 10) }

    it 'should provide random quote' do
      expect(Quote.random).to be_a_kind_of Quote
    end
  end
end
