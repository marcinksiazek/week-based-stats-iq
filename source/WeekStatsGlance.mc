using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
import Toybox.System;

(:glance)
class WeekStatsGlance extends Ui.GlanceView {
  function initialize() {
    GlanceView.initialize();
  }

  function onUpdate(dc) {
    var weekData = WeekStatUtils.getCurrentWeekData();
    var activityTotals = WeekStatUtils.getActivityTotals(
      weekData[:startOfWeek],
      weekData[:endOfWeek]
    );
    var adjustedDistances = WeekStatUtils.adjustActivityDistances(activityTotals);

    // Draw week number text
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    dc.drawText(
      10,
      5,
      Gfx.FONT_SMALL,
      "Week " + weekData[:weekNumber].format("%d"),
      Gfx.TEXT_JUSTIFY_LEFT
    );

    // Calculate total adjusted distance for proportions
    var totalAdjustedDistance = 
        adjustedDistances[:running][:distance] + 
        adjustedDistances[:swimming][:distance] + 
        adjustedDistances[:cycling][:distance];
    
    // Calculate bar dimensions
    var maxBarWidth = dc.getWidth() - 40;
    var distanceBarY = dc.getHeight() / 2 - 1;
    var distanceBarHeight = 3;
    var spacing = 2;

    // Calculate proportional widths
    var runWidth = totalAdjustedDistance > 0 ? 
        (maxBarWidth * adjustedDistances[:running][:distance] / totalAdjustedDistance).toNumber() : 0;
    var swimWidth = totalAdjustedDistance > 0 ? 
        (maxBarWidth * adjustedDistances[:swimming][:distance] / totalAdjustedDistance).toNumber() : 0;
    var bikeWidth = totalAdjustedDistance > 0 ? 
        (maxBarWidth * adjustedDistances[:cycling][:distance] / totalAdjustedDistance).toNumber() : 0;

    // Draw activity distance bars
    var xOffset = 10;
    
    dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
    dc.fillRectangle(xOffset, distanceBarY, runWidth, distanceBarHeight);
    xOffset += runWidth + spacing;

    dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLUE);
    dc.fillRectangle(xOffset, distanceBarY, swimWidth, distanceBarHeight);
    xOffset += swimWidth + spacing;

    dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
    dc.fillRectangle(xOffset, distanceBarY, bikeWidth, distanceBarHeight);

    // Draw combined activity distances
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    var bottomY = dc.getHeight() - 60;

    var combinedText = Lang.format("$1$km $2$m $3$km", [
      (activityTotals[:running][:distance] / 1000.0).format("%.1f"),
      activityTotals[:swimming][:distance].format("%.0f"),
      (activityTotals[:cycling][:distance] / 1000.0).format("%.1f"),
    ]);

    dc.drawText(
      dc.getWidth() / 2,
      bottomY,
      Gfx.FONT_XTINY,
      combinedText,
      Gfx.TEXT_JUSTIFY_CENTER
    );
  }
}
