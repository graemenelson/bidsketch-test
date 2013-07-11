Feature: Proposal
  One with the appropriate authorization should be
  able to create, view, edit and remove a proposal.
  
  Background:
    Given a client
    | Name        | Company   | Website             |
    | John Smith  | Sunshine  | http://sunshine.com |
    And a proposal named "Website Redesign" for the "Sunshine" company
    And the "Website Redesign" proposal was sent 2 days ago
    And the "Website Redesign" proposal has sections
    | Name      | Description                           |
    | Section 1 | This is the description for section 1 |
    | Section 2 | This is the description for section 2 |
    
  Scenario: View an existing proposal
   When one views the "Website Redesign" proposal
   Then the page for the "Website Redesign" proposal should be displayed
   
   
