require './test/test_helper'

describe FindProposalService do

  before do
    @client = Client.create! name: 'Jim Smith', company: 'Special Widgets', website: 'http://specialwidgets.com'
  end

  describe '#call' do
    subject { FindProposalService }
    let (:proposal) { Proposal.create! name: "First Proposal", user_name: 'Jill Anders', client: @client }

    it 'must raise ActiveRecord::RecordNotFound' do
      proc { subject.call 9999 }.must_raise ActiveRecord::RecordNotFound
    end
    it 'must return proposal when proposal#id is used' do
      subject.call( proposal.id ).must_equal proposal
    end

  end

end