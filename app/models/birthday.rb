class Birthday < ActiveRecord::Base

  # 100歳まで調べる
  MAX_AGE = 100

  STEP_1000_DAYS = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 20000, 21000, 22000, 23000, 24000, 25000, 26000, 27000, 28000, 29000, 30000, 31000, 32000, 33000, 34000, 35000, 36000]

  ZOROME_DAYS = [111, 222, 333, 444, 555, 666, 777, 888, 999, 1111, 2222, 3333, 4444, 5555, 6666, 7777, 8888, 9999, 11111, 22222, 33333]

  OTHER_NUMBERS = [100, 123, 1234, 12345]

  GOOD_DAYS = ( STEP_1000_DAYS + ZOROME_DAYS + OTHER_NUMBERS ).uniq.sort

  validates_presence_of :nickname, :birthday, :uuid
  validates_uniqueness_of :nickname, :scope => [:birthday]

  before_validation(:on => :create) do
    self.uuid = Forgery::Basic.text :at_least => 6, :at_most => 6
  end

  def find_same
    self.class.where(:nickname => self.nickname, :birthday => (self.birthday.beginning_of_day)..(self.birthday.end_of_day) ).first
  rescue
    nil
  end
  
  def self.match(nickname, birthday)
    logger.info 'aaaa'
    logger.info nickname
    logger.info birthday
    #birthday = Date.parse(birthday) if birthday.kind_of?(String)
    nil
  end

  # 生まれてから何日間か返す
  def current_days
    @current_days ||= ((self.birthday.to_date)..(Date.today)).count
  end
  
  def current_age
    current_days / 365
  end
  
  def birthday?
    self.birthday.to_date == Date.today
  end
  
  # 今日はHappyDayかチェックする
  def happy_day_today?
    @is_happy_day_today ||= GOOD_DAYS.include?(self.current_days)
  end

  def current_happy_day
    self.happy_days.select do |n|
      n[:days] == self.current_days
    end.first
  end

  def next_happy_day
    @next_happy_day ||= self.future_happy_days.first
  end

  def past_happy_days
    @past_happy_days ||= self.happy_days.select {|n| n[:days] < self.current_days}
  end

  def future_happy_days
    @future_happy_days ||= self.happy_days.select {|n| n[:days] > self.current_days}
  end
  
  def prev_happy_day
    @prev_happy_day ||= self.past_happy_days.last
  end
  
  def happy_days
    unless instance_variable_defined?(:@happy_days)
      @happy_days = []
      GOOD_DAYS.each do |n|
        date = n.days.since(self.birthday)
        happy_day = {
          :date => date,
          :age => n / 365,
          :days => n,
        }
        @happy_days << happy_day
      end
    end
    @happy_days
  end
  
  def to_param
    uuid
  end
  
end
