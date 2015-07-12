module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | WorkReport"
    end
  end

  def secs_to_time(total_seconds)
    #http://stackoverflow.com/a/9916691
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)
    format("%02d:%02d:%02d", hours, minutes, seconds)
  end
end
