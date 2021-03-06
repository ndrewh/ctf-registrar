class Solution < ActiveRecord::Base
  belongs_to :team
  belongs_to :challenge

  validates :team_id, uniqueness: {scope: :challenge_id}

  attr_accessor :answer

  after_create :publish!

  def as_redis
    {
      team: team.as_redis,
      challenge: challenge.as_json({  }),
      category: challenge.category.as_json
    }
  end

  def observation
    Observation.find_by(team_id: team_id, challenge_id: challenge_id)
  end

  private

  def publish!
    REDIS.publish 'solution', as_redis.to_json rescue true
  end
end
