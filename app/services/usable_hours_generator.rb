class UsableHoursGenerator
  Result = Struct.new(:success?, :error)

  def self.call(common_space, params)
    new(common_space, params).call
  end

  def initialize(common_space, params)
    @common_space = common_space
    @days = Array(params[:days_of_week]).map(&:to_i)
    @start_time = params[:start_time]
    @end_time = params[:end_time]
  end

  def call
    return Result.new(false, "Debe seleccionar al menos un día") if @days.empty?
    return Result.new(false, "La hora de fin debe ser mayor a la de inicio") if invalid_time_range?

    generate_hours

    Result.new(true, nil)
  end

  private

  def invalid_time_range?
    @start_time >= @end_time
  end

  def generate_hours
    today = Date.today
    last_day = today.end_of_month

    (today..last_day).each do |date|
      weekday = convert_to_monday_first(date.wday)
      next unless @days.include?(weekday)

      generate_daily_slots(date)
    end
  end

  def generate_daily_slots(date)
    start_hour = @start_time.to_i
    end_hour = @end_time.to_i

    (start_hour...end_hour).each do |hour|
      start_dt = DateTime.new(date.year, date.month, date.day, hour, 0, 0)
      end_dt   = start_dt + 1.hour

      next if duplicate_slot?(start_dt, end_dt)

      @common_space.usable_hours.create!(
        start: start_dt,
        end: end_dt,
        is_available: true
      )
    end
  end

  def duplicate_slot?(start_dt, end_dt)
    @common_space.usable_hours.exists?(start: start_dt, end: end_dt)
  end

  # Ruby wday → L=1 ... D=7
  def convert_to_monday_first(wday)
    wday = 7 if wday == 0
    wday
  end
end
