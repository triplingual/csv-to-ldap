require 'net-ldap'
require 'csv'

#Pull emails from the first variable given to this script
PATH = ARGV[0]
emails = CSV.read(PATH).flatten

#Search based on these LDAP attributes
LDAP_ATTRS = ["uid", "givenname", "sn", "mail", "collegename", "college", "class"]

#Misc Setup
ldap = Net::LDAP.new(:host => "directory.yale.edu", :port => 389)
people = []

#Loop one email at a time
emails.each_with_index do |email, i|
  puts "#{i*100/emails.size}%"

  #Search LDAP by email
  filter = Net::LDAP::Filter.eq("mail", email)
  result = ldap.search(:base => "ou=People,o=yale.edu", :filter => filter, :attributes => LDAP_ATTRS)
  people[i] = []

  if result[0]
    LDAP_ATTRS.each do |attr|
      people[i] << result[0][attr.to_sym][0]
    end   				
  else
    people[i] << email << "NOT VALID"
  end
end

#Write results to output.csv
CSV.open("data/output.csv", "wb") do |csv|
  csv << LDAP_ATTRS
  people.each do |person|
    csv << person
  end
end
