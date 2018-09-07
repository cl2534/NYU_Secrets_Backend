class Api::V1::AuthController < ApplicationController
  skip_before_action :authorized, only: [:create, :index]


  def create


    @user = User.find_by(email: user_login_params[:email])
  
    # if the user exists (IS NOT NIL), ruby will attempt to authenticate
    # without this check, I will try to call .authenticate on NIL
    if !!@user && @user.authenticate(user_login_params[:password])
      # encode token comes from applicaiton controller
      token = encode_token(user_id: @user.id)

      render json: { user: UserSerializer.new(@user), jwt: token }, status: 202
    else
      render json: { message: 'Invalid email or password' }, status: 401
    end
  end

  private

  def user_login_params
    # params {user: {username: 'Chandler Bing', password: 'hi' }}
    params.require(:user).permit(:email, :password)
  end
end
