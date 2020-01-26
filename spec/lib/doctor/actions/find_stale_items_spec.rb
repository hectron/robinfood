require 'rails_helper'

describe Doctor::Actions::FindStaleItems do
  describe '.call!' do
    subject { described_class.call! }

    context 'when no duplicate items are available before today' do
      it 'does not return them' do
        FoodItem.create(name: 'Foo', restaurant: 'Soylent', price: 6.5, date_offered: 1.day.from_now)
        FoodItem.create(name: 'Foo', restaurant: 'Soylent', price: 7.0, date_offered: 2.days.from_now)

        expect(subject).to eq([])
      end
    end

    context 'when there are duplicate items in the past' do
      it 'returns them' do
        item_one   = FoodItem.create(name: 'Foo', restaurant: 'Soylent', price: 6.5, date_offered: 3.day.ago)
        item_two   = FoodItem.create(name: 'Foo', restaurant: 'Soylent', price: 6.5, date_offered: 2.days.ago)
        item_three = FoodItem.create(name: 'Foo', restaurant: 'Soylent', price: 6.5, date_offered: 1.days.ago)
        item_four  = FoodItem.create(name: 'Foo', restaurant: 'Soylent', price: 7.0, date_offered: 1.day.from_now)

        result = subject
        expect(result).not_to include(item_three.id)
        expect(result).not_to include(item_four.id) # the different priced item
        expect(result).to include(item_one.id, item_two.id)
      end
    end
  end
end