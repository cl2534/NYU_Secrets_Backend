class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    # should store secret in env variable
    JWT.encode(payload, 'my_s3cr3t')
  end

  def auth_header
    # Authorization: 'Bearer MYTOKEN'
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1] # header: {'Authorization': 'Bearer JWTTOKEN'}
      begin
        JWT.decode(token, 'my_s3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: 401 unless logged_in?
  end


    # before_action :authenticate_request
    # attr_reader :current_user
    #
    # include ExceptionHandler
    #
    # # [...]
    # private
    # def authenticate_request
    #   @current_user = AuthorizeApiRequest.call(request.headers).result
    #   render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    # end
end
