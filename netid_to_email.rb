# encoding: utf-8

require 'net-ldap'
require 'csv'

# Pull NetIDs from the first variable given to this script
if ARGV[0]
  PATH = ARGV[0]
else
  PATH = 'data/netids.csv'
end
netids = CSV.read(PATH).flatten

# Uncomment this if the netids come in with @yale.edu appended
netids = netids.map { |a| a.chomp('@yale.edu') }

# Search based on these LDAP attributes
LDAP_ATTRS = %w(uid givenname sn mail collegename college class UPI)

# Misc Setup
ldap = Net::LDAP.new(host: 'directory.yale.edu', port: 389)
people = []

# Loop one netid at a time
netids.each_with_index do |netid, i|
  puts "#{i * 100 / netids.size}%"

  # Search LDAP by netid
  filter = Net::LDAP::Filter.eq('uid', netid)
  result = ldap.search(base: 'ou=People,o=yale.edu',
                       filter: filter,
                       attributes: LDAP_ATTRS)
  people[i] = []

  if result[0]
    LDAP_ATTRS.each do |attr|
      people[i] << result[0][attr.to_sym][0]
    end
  else
    people[i] << netid << 'NOT VALID'
  end
end

# Write results to output.csv
filetoprintto = 'data/output ' + Time.now.strftime('%Y-%m-%d %H%M%S') + '.csv'
CSV.open(filetoprintto, 'wb') do |csv|
  csv << LDAP_ATTRS
  people.each do |person|
    csv << person
  end
end
