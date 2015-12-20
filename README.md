# pac_members


To do 

* Batch upload current emails and data after deployment
* DONE-- Figure out how to handle people who have already paid, and prevent them from paying early (probably just not allow anyone who's prior to expiration to pay, this is simplest, with different messages. maybe the way you email is 2 weeks ahead for subscribers, and when it expires for anyone who wasn't subscribed)
* DONE-- Re-do routes to only use what you need
* DONE-- Abstract out the functionality for the stripe charging into a service
* DONE-- Add first and last name to sign up
* DONE - scan function audited, and mailing tested with old email_q function-- Auto email two weeks ahead of expiration - use "whenever" gem. 3 cases: on membership and will renew (link to cancel), off membership and will expire, off membership and has expired
  * DONE-- Create Mailer
  * DONE-- Create functions to send separate emails
  * DONE-- Add method function to scan all users
  * DONE-- Add whenever job
* DONE-- Rather than create, force it on the backend so we can ask why people are cancelling, create an admin tool to do it. Create cancel subscription page (remove 'auto_renew' from field)

* DONE-- Style everything
* DONE-- Add Active Admin
* Enable receipt emails from Stripe (when live)
* Add cron job to let people opt in to auto-charge their CC and add to subscription if not on renewing plan? -> this is for the two weeks out prior to expiration thing, this also requires you to edit the mailer
* DONE -- Set up environment variables on heroku
* Test payment on live server

* DONE - Set up domain

* DONE-- Add new fields to user
	* membership_expiration date
	* stripe customer_id
	* subscription_id
	* auto_renew (on/off)
	* mailchimp or square data?
	* First and Last name
	* Any other fields from the original form on SquareSpace?

* HTTPS? - probably don't need with Stripe checkout.js

* All the other integrations (document)
  * Mailchimp
  * Square
  * Picatic
  * Apparently its just going to be importing all the data...

* Sign in webpage on tablet for events? (Works w/ Picatic + our membership db?) Or is Picatic just good enough
* Auto generate promo codes for users during events

* DONE - Phone numbers and mailing addresses -> add fields to sign up screens
* Create csv importer for old people <- add the actual stripe plans first to save yourself some god damn hassle!
* DONE - Create "youve been signed up here's your password" email
* DONE - Boot them to the "contact info" page for them to fill out. You should probably draw a flow diagram for the different situations
* DONE - Walk through sign up flow to make sure its reasonable
* DONE - Make sure expired accounts are updated on mailchimp
* DONE - Make sure that if someone pays their mailchimp is set to "member"
* DONE - Mailchimp first_or_create for when a user is created
* DONE - Verify that "create" with stripe won't create a brand new user if the email is found -> implications for renew, it does but this really doesn't matter
* DONE - Modify new user method to create a random password for the user
* DONE - Create "cancel subscription" method for admin dashboard (links to stripe as well)
* DONE - Will users who we remove from subscription  get another email when they expire? - Added dont_remind field
* DONE - they'll be kicked there but the membership_expiration field will be present so it won't ask them to pay - Verify that you're not kicking manually added users to the "please subscribe" page! Provided they've already paid, you can make this part of the "add users" admin function
* DONE - Verify that a users expiration will update itself if its autorenewing. Handled in expiration scanner
* Walk through user flow again?
* Remove random test account emails from Mailchimp