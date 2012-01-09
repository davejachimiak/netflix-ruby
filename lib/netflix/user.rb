require 'netflix/json_resource'

module Netflix
  class User < JsonResource
    define_getter :can_instant_watch, :first_name, :last_name, :nickname, :user_id
    
    def initialize(oauth_access_token, user_id) #access_key, access_secret)
      @oauth_access_token = oauth_access_token
      @user_id = user_id
      super(retrieve)
    end
    
    def available_disc_queue
      @available_disc_queue ||= Queue.new(@oauth_access_token, user_id, Queue::TYPE_DISC)
    end
    
    private
    def retrieve
      response = @oauth_access_token.get "/users/#{@user_id}?output=json"
      if response && response.body && response.code_type == Net::HTTPOK
        JSON.parse(response.body)["user"]
      else
        raise "Error retrieving user #{@user_id}"
      end
    end
    
  end
end