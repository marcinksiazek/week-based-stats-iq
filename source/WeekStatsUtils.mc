import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;
import Toybox.Lang;
import Toybox.UserProfile;

(:glance)
class WeekStatUtils {
  static function getCurrentWeekData() as {
    :weekNumber as Number,
    :startOfWeek as Moment,
    :endOfWeek as Moment,
  } {
    var now = Time.now();
    var today = Gregorian.info(now, Time.FORMAT_SHORT);
    var dayOfWeek = today.day_of_week - 1; // 0 = Monday, 6 = Sunday

    var startOfYear = Gregorian.moment({
      :year => today.year,
      :month => 1,
      :day => 1,
    });
    var dayOfYear =
      (now.compare(startOfYear) / Gregorian.SECONDS_PER_DAY).toNumber() + 1;

    var weekNumber = ((dayOfYear - today.day_of_week + 10) / 7).toNumber();
    var startOfWeek = now.subtract(
      new Time.Duration(dayOfWeek * Gregorian.SECONDS_PER_DAY)
    );
    var endOfWeek = startOfWeek.add(
      new Time.Duration(6 * Gregorian.SECONDS_PER_DAY)
    );

    return {
      :weekNumber => weekNumber,
      :startOfWeek => startOfWeek,
      :endOfWeek => endOfWeek,
    };
  }

  static function formatDateRange(
    startTime as Moment,
    endTime as Moment
  ) as String {
    var startDate = Gregorian.info(startTime, Time.FORMAT_SHORT);
    var endDate = Gregorian.info(endTime, Time.FORMAT_SHORT);

    return Lang.format("$1$.$2$ - $3$.$4$", [
      startDate.day.format("%02d"),
      startDate.month.format("%02d"),
      endDate.day.format("%02d"),
      endDate.month.format("%02d"),
    ]);
  }

  static function getActivityTotals(
    startDate as Moment,
    endDate as Moment
  ) as {
    :running as { :distance as Number, :count as Number },
    :swimming as { :distance as Number, :count as Number },
    :cycling as { :distance as Number, :count as Number },
  } {
    // Initialize counters for each activity type
    var stats = {
      :running => { :distance => 0, :count => 0 },
      :swimming => { :distance => 0, :count => 0 },
      :cycling => { :distance => 0, :count => 0 },
    };

    var userActivityIterator = UserProfile.getUserActivityHistory();
    var sample = userActivityIterator.next();

    while (sample != null) {
      if (
        sample.startTime.greaterThan(startDate) &&
        sample.startTime.lessThan(endDate)
      ) {
        if (sample.type == 1) {
          // Running
          stats[:running][:distance] += sample.distance;
          stats[:running][:count] += 1;
        } else if (sample.type == 2) {
          // Cycling
          stats[:cycling][:distance] += sample.distance;
          stats[:cycling][:count] += 1;
        } else if (sample.type == 5) {
          // Swimming
          stats[:swimming][:distance] += sample.distance;
          stats[:swimming][:count] += 1;
        }
      }
      sample = userActivityIterator.next();
    }

    return stats;
  }
}
