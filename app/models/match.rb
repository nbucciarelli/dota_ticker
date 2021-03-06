class Match < ActiveRecord::Base
  include Workflow
  attr_accessible :start_time, :workflow_state, :team1_id, :team2_id, :tournament_id
  
  belongs_to :tournament
  has_many :games

  belongs_to :team1, class_name: "Team", foreign_key: "team1_id"
  belongs_to :team2, class_name: "Team", foreign_key: "team2_id"
  
  default_scope order: 'start_time ASC'
  
  #############################################################################
  ############################# WORKFLOW STATES ###############################
  #############################################################################
  
  workflow do
    state :match_unplayed do
      event :now_playing, :transitions_to => :match_playing
    end
    state :match_playing do
      event :now_finished, :transitions_to => :match_finished
    end
    state :match_finished
  end
  
  def self.is_upcoming_or_live
    Match.where(workflow_state: [:match_unplayed, :match_playing])
  end
  
  def self.finished
    Match.where(workflow_state: :match_finished)
  end
end
