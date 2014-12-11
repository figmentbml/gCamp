class TrackerAPI

#state that class will store
  def initialize
    @conn = Faraday.new(:url => 'https://www.pivotaltracker.com')
  end
#behavior for class. pass in token as an arguement
  def projects(token)
    return [ ] if token.nil? #precondition
    response = @conn.get do |req|
      req.url "/services/v5/projects"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = token
    end
    JSON.parse(response.body, symbolize_names: true)
  end

end
