class Report < ActiveRecord::Base
  # Use friendly_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Callbacks
  before_save { |report| report.title = report.workday.strftime('%F')}
  before_save { MarkdownWriter.update_html(self) }
  # TODO break_duration??? what the fuck? kill!!
  before_save { |report| report.break_duration = "00:00" unless report.break_duration}

  # Validations
  validates :workday, presence: true
  validates :title, uniqueness: { scope: [:user] }

  ### not needed anymore but as a reminder how to write custom validations like this :)
  # validates :worked_until, presence: true, unless: :is_a_draft?
  #   def is_a_draft?
  #     draft
  #   end

  # Pagination
  paginates_per 30

  # Relations
  belongs_to :user


  def self.by_month(month, year = Time.now.year)
    month = format('%02d', month)
    where(workday: "#{year}-#{month}-01".."#{year}-#{month}-#{Time.days_in_month(month.to_i, year)}")
  end

  def self.where_worked
    where("worked_from and worked_until")
  end


  def self.actual_workhours
    self.where_worked.map(&:worked_seconds).sum / 3600
  end

  def self.expected_workhours
    self.where_worked.count * 8 # TODO make 8h a configurable
  end

  def self.balance
    self.actual_workhours - self.expected_workhours
  end


  def worked_seconds
    return 0 if worked_from.nil? or break_duration.nil? or worked_until.nil?
    worked_until - worked_from - break_duration.seconds_since_midnight
  end


  # Scopes
  scope :published, lambda {
    where(draft: false)
    .order("workday DESC")
  }

  scope :drafted, lambda {
    where(draft: true)
    .order("workday DESC")
  }

end
