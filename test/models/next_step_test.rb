require_relative '../test_helper'

describe NextStep do
  let(:next_step) { next_steps(:basic) }
  subject { next_step }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it 'must have a text_* for every available locale' do
      I18n.available_locales.each do |locale|
        subject.must_respond_to "text_#{locale}"
      end
    end
  end

  describe 'offers' do
    before do
      @offer = offers(:basic)
      subject.offers << @offer
      @next_step_offer = subject.next_steps_offers.first
      subject.destroy
    end

    it 'will destroy definitions offers' do
      assert_raises(ActiveRecord::RecordNotFound) do
        @next_step_offer.reload
      end
    end

    it 'will not destroy offers' do
      refute_nil @offer.reload
    end
  end

  describe 'methods' do
    describe '#text' do
      it 'should show text_[locale] for the current locale' do
        locale = I18n.available_locales.sample
        subject.send("text_#{locale}=", 'foobar')
        I18n.with_locale(locale) do
          subject.text.must_equal 'foobar'
        end
      end

      it 'should fall back to the en locale when the current one is empty' do
        subject.text_de = 'foo'
        subject.text_en = 'bar'
        subject.text_ar = ''
        I18n.with_locale(:ar) { subject.text.must_equal('bar') }
      end

      it 'should fall back to de locale when the current one & en are empty' do
        subject.text_de = 'foo'
        subject.text_en = ''
        subject.text_ar = nil
        I18n.with_locale(:ar) { subject.text.must_equal('foo') }
      end
    end
  end
end
