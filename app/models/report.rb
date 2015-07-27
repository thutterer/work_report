class Report < ActiveRecord::Base
  # Use friendly_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Callbacks
  before_save { MarkdownWriter.update_html(self) }
  before_save { |report| report.title = report.workday.strftime('%F')}

  # Validations
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :content_md, presence: true

  validates :worked_until, presence: true, unless: :is_a_draft?
    def is_a_draft?
      draft
    end

  # Pagination
  paginates_per 30

  # Relations
  belongs_to :user

  def self.by_month(month, year = Time.now.year)
    month = format('%02d', month)
    where(workday: "#{year}-#{month}-01".."#{year}-#{month}-#{Time.days_in_month(month.to_i, year)}")
  end

  def worked_seconds
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
