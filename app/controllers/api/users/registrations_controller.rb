class Api::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  before_filter :not_allowed, only: [:new, :edit, :cancel, :show]



  def not_allowed
    raise MethodNotAllowed
  end

  # POST /v1/users
  def create

    username = params[:user]['username']

    password = params[:user]['password']
    password_confirmation = params[:user]['password_confirmation']
    user_type = params[:user]['user_type']

    # exception handling
    if username.nil? or password.nil?
      render json: { message: "username or password is empty test1 ppp" }, status: 400
      return
    elsif password_confirmation != password
      render json: { message: "passwords doesn't match" }, status: 400
      return
    elsif User.find_by_username(username.downcase)
      render json: { message: "username is already taken" }, status: 400
      return
    elsif not user_type.in?(['profile', 'admin'])
      render json: { message: "valid types are: profile" }, status: 400
      return
    end

    build_resource(sign_up_params)
    #Adminprofile
    case user_type
	 when 'admin'
	  @profile = Adminprofile.new(admin_profile_params)
	  resource.admin=true
	  resource.enabled=false
        when 'profile'
          @profile = Profile.new(user_profile_params)
	   resource.admin=false
	   resource.enabled=false
    end


    if resource.save
	@profile.user_id = resource.id
        if @profile.save
          smscode=generate_activation_code(resource)
          render json:{user: resource, smsCode:smscode}, status: :created
          return
        else
          render json: { message: "unkown error" }, status: 400
          return
        end
    else
      render json: { message: "cannot create user, unkown error" }, status: 400
      return
    end
  end

  private

    def sign_up_params
      params.require(:user).permit([
        :username,
        :password,
        :password_confirmation,
        :user_type
      ])
    end

    def admin_profile_params
      params.require(:profile).permit([
        :first_name,
        :last_name,
        :national_code,
        :gender
      ])
    end

    def user_profile_params
      params.require(:profile).permit([
        :first_name,
        :last_name,
        :gender,
        :national_code
      ])
    end



    def account_update_params
      params.require(:user).permit([ :username ])
    end
end
