require 'rubygoal/config_definitions'
require 'rubygoal/coordinate'

module Rubygoal
  module Config
    field.width                   = 1392
    field.height                  = 934
    field.offset                  = Position.new(262, 114)
    field.goal_height             = 275
    field.close_to_goal_distance  = 275
    field.background_image_file   = File.dirname(__FILE__) + '/../../media/background.png'

    team.initial_player_positions = [
                                      [50, 466],
                                      [236, 106],
                                      [236, 286],
                                      [236, 646],
                                      [236, 826],
                                      [436, 106],
                                      [436, 286],
                                      [436, 646],
                                      [436, 826],
                                      [616, 436],
                                      [616, 496]
                                    ]
    team.average_players_count    = 7
    team.fast_players_count       = 3
    team.captain_players_count    = 1


    ball.width                    = 20
    ball.height                   = 20
    ball.image_file               = File.dirname(__FILE__) + '/../../media/ball.png'


    player.time_to_kick_again     = 60
    player.distance_control_ball  = 30
    player.kick_strength          = 20


    player.captain_home_image_file  = File.dirname(__FILE__) + '/../../media/captain_home.png'
    player.captain_away_image_file  = File.dirname(__FILE__) + '/../../media/captain_away.png'
    player.fast_home_image_file     = File.dirname(__FILE__) + '/../../media/fast_home.png'
    player.fast_away_image_file     = File.dirname(__FILE__) + '/../../media/fast_away.png'
    player.average_home_image_file  = File.dirname(__FILE__) + '/../../media/average_home.png'
    player.average_away_image_file  = File.dirname(__FILE__) + '/../../media/average_away.png'


    goal.image_file               = File.dirname(__FILE__) + '/../../media/goal.png'


    game.time                      = 120
    game.goal_image_position       = Position.new(596, 466)
    game.time_label_position       = Position.new(870, 68)
    game.score_home_label_position = Position.new(1150, 68)
    game.score_away_label_position = Position.new(1220, 68)
    game.max_name_length           = 20
    game.default_font_size         = 48
    game.team_label_font_size      = 64
    game.team_label_width          = 669
    game.home_team_label_position  = Position.new(105, 580)
    game.away_team_label_position  = Position.new(1815, 580)
  end
end
