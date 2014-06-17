csv-to-ldap
===========
Take a list of netids, and auto-fill additional information from LDAP.


#Sinatra App
This can be run as a sinatra application

1. Clone the repository
2. Run `bundle install`
3. Run the sinatra server with `ruby converter.rb`
4. Go to the sinatra server in the browser, at `localhost:4567`


#Ruby Script
##To Run This Script
1. `git clone` this repository
2. `cd csv-to-ldap`

###NetIDs => Email

3. Create a csv with just netids in the first column. I recommend saving it in the same folder as the script, as `netids.csv`.
4. `ruby netid_to_email.rb netids.csv`
5. Behold, the file `data/output {currentdate+time}.csv` has the information you want!

###Email => NetIDs

3. Create a csv with just netids in the first column. I recommend saving it in the same folder as the script, as `emails.csv`.
4. `ruby email_to_netid.rb emails.csv`
5. Behold, the file `data/output {currentdate+time}.csv` has the information you want!