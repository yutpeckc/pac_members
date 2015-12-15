class Mailchimp
  attr_reader :list_id
  # main list id: f2616de278

  def initialize
    @list_id = "f2616de278"
  end

  def change_membership(user,membership)
    # two options for: member, expired
    Gibbon::Request.lists(@list_id).members(get_user_hash(user.email)).upsert(body: {email_address: user.email, status: "subscribed", merge_fields: {MEMBERSHIP: membership.downcase}})
  end

  def change_email(original_email,new_email)
    Gibbon::Request.lists(@list_id).members(get_user_hash(email)).upsert(body: {email_address: email, status: "subscribed"})
  end

  def add_user(user)
    Gibbon::Request.lists(@list_id).members(get_user_hash(user.email)).upsert(body: {email_address: user.email, status: "subscribed", merge_fields: {FNAME: user.first_name, LNAME: user.last_name})
  end

  def get_user_hash(email)
    Digest::MD5.hexdigest(email.downcase)
  end

end