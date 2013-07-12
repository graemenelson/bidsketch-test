Given(/^a proposal named "(.*?)" for the "(.*?)" company$/) do |proposal_name, company_name|
  client = Client.find_by_company! company_name
  Proposal.create!  name:   proposal_name,
                    user_name: 'Jill Anders',
                    client: client
end

Given(/^the "(.*?)" proposal was sent (\d+) days ago$/) do |proposal_name, number_of_days|
  proposal = Proposal.find_by_name! proposal_name
  proposal.update_attribute( :send_date, number_of_days.to_i.days.ago )
end

Given(/^the "(.*?)" proposal has sections$/) do |proposal_name, table|
  proposal = Proposal.find_by_name! proposal_name
  table.hashes.each do |row|
    proposal.proposal_sections.create!  name:         row["Name"], 
                                        description:  row["Description"]
  end
end

When(/^one views the "(.*?)" proposal$/) do |proposal_name|
  proposal = Proposal.find_by_name! proposal_name
  visit "/proposal_viewer/show/#{proposal.to_param}"
end

Then(/^the page for the "(.*?)" proposal should be displayed$/) do |proposal_name|
  proposal = Proposal.find_by_name! proposal_name
  client   = proposal.client
  assert_equal client.name, page.find('h1#client_name').text
  assert_equal proposal.name, page.find('h2#project_name').text
  assert_equal proposal.send_date.to_date.to_s(:long), page.find('.contact-info #sent_date').text
  assert_equal proposal.user_name, page.find('.contact-info #my_name').text  
  assert_equal client.name, page.find('.contact-info #client_contact_name').text
  assert_equal client.company, page.find('#my_company h1').text
  assert_equal client.website, page.find('#my_company div').text
  
  proposal.proposal_sections.each_with_index do |section, index|
    assert_equal section.name, page.find("#proposal-content div#proposal_section_#{section.id} h1").text.strip
    assert_equal section.description, page.find("#proposal-content div#proposal_section_#{section.id} div").text.strip
  end
end