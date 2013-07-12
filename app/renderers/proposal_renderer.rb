require_relative 'base_renderer'
# Renders a given proposal based on the defined template.
#
# The template is an html document with placeholders starting
# with '{' and endingin with '}'.  For example:
#
# <h1 id="client_name">{client_name}</h1>
#
# The '{client_name}' would be replaced with the given proposal client name.
#
# The renderer is also responsible for rendering the collection of
# proprosal sections based on the associated proposal_sections for the
# given proposal.
#
# @param proposal the proposal to render
# @return String the populated html document
class ProposalRenderer < BaseRenderer
  
  template  'public/proposal-template/index.html'
  
  def self.render proposal
    self.new( proposal ).render
  end
  
  attr_reader :proposal
  
  def initialize proposal    
    @proposal = proposal
  end
  
  def proposal_name
    proposal.name
  end
  
  def proposal_send_date
    proposal.send_date.to_date.to_s(:long)
  end
  
  def proposal_user_name
    proposal.user_name
  end
  
  def client_name
    client.name
  end
  
  def client_company
    client.company
  end
  
  def client_website
    client.website
  end
  
  def client
    proposal.client
  end
  
  private

  def after_render_template
    proposal_content  = document.at_css('#proposal-content')
    proposal_section  = proposal_content.at_css('#proposal_section')
    proposal_section.remove
    proposal.proposal_sections.collect do |section|
      proposal_content.add_child( render_proposal_section( proposal_section.to_html, section ) )
    end
  end
  
  def render_proposal_section html, section
    html
      .gsub("id=\"proposal_section\"", "id=\"proposal_section_#{section.id}\"")
      .gsub('{section_header}', section.name)
      .gsub('{section_content}', section.description)
  end
  
end