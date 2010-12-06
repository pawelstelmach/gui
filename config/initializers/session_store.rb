# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_soa_session',
  :secret      => '852a6c0e63b0e1d91c3f8aca1485020513e0838e4ebfeff859fffd9c4deb94bf58f0125ae2ae7a36e8b6d6e1324dafd76e141fd862068bb41909fbf392efddc5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
