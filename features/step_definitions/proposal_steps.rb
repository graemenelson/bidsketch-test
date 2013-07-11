Given(/^a proposal named "(.*?)" for the "(.*?)" company$/) do |proposal_name, company_name|
  client = Client.find_by_company! company_name
  Proposal.create!  name:   proposal_name, 
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
  pending
  proposal = Proposal.find_by_name! proposal_name
  client   = proposal.client
  page.find('h1#client_name').text.must_equal client.name
  page.find('h2#project_name').text.must_equal proposal.name
end