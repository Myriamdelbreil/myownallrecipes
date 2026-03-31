module TimeHelper
  def minutes_to_hours_and_minutes(time)
    time < 60 ? "#{time} min" : Time.at(time).utc.strftime("%Hh%M").sub(/^0h/, '')
  end
end
