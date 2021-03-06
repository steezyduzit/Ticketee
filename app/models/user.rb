class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :roles
  scope :excluding_archived, -> { where(archived_at: nil) }

  def to_s
    "#{email} (#{admin? ? 'Admin' : 'User'})"
  end

  def archive
    update(archived_at: Time.current)
  end

  def active_for_authentication?
    super && archived_at.nil?
  end

  def inactive_message
    archived_at.nil? ? super : :archived
  end

  def role_on(project)
    roles.find_by(project_id: project).try(:name)
  end

  def generate_api_key
    self.update_column(:api_key, SecureRandom.hex(16))
  end
end
