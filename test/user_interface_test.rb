require 'test_helper'

class UserInterfaceTest < Minitest::Test
  def test_menu_contains_parts
    mm = LanguageCards::Controllers::MainMenu.new.render(
      courses: ["Japanese"],
      mode: [:translate].cycle
    )
    assert (/#{I18n.t('Menu.Title')}/ === mm)
    assert (/1: Japanese/ === mm)
    assert (/#{I18n.t('Menu.Exit')}/ === mm)
    refute_match(/#{I18n.t('Menu.NextPage')}/, mm)
    refute_match(/#{I18n.t('Menu.Back')}/, mm)
  end

  def test_menu_pagination_parts
    pages = LanguageCards::Paginator.new(('a'..'z').to_a, 10).next_page
    mm = LanguageCards::Controllers::MainMenu.new.render(
      courses: pages.current.map(&:last),
      offset: pages.offset,
      mode: [:typing_practice].cycle,
      heading: 'Letters',
      pages: pages,
      back: true
    )
    assert_match(/Letters/, mm)
    assert_match(/11: k/, mm)
    assert_match(/20: t/, mm)
    refute_match(/21: u/, mm)
    assert_match(I18n.t('Menu.Page', page: 2, pages: 3), mm)
    assert_match(/n: #{I18n.t('Menu.NextPage')}/, mm)
    assert_match(/p: #{I18n.t('Menu.PreviousPage')}/, mm)
    assert_match(/b: #{I18n.t('Menu.Back')}/, mm)
    assert_match(I18n.t('Menu.ModeTyping'), mm)
  end

  def test_game_contains_parts
    sm = LanguageCards::Controllers::Game.new.render(
      correct: 1,
      incorrect: 2,
      title: 'Hiragana',
      timer: LanguageCards::Timer.new,
      last: nil
    )
    assert (/#{I18n.t('Game.ScoreMenu.Score')}/ === sm)
    assert (/#{I18n.t('Game.Exit')}/ === sm)
  end

  def test_clear_terminal_code_is_correct
    assert_equal "\e[3J\e[H\e[2J", LanguageCards::ESC::CLEAR
  end

  def test_main_menu_in_application_load
    japanese = Support.language_number('Japanese')
    cmd = "SKIP_SPLASH=1 #{File.expand_path('../bin/language_cards', __dir__)}"
    result = sys_exec(cmd){|i,*| i.puts japanese; i.puts "1"; i.puts "wa"}
    assert_match(I18n.t('Menu.Title'), result)
    assert_match(LanguageCards::VERSION, result)
    assert_match(I18n.t('Menu.ChooseLanguage'), result)
    assert_match(I18n.t('LanguageName.Japanese'), result)
    assert_match(I18n.t('Menu.ChooseCardSet'), result)
    assert_match(I18n.t('LanguageName.Hiragana'), result)
    assert_match(I18n.t('Game.ScoreMenu.Score'), result)
    assert_match(I18n.t('Timer.Timer'), result)
    assert_match(I18n.t('Timer.AverageSeconds'), result)
    assert_match(/00:00:00/, result)
    assert_match(I18n.t('Menu.Exit'), result)
    assert_match(LanguageCards::ESC::CLEAR, result)
    assert_equal 0, @exitstatus
    assert_empty err
  end unless Gem.win_platform?

  def test_menu_navigation_commands
    japanese = Support.language_number('Japanese')
    cmd = "SKIP_SPLASH=1 #{File.expand_path('../bin/language_cards', __dir__)}"
    result = sys_exec(cmd){|i,*| %W[#{japanese} n p m b q].each {|c| i.puts c } }
    assert_match(I18n.t('Menu.Page', page: 2, pages: 3), result)
    assert_match(I18n.t('Menu.ModeTyping'), result)
    assert_equal 0, @exitstatus
    assert_empty err
  end unless Gem.win_platform?

  def test_version_flag
    result = sys_exec("#{File.expand_path('../bin/language_cards', __dir__)} --version")
    assert_equal LanguageCards::VERSION, result
  end unless Gem.win_platform?
end
