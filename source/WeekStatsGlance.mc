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

        // Draw week number text
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            10,
            5,
            Gfx.FONT_SMALL,
            "Week " + weekData[:weekNumber].format("%d"),
            Gfx.TEXT_JUSTIFY_LEFT
        );

        // Draw activity distance bars
        var distanceBarWidth = (dc.getWidth() - 40) / 3;
        var distanceBarY = dc.getHeight() / 2 - 1;
        var distanceBarHeight = 3;

        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
        dc.fillRectangle(
            10,
            distanceBarY,
            distanceBarWidth,
            distanceBarHeight
        );

        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLUE);
        dc.fillRectangle(
            10 + distanceBarWidth + 5,
            distanceBarY,
            distanceBarWidth,
            distanceBarHeight
        );

        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
        dc.fillRectangle(
            10 + (distanceBarWidth + 5) * 2,
            distanceBarY,
            distanceBarWidth,
            distanceBarHeight
        );

        // Draw combined activity distances
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var bottomY = dc.getHeight() - 60;

        var combinedText = Lang.format("$1$km $2$m $3$km", [
            (activityTotals[:running][:distance]/1000.0).format("%.1f"),
            activityTotals[:swimming][:distance].format("%.0f"),
            (activityTotals[:cycling][:distance]/1000.0).format("%.1f")
        ]);

        dc.drawText(
            dc.getWidth()/2,
            bottomY,
            Gfx.FONT_XTINY,
            combinedText,
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }
}