require 'test_helper'

class UserInterfaceTest < Minitest::Test
  def test_menu_contains_parts
    mm = LanguageCards::UserInterface.new.main_menu(courses: ["Japanese"])
    assert (/#{I18n.t('Menu.Title')}/ === mm)
    assert (/1: Japanese/ === mm)
    assert (/#{I18n.t('Menu.Exit')}/ === mm)
  end

  def test_game_contains_parts
    sm = LanguageCards::UserInterface.new.score_menu(correct: 1, incorrect: 2)
    assert (/#{I18n.t('Game.ScoreMenu.Score')}/ === sm)
    assert (/#{I18n.t('Game.ScoreMenu.OutOf')}/ === sm)
    assert (/#{I18n.t('Menu.Exit')}/ === sm)
  end

  def test_clear_terminal_code_is_correct
    assert_equal "\e[3J\e[H\e[2J", LanguageCards::ESC::CLEAR
  end
end
