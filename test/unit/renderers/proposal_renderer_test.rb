require './test/test_helper'

describe ProposalRenderer do

  let(:client)    { Client.create! name: 'John Smith', company: 'Special Widgets', website: 'http://specialwidgets.com' }
  let(:proposal)  do 
    proposal = Proposal.create! name: 'First Design', user_name: 'Jill Anders', send_date: 2.days.from_now, client: client
    proposal.proposal_sections.create! name: "Section 1", description: "Description for Section 1"
    proposal.proposal_sections.create! name: "Section 2", description: "Description for Section 2"
    proposal
  end
  
  subject         { ProposalRenderer.new proposal }
  
  describe '#render' do
    let( :output  ) { subject.render }
    let( :page    ) { Nokogiri::HTML output }
    it 'must have client_name for h1#client_name' do
      page.css('h1#client_name').text.must_equal client.name
    end    
    it 'must have proposal name for h2#project_name' do
      page.css('h2#project_name').text.must_equal proposal.name
    end
    describe '.contact-info' do
      let( :contact_info ) { page.css('.contact-info') }
      it 'must have send_date for td#send_date' do
        contact_info.css('#sent_date').text.must_equal proposal.send_date.to_date.to_s(:long)
      end
      it 'must have proposal_user_name for #my_name' do
        contact_info.css('#my_name').text.must_equal proposal.user_name
      end
      it 'must have client_name for #client_contact_name' do
        contact_info.css('#client_contact_name').text.must_equal client.name
      end
    end
    describe '#my_company' do
      let( :my_company ) { page.css('#my_company') }
      it 'must have client company for h1' do
        my_company.css('h1').text.must_equal client.company
      end
      it 'must have client website' do
        my_company.css('div#my_company > div').text.must_equal client.website
      end
    end
    describe '#proposal-content' do
      let( :proposal_content ) { page.css('#proposal-content') }
      describe 'for proposal_section 1' do
        let( :proposal_section ) { proposal.proposal_sections.first }
        it 'must render a proposal_section_:id section' do
          proposal_content.css("#proposal_section_#{proposal_section.id}").wont_be :empty?
        end
        it 'must render section name for h1' do
          proposal_content.css("#proposal_section_#{proposal_section.id} h1").text.strip.must_equal proposal_section.name
        end
        it 'must render section description for div' do
          proposal_content.css("#proposal_section_#{proposal_section.id} div").text.strip.must_equal proposal_section.description
        end
      end
      describe 'for proposal_section 2' do
        let( :proposal_section ) { proposal.proposal_sections.last }
        it 'must render a proposal_section_:id section' do
          proposal_content.css("#proposal_section_#{proposal_section.id}").wont_be :empty?
        end
        it 'must render section name for h1' do
          proposal_content.css("#proposal_section_#{proposal_section.id} h1").text.strip.must_equal proposal_section.name
        end
        it 'must render section description for div' do
          proposal_content.css("#proposal_section_#{proposal_section.id} div").text.strip.must_equal proposal_section.description
        end        
      end
    end    
  end
  
  
end