class Api::UsersController < ApplicationController

  before_action :doorkeeper_authorize! , except: [ :activate_account , :resend_activation_code]
  before_action :admin_authorize! ,only:[:index]


  # POST /api/activate_account
  def activate_account
    if params[:username].nil?
      render json: { message: "username is empty" }, status: 400
      return
    end

    @user = User.find_by(username: params[:username])

    if @user.nil?
      render json: { message: "username is not valid" }, status: 400
      return
    end

    if @user.try(:enabled?)
      render json: { message: "no need for activation" }, status: 200
      return
    end

    code = params[:sms_code]

    if @user.admin
      @user.enabled = true
    elsif code.nil?
      render json: { message: "security code is empty."}, status: 400
      return
    else
      smscode=params[:sms_code].to_s
      @get_retrive=RegistrationCode.find_by(sms_code: smscode, user_id: current_resource_owner.id)
      if @get_retrive.nil?
       render json:{message:"the sercurity code is incorrect"},status:400
       return
      end
      logger.info "################ The Registration is this: #{smscode} = #{@get_retrive.sms_code}  ########################"
      ## set it to true if the code is valid
      if smscode == @get_retrive.sms_code.to_s
        is_code_valid = true
      else
        logger.info "################ The Registration is False: #{@get_retrive.sms_code} ########################"
        is_code_valid = false
      end

      if is_code_valid
        logger.info "################ The Registration is True: #{is_code_valid} ########################"
        @user.enabled = true

        if @user.user_type == "profile"
          @profile=Profile.new
        else
          @profile=Adminprofile.new
        end
      else
        render json: { message: "code is not valid."}, status: 403
        return
      end
    end
    logger.info "################ Now We are in Save Process ########################"
    if @user.save and @profile.save
      render json: { message: "successfully activated" }, status: :created
    else
      render json: { message: "unkown error" }, status: 400
    end
  end

  # POST /api/resend_activation_code
  def resend_activation_code

    if params[:username].nil?
      render json: { message: "username is empty" }, status: 400
      return
    end

    @user = User.find_by(username: params[:username])

    if @user.nil?
      render json: { message: "username is not found" }, status: 404
      return
    end

    if @user.try(:enabled?)
      render json: { message: "no need for activation" }, status: 200
      return
    elsif (@user.registration_code.sent_time + 5.minutes) > 0.second.from_now
     to_wait = @user.registration_code.sent_time + 5.minutes - 0.second.from_now
     render json: { message: "please wait for #{to_wait.round} seconds" }, status: 401
    else
      ## Generate and send SMS code
      #send_sms(@user.username, )
      ## change sent time for the registration code
      @user.registration_code.update(sent_time: 0.second.from_now)
      render json: { message: "successfully sent.", sms_code: generate_activation_code(@user) }, status: :ok
    end
  end

  # GET /v1/users
  def index
    render json: User.all
  end

  # GET /v1/me
  def me
    render json: current_resource_owner
  end

  # GET /api/my_profile
  def my_profile
    user_type = current_resource_owner.user_type
    case user_type
    when 'profile'
      @profile = Profile.find_by(user_id:current_resource_owner.id)
      render json: {user_id: @profile.user_id,
                    profile_id: @profile.id,
                    first_name: @profile.first_name,
                    last_name: @profile.last_name,
                    avatar_url: @profile.image.url,
                    national_id: @profile.national_code,
                    gender: @profile.gender ? "true" : "false",
                    username: current_resource_owner.username,
                    user_type:current_resource_owner.user_type}, status: :ok
    when 'admin'
      ## Not Implemented

     @admin_profile = Adminprofile.find_by(user_id:current_resource_owner.id)
     render json: {
                   user_id: current_resource_owner.id,
                   profile_id: @admin_profile.id,
                   first_name: @admin_profile.first_name,
                   last_name: @admin_profile.last_name,
                   national_id: @admin_profile.national_code,
                   avatar_url: @admin_profile.image.url,
                   gender: @admin_profile.gender ? "true" : "false",

                   username: current_resource_owner.username ,
                   user_type:current_resource_owner.user_type}, status: :ok
    end
  end

  # GET /api/my_tokens
  def my_tokens
    @access_tokens = Doorkeeper::AccessToken.where(resource_owner_id:
                                                   current_resource_owner.id)
    @active_tokens = Array.new
    @access_tokens.find_each do |token|
      if not token.expired? and not token.revoked?
        @active_tokens << {token: token.token,
                           creation_date: token.created_at,
                             ttl: token.expires_in_seconds}
      end
    end
    render json: @active_tokens
  end


  # POST /api/users/:id
  def show
    @user = User.find(params[:id])

    if @user.nil?
      render json: { message: "no such user" }, status: 404
      return
    else
      render json: @user, status: :ok
    end
  end

  # POST /api/show_user
  def show_user
    if params[:username].nil?
      render json: {message: "username is empty."}, status: 400
      return
    end
    @user = User.where(username: params[:username])
    if @user.empty?
      render json: {error: "User not found" }, status: :not_found
    else
      render json: @user, status: :ok
    end
  end

  # PATCH/PUT /api/upload_avatar
  def upload_avatar
    image_params = params.permit(:image)
    if image_params[:image].nil?
      render json: { message: "image string is empty" }, status: 400
      return
    else
        content_type, encoding, string = image_params[:image].split(/[:\;\,]/)[1..3]
    end

    if image_params[:image] and (content_type.nil? or encoding.nil? or string.nil?)
      render json: { message: 'image string is invalid. valid example "data:image/png;base64,BASE64"'},
                   status: 400
    else

      if current_resource_owner.user_type =="profile"

        @profile = Profile.find_by(user_id: current_resource_owner.id)
      else
        @profile=Adminprofile.new
        @profile = Adminprofile.find_by(user_id: current_resource_owner.id)
      end

      if @profile.update(image_params)
        render json: { avatar_url: @profile.image.url }
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    end
  end

  # PUT /Api/edit_my_profile
  def edit_my_profile

   # profile_id = current_resource_owner.send(user_type + '_profile').id
   # @profile = "#{user_type}_profile".camelize.constantize.find(profile_id)
    @user = current_resource_owner
    if @user.user_type == "profile"
      @profile=Profile.new
      if @profile.update(user_profile_params)
        render json: { profile: @profile },status: 200
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    else
      @profile=Adminprofile.new
      @profile=Profile.new
      if @profile.update(admin_profile_params)
        render json: { profile: @profile },status: 200
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    end
  end

  # PUT /api/change_password
  def change_my_password
    if params[:password].nil? or params[:password_confirmation].nil?
      render json: { message: "password or password_confirmation is empty" }, status: 400
      return
    elsif params[:password] != params[:password_confirmation]
      render json: { message: "passwords doesn't match" }, status: 400
      return
    end

    @user = User.find(current_resource_owner.id)

    if @user.update(password_params)
      # NOTE: no need to revoke all tokens
      #@access_tokens = Doorkeeper::AccessToken.where(resource_owner_id:
                                                     #current_resource_owner.id)
      #@access_tokens.find_each do |token|
        #token.revoke
      #end
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PUT /v1/change_username
  def change_my_username
    if params[:username].nil?
      render json: { message: "please specify your new username." }, status: 400
      return
    end
    @user = User.find(current_resource_owner.id)
    if @user.update(username: params[:username], enabled: true) ## 1. Disable the user
      ## 2. Revoke all tokens
      @access_tokens = Doorkeeper::AccessToken.where(resource_owner_id: @user.id)
      @access_tokens.find_each do |token|
        token.revoke
      end
      ## 3. Resend sms code
      #send_sms(@user.username, generate_activation_code(@user))
      #@user.registration_code.update(sent_time: 0.second.from_now)
      ## 4. Finished!
      render json: { message: "username successfully changed!" }, status: :created
    else
      render json: { message: "unkown error" }, status: 400
    end
  end

  # POST /v1/send_new_password
  def send_new_password


    new_password = SecureRandom.hex(5)
    @user = User.find(current_resource_owner.id)
    if @user.update(password: new_password, password_confirmation: new_password)
      ## 1. Revoke all tokens
      @access_tokens = Doorkeeper::AccessToken.where(resource_owner_id: @user.id)
      @access_tokens.find_each do |token|
        token.revoke
      end

      ## 3. Send the new password via SMS
      #send_sms(@user.username, "Your Password is: #{new_password}")
      ## 4. Finished!
      render json: { message: "password is successfully sent!"+new_password }, status: :created
    else
      render json: { message: "unkown error" }, status: 400
    end
  end





  private
    def set_user
      @user = User.find_by(username: params[:username])
    end



  def user_profile_params
    params.permit([
                   :first_name,
                   :last_name,
                   :gender,
                   :national_code
                  ])
  end

  def admin_profile_params
    params.permit([
                   :first_name,
                    :last_name,
                    :national_code,
                    :gender
                  ])
  end

    def admin_profile_params
      params.permit(:last_name, :first_name, :male, :national_id )
    end

    def password_params
    params.permit(:password, :password_confirmation)
    end
end
