require 'sinatra'
require 'sinatra/contrib'
require 'net-ldap'
require 'pry'

enable :sessions


class YaleLDAPConverter
    LDAP_ATTRS = %w(uid givenname sn mail collegename college class UPI)

    def self.convertfromnetids(netids)
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

        return people
    end

    def self.convertfromemails(emails)
        ldap = Net::LDAP.new(host: 'directory.yale.edu', port: 389)
        people = []

        # Loop one email at a time
        emails.each_with_index do |email, i|
          puts "#{i * 100 / emails.size}%"

          # Search LDAP by email
          filter = Net::LDAP::Filter.eq('mail', email)
          result = ldap.search(base: 'ou=People,o=yale.edu',
                               filter: filter,
                               attributes: LDAP_ATTRS)
          people[i] = []

          if result[0]
            LDAP_ATTRS.each do |attr|
              people[i] << result[0][attr.to_sym][0]
            end
          else
            people[i] << email << 'NOT VALID'
          end
        end

        return people
    end
    # # Write results to output.csv
    # filetoprintto = 'data/output ' + Time.now.strftime('%Y-%m-%d %H%M%S') + '.csv'
    # CSV.open(filetoprintto, 'wb') do |csv|
    #   csv << LDAP_ATTRS
    #   people.each do |person|
    #     csv << person
    #   end
    # end
end


get '/' do
  erb :index
end

post '/parse' do
    if params[:submit] == "Convert From NetID"
        netidlist = params[:inputlist].split("\r\n")
        @people = YaleLDAPConverter.convertfromnetids(netidlist)
    elsif params[:submit] == "Convert From Email"
        emaillist = params[:inputlist].split("\r\n")
        @people = YaleLDAPConverter.convertfromemails(emaillist)
    end
    session[:people] = @people
    session[:lasttime] = Time.now.to_s
    redirect to('/output')
end

get '/output' do
    if session[:people]
        @people = session[:people]
        erb :output
    else
        "nobody searched yet"
    end
end