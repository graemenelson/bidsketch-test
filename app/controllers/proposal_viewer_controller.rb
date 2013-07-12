class ProposalViewerController < ApplicationController
  
  def show
    proposal = FindProposalService.call params[:id]
    render :text => ProposalRenderer.render( proposal )
  end
  
end
