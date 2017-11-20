require_relative '../test_helper'

describe FederalState do
  let(:federal_state) { FederalState.new }

  subject { federal_state }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_many :locations }
    end
  end

  describe 'locations' do
    before do
      location = locations(:basic)
      subject.locations << location
    end

    it 'should not delete federal state' do
      assert_raises(ActiveRecord::DeleteRestrictionError) { subject.destroy }
    end
  end
end
