import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.UserProfile;
import Toybox.Time;

class MainView extends WatchUi.View {
  function initialize() {
    View.initialize();
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.MainLayout(dc));
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    var weekNumberLabel = findDrawableById("id_week_number") as WatchUi.Text;
    var weekDateLabel = findDrawableById("id_week_date") as WatchUi.Text;
    var runLabel = findDrawableById("id_run_stats") as WatchUi.Text;
    var swimLabel = findDrawableById("id_swim_stats") as WatchUi.Text;
    var bikeLabel = findDrawableById("id_bike_stats") as WatchUi.Text;

    var weekData = WeekStatUtils.getCurrentWeekData();

    weekNumberLabel.setText("Week " + weekData[:weekNumber].format("%d"));
    weekDateLabel.setText(
      WeekStatUtils.formatDateRange(
        weekData[:startOfWeek],
        weekData[:endOfWeek]
      )
    );

    var activityTotals = WeekStatUtils.getActivityTotals(
      weekData[:startOfWeek],
      weekData[:endOfWeek]
    );

    runLabel.setText(
      Lang.format("Running\n$1$ km $2$ activities", [
        (activityTotals[:running][:distance] / 1000.0).format("%.1f"),
        activityTotals[:running][:count],
      ])
    );

    swimLabel.setText(
      Lang.format("Swimming\n$1$ m $2$ activities", [
        activityTotals[:swimming][:distance].format("%.0f"),
        activityTotals[:swimming][:count],
      ])
    );

    bikeLabel.setText(
      Lang.format("Cycling\n$1$ km $2$ activities", [
        (activityTotals[:cycling][:distance] / 1000.0).format("%.1f"),
        activityTotals[:cycling][:count],
      ])
    );
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}
}
