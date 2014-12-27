module CalendarHelper
  def calendarbuild(test_data, date = Date.today, &block)
    @date = date
    Calendarbuild.new(self, date, block, test_data).table
  end

  class Calendarbuild < Struct.new(:view, :date, :callback, :test_data)
    HEADER = %w[Понедельник Вторник Среда Четверг Пятница Суббота Воскресенье]
    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "noday" if day < date
      classes << "empty" if test_data[day.to_s] && test_data[day.to_s].size == 0
      classes << "low" if test_data[day.to_s] && (1..2).include?(test_data[day.to_s].size)
      classes << "medium" if test_data[day.to_s] && test_data[day.to_s].size == 3
      classes << "hi" if test_data[day.to_s] && test_data[day.to_s].size > 3
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_week(START_DAY)
      last = date.next_day(31).end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end
