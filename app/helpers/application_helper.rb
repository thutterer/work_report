module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | WorkReport"
    end
  end
end
