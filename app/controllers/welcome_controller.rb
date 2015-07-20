class WelcomeController < ApplicationController

  after_action :allow_iframe, only: :index

  def index
    day = Date::DAYNAMES[Date.new.day].downcase
    schedule = YAML.load_file("#{Rails.root.to_s}/config/schedule.yml")
    day_schedule = schedule[day] || schedule['thursday']
    @now = false
    if day_schedule
      now = Time.now.getutc.to_i
      day_schedule.each do |time, v|
        next if now > time
        if @now == false
          @now = v
        else
          @next = v
          break
        end
      end
    else
      @now = 'nothing'
      @next = 'nothing'
    end
  end

  private
    def allow_iframe
      response.headers['X-Frame-Options'] = 'ALLOWALL'
    end
end
