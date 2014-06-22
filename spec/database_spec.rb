require 'spec_helper'

# describe 'DoubleDog database singleton' do
#   it "always returns the same object" do
#     database1 = DoubleDog.db
#     database2 = DoubleDog.db
#     # Create some data just in case
#     database1.create_item(:name => 'blah')

#     # They should still be equal
#     expect(database1).to eq database2
#   end

#   it "resets for every test" do
#     expect(DoubleDog.db.all_items.count).to eq 0
#   end
# end
