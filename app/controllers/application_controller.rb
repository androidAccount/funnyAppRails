class ApplicationController < ActionController::Base

 respond_to :json


  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers


  def route_not_found
    render status: :not_found, json: '{"message":"there is Nothing there"}'
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render text: '', content_type: 'text/plain'
    end
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end
  
  def doorkeeper_unauthorized_render_options(error: nil)
      { json: { message: "Not authorized" }, status: 401 }
  end

  private
    #get current user that might be profile user or admin user
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
    #use this method to check whether the user is enabled or not
    def check_user_enabled
      if not current_resource_owner.nil? and not current_resource_owner.try(:enabled?)
        render json: { message: "User is disabled." }, status: 403
      end
    end

    def current_user_is_admin?
      current_resource_owner.try(:admin?)
    end
    #use this method to authenticate admin user in each controller
    def admin_authorize!
      unless current_resource_owner.admin
        render json: { message: "Not authorized for this action, admin only" }, status: 401
      end
    end
    #use this method to authenticate profile user in each controller
    def profile_authorize!
      unless current_resource_owner.user_type == "profile"
        render json: { message: "Not authorized for this action" }, status: 401
      end
    end


   #generate and store activition code in Registion_code table in database
    def generate_activation_code(user)
      if user.registration_code.nil?
        sms_code = create_random_code(4, RegistrationCode.all.pluck(:sms_code))
        RegistrationCode.create(user_id: user.id, sms_code: sms_code,
                                sent_time: 0.second.from_now)
        return sms_code
      elsif user.registration_code.expired?
        sms_code = create_random_code(4, RegistrationCode.all.pluck(:sms_code))
        user.registration_code.update(sms_code: sms_code)
        return sms_code
      else
        return user.registration_code.sms_code
      end
    end

    def create_random_code(length, codes)
      code = SecureRandom.hex(length/2)
      while codes.include? code
        code = SecureRandom.hex(length/2)
      end
      return code
    end

# use this method to send sms
  def send_sms(phone_number, data)
    logger.info "################ Data: #{data} ########################"
    logger.info "############### Phone: #{phone_number} ################"
    header = { "Content-Type" =>  "text/xml;charset=UTF-8"}
   
    logger.info "Start to set url varaible"
    url = "http://www.0098sms.com/sendsmslink.aspx?FROM=*****&TO=#{phone_number}&TEXT=#{data}&USERNAME=****&PASSWORD=***&DOMAIN=0098"
    logger.info "Start to parse URL"
    endcoded_url=URI.encode(url)
    uri = URI.parse(endcoded_url)

    logger.info "parsed well"
    http = Net::HTTP.new(uri.host, uri.port)
    logger.info "Net::HTTP started good"
    http.use_ssl = false
    question = Net::HTTP::Get.new(uri.request_uri)
   
    logger.info "Question get new instance of GET"
    question.initialize_http_header(header)
    logger.info "Question initialized http header"

    answer = http.request(question)
    logger.info "http Request sent to server"
    logger.info "################ response to #{phone_number}: #{answer.body} ########################"
  end
    def create_time_slots(start_time, end_time)
      start_time = start_time.in_time_zone("Tehran").round_off(15.minutes)
      end_time = end_time.in_time_zone("Tehran").round_off(15.minutes).to
     
      time_slots = []
      RailsDateRange(start_time..end_time).every(minutes: 15).each {|t| time_slots << t.strftime("%H%M")}

      return time_slots
    end

    def meta_attributes(resource, extra_meta = {})
      {
        current_page: resource.current_page,
        next_page: resource.next_page,
        prev_page: resource.prev_page,
        total_pages: resource.total_pages,
        total_count: resource.total_count
      }.merge(extra_meta)
    end

end
