$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'open3'
require 'language_cards'
require 'minitest/autorun'
require 'support'

class Minitest::Test
  include Support
  attr_reader :out, :err
  def sys_exec(cmd)
    Open3.popen3(cmd.to_s) do |stdin, stdout, stderr, wait_thr|
      yield stdin, stdout, wait_thr if block_given?
      stdin.close

      @exitstatus = wait_thr && wait_thr.value.exitstatus
      @out = Thread.new { stdout.read }.value.strip
      @err = Thread.new { stderr.read }.value.strip
    end

    (@all_output ||= String.new) << [
      "$ #{cmd.to_s.strip}",
      out,
      err,
      @exitstatus ? "# $? => #{@exitstatus}" : "",
      "\n",
    ].reject(&:empty?).join("\n")

    @out
  end
end
