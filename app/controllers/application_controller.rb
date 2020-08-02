class ApplicationController < ActionController::API
	
	def encode_token(payload)
		JWT.encode(payload, 's3cr3t')
	end

  def authenticate_user!
  	token = request.headers['token']
    unless User.find_by(authentication_token: token).present?
    	render json: { message: 'Please log in' }, status: :unauthorized 
    end
  end

  def current_user
    token = request.headers['token']
    user = User.find_by(authentication_token: token)
  end

end
