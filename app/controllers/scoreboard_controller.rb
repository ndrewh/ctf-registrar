class ScoreboardController < ApplicationController
  before_filter :require_on_team
  before_filter :require_during_game, except: :index

  def index
    @leaderboard = Team.for_scoreboard current_team
    @categories = Category.for_scoreboard
    @challenges = Challenge.for_scoreboard current_team

    respond_to do |f|
      f.html
      f.json {
        render json: {
          leaderboard: @leaderboard,
          challenges: @challenges
        }
      }
    end
  end

  def challenge
    @challenge = Challenge.find params[:id]
    @solution = current_team.solution_for @challenge

    return redirect_to scoreboard_path if @challenge.locked?

    respond_to do |f|
      f.html
      f.json { render json: {category: @challenge.category, challenge: @challenge, solution: @solution} }
    end
  end

  def answer
    @challenge = Challenge.find params[:id]
    @solution = current_team.solution_for @challenge

    sticky_situation = @challenge.locked? || @solution.created_at
    correct = @challenge.correct_answer?(params[:answer]) rescue false

    logbuf = [
      "ANSWER ATTEMPT", 
      current_team.inspect, 
      current_user.inspect,
      @challenge.inspect,
      params[:answer]
    ]

    if sticky_situation
      logbuf << 'STICKY SITUATION'
    elsif !correct
      logbuf << "WRONG ANSWER"
    end

    if sticky_situation || !correct
      Rails.logger.info logbuf.join(' ')
      return respond_to do |f|
        f.html { redirect_to challenge_path(@challenge.id) }
        f.json { render status: 400, json: {
          error: "Now that's what I call a sticky situation.",
          wrong: !correct,
          weird: sticky_situation
         }}
      end
    end

    logbuf << "RIGHT ANSWER"

    hot = nil
    @solution.transaction do
      hot = @challenge.solve!
      @solution.save
      if hot
        logbuf << "OMG HOT"
        current_team.hot = true
        current_team.save

        n = Notice.new
        n.body = "#{current_team.name} solved #{@challenge.name} [#{@challenge.category.name}] for #{@challenge.points} points."
        n.save
      else
        n = Notice.new
        n.body = "Your teammate #{current_user.username} solved #{@challenge.name} [#{@challenge.category.name}] for #{@challenge.points} points."
        n.team = current_team
        n.save
      end
    end

    respond_to do |f|
      f.html {
        return redirect_to choice_path if hot
        return redirect_to scoreboard_path
      }  

      f.json {
        render status: 200, json: {
          woot: 'you got it',
          hot: hot
        }
      }
    end

      Rails.logger.info logbuf.join(' ')
  end

  private
  def solution
    current_team
  end
end
