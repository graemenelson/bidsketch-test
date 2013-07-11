Given(/^a client$/) do |table|
  table.hashes.each do |row|
    Client.create! name: row["Name"], company: row["Company"], website: row["Website"]
  end
end