csv-to-ldap
===========

Script to take a CSV file of netids, and auto-fill with info from LDAP.

##To Run This Script
1. `git clone git://github.com/adambray/csv-to-ldap.git`
2. `cd csv-to-ldap`

###NetIDs => Email

3. Create a csv with just netids in the first column. I recommend saving it in the same folder as the script, as `netids.csv`.
4. `ruby netid_to_email.rb netids.csv`
5. Behold, the file `data/output {currentdate+time}.csv` has the information you want!

###Email => NetIDs

3. Create a csv with just netids in the first column. I recommend saving it in the same folder as the script, as `emails.csv`.
4. `ruby email_to_netid.rb emails.csv`
5. Behold, the file `data/output {currentdate+time}.csv` has the information you want!
