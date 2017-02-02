
module LanguageCards
  class Timer
    def initialize
      @stamps = []
      @mark = nil
    end

    def mark
      if @mark
        @stamps << -(@mark - (@mark = Time.now))
      else
        @mark = Time.now
      end
    end

    def time?
      !times.empty?
    end

    def h # human
      "%02d:%02d:%02d" % [total/3600%24, total/60%60, total%60]
    end

    def average
      total.fdiv(times.size)
    end

    def ha # human average
      "%0.2f #{I18n.t('Timer.AverageSeconds')}" % average rescue ""
    end

    def times
      @stamps
    end

    def last
      @stamps.last
    end

    def total
      @stamps.inject(:+) || 0
    end
  end
end
