class Report < ActiveRecord::Base
  # Use friendly_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Callbacks
  before_validation { |report| report.title = report.workday.strftime('%F')}
  before_save { MarkdownWriter.update_html(self) }
  before_save { |report| report.break_duration = "00:00" unless report.break_duration}
  before_save { |report| report.update_worktime}

  # FIXME: these callbacks create a lot of calculations
  # TODO:  only add the worktime difference to the current overtime value
  after_create { |report| report.user.update(overtime: report.user.reports.sum(:worktime)) }
  after_save   { |report| report.user.update(overtime: report.user.reports.sum(:worktime)) }

  # Validations
  validates :title, presence: true
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

  def worked_seconds
    return 0 if worked_from.nil? or break_duration.nil? or worked_until.nil?
    worked_until - worked_from - break_duration.seconds_since_midnight
  end

  def update_worktime
    worktime = (if worked_from.nil? or break_duration.nil? or worked_until.nil? then 0
                else worked_until - worked_from - break_duration.seconds_since_midnight
                end)
    write_attribute(:worktime, worktime)
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
