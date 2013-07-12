# Finds a proposal based on the proposal id.
#
# Usage:
#
#   service = FindProposalService.new 99  
#   service.call
#
#   or you can use the class helper method #call:
#
#   FindProposalService.call 99 
#
# If a proposal with the given id exists, then the
# proposal is returned.
#
# If a proposal doesn't not exist with the given id, then
# ActiveRecord::RecordNotFound exception is thrown.
#
# @param proposal_id the id for the proposal
# @return proposal if one is found
class FindProposalService
  
  def self.call proposal_id
    self.new( proposal_id ).call
  end
  
  attr_reader :proposal_id
  
  def initialize proposal_id
    @proposal_id = proposal_id
  end
  
  def call
    Proposal.find proposal_id
  end
  
end