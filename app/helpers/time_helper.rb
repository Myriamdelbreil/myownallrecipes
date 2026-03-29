module TimeHelper
  def minutes_to_hours_and_minutes(time)
    if time < 60
      "#{time} min"
    else
      Time.at(time * 60).utc.strftime("%Hh%M").sub(/^0h/, '')
    end
  end
end
