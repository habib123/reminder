Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle("requests by ip", limit: 2, period: 10) do |request|
  if request.path == '/reminders/1' && request.get?
    request.ip
  end
end

#Rack::Attack.throttle('limit logins per email', limit: 2, period: 30) do |req|
#  if req.path == '/users/sign_in' && req.post?
#    # Normalize the email, using the same logic as your authentication process, to
    # protect against rate limit bypasses.
#    req.params['email'].to_s.downcase.gsub(/\s+/, "")
#  end
#end

Rack::Attack.throttled_response = lambda do |env|
  match_data = env['rack.attack.match_data']
  now = match_data[:epoch_time]
#binding.pry
  headers = {
    'RateLimit-Limit' => match_data[:limit].to_s,
    'RateLimit-Remaining' => '0',
    'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s,
    'match_data' => match_data[:period],
    'now' => match_data[:epoch_time]
  }

  [ 429, headers, ["Throttled\n"]]
end
