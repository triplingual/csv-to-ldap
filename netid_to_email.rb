require 'net-ldap'
require 'csv'

PATH = ARGV[0]
LDAP_ATTRS = ["uid", "givenname", "sn", "mail", "collegename", "college", "class"]

netids = CSV.read(PATH).flatten

ldap = Net::LDAP.new(:host => "directory.yale.edu", :port => 389)

people = []

netids.each_with_index do |netid, i|
	puts "#{i*100/netids.size}%"
	
  filter = Net::LDAP::Filter.eq("uid", netid)
	result = ldap.search(:base => "ou=People,o=yale.edu", :filter => filter, :attributes => LDAP_ATTRS)
    people[i] = []
  
    if result[0]
	    LDAP_ATTRS.each do |attr|
	    	people[i] << result[0][attr.to_sym][0]
	    end   				
    else
      people[i] << netid << "NOT VALID"
	end
end

CSV.open("output.csv", "wb") do |csv|
	csv << LDAP_ATTRS
	people.each do |person|
		csv << person
	end
end