# pac_members


To do 

* DONE-- Add new fields to user
	* membership_expiration date
	* stripe customer_id
	* subscription_id
	* auto_renew (on/off)
	* mailchimp or square data?
	* First and Last name
	* Any other fields from the original form on SquareSpace?

* Add Active Admin
* Auto email two weeks ahead of expiration - use "whenever" gem
* HTTPS? - probably don't need with Stripe checkout.js
* Figure out how to handle people who have already paid, and prevent them from paying early (probably just not allow anyone who's prior to expiration to pay, this is simplest, with different messages. maybe the way you email is 2 weeks ahead for subscribers, and when it expires for anyone who wasn't subscribed)
* Set up mandrill
* Add bootstrap
* Re-do routes to only use what you need