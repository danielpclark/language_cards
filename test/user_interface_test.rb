require 'test_helper'

class UserInterfaceTest < Minitest::Test
  def test_menu_contains_parts
    mm = LanguageCards::Controllers::MainMenu.render(
      courses: ["Japanese"],
      mode: [:translate].cycle
    )
    assert (/#{I18n.t('Menu.Title')}/ === mm)
    assert (/1: Japanese/ === mm)
    assert (/#{I18n.t('Menu.Exit')}/ === mm)
  end

  def test_game_contains_parts
    sm = LanguageCards::Controllers::Game.render(
      correct: 1,
      incorrect: 2,
      title: 'Hiragana',
      timer: LanguageCards::Timer.new,
      last: nil
    )
    assert (/#{I18n.t('Game.ScoreMenu.Score')}/ === sm)
    assert (/#{I18n.t('Menu.Exit')}/ === sm)
  end

  def test_clear_terminal_code_is_correct
    assert_equal "\e[3J\e[H\e[2J", LanguageCards::ESC::CLEAR
  end

  def test_main_menu_in_application_load
    cmd = "SKIP_FLASH=1 #{File.expand_path('../bin/language_cards', __dir__)}"
    result = sys_exec(cmd){|i,*| i.puts "1"; i.puts "wa"}
    assert_match(I18n.t('Menu.Title'), result)
    assert_match(LanguageCards::VERSION, result)
    assert_match(I18n.t('LanguageName.Japanese'), result)
    assert_match(I18n.t('Game.ScoreMenu.Score'), result)
    assert_match(I18n.t('Timer.Timer'), result)
    assert_match(I18n.t('Timer.AverageSeconds'), result)
    assert_match(/00:00:00/, result)
    assert_match(I18n.t('Menu.Exit'), result)
    assert_match(LanguageCards::ESC::CLEAR, result)
  end unless Gem.win_platform?
end
