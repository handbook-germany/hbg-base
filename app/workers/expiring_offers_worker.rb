class ExpiringOffersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(3) }

  def perform
    # Find expiring offers
    expiring = Offer.approved.where('expires_at <= ?', Time.zone.today)
    return if expiring.count < 1

    # Create Asana Tasks
    asana = AsanaCommunicator.new
    expiring.find_each do |expiring_offer|
      asana.create_expire_task expiring_offer
    end

    # Info E-Mail
    OfferMailer.expiring_mail(expiring.count, expiring.pluck(:id)).deliver

    # Set to expired
    expiring.update_all aasm_state: 'expired' # TODO: should this be event?

    # trigger manual indexing for algolia search
    update_indices expiring
  end

  def update_indices expiring
    # has to work on model because the expiring array is not updated!!
    expiring.find_each do |expiring_offer|
      Offer.find(expiring_offer.id).index!
    end
  end
end
