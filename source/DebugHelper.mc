import Toybox.Lang;
import Toybox.Cryptography;

(:glance)
class DebugHelper {
  static function generateRandomNumber(range as Number) as Number {
    var randomBytes = Cryptography.randomBytes(1);
    var random = randomBytes[0];
    // Convert the byte to an integer between 1 and 10
    var distance = (random % range) + 1;
    return distance;
  }
  static function generateRandomRunDistance() as Number {
    return generateRandomNumber(50) * 1000 + generateRandomNumber(9) * 100;
  }
  static function generateRandomRunCount() as Number {
    return generateRandomNumber(5);
  }
  static function generateRandomSwimDistance() as Number {
    return generateRandomNumber(9) * 1000 + generateRandomNumber(9) * 50;
  }
  static function generateRandomSwimCount() as Number {
    return generateRandomNumber(6);
  }
  static function generateRandomBikeDistance() as Number {
    return generateRandomNumber(110) * 1000 + generateRandomNumber(9) * 100;
  }
  static function generateRandomBikeCount() as Number {
    return generateRandomNumber(4);
  }

  (:release)
  static function mockTotals(stats) {}

  (:debug)
  static function mockTotals(stats) {
    stats[:swimming][:distance] += DebugHelper.generateRandomSwimDistance();
    stats[:swimming][:count] += DebugHelper.generateRandomSwimCount();
    stats[:running][:distance] += DebugHelper.generateRandomRunDistance();
    stats[:running][:count] += DebugHelper.generateRandomRunCount();
    stats[:cycling][:distance] += DebugHelper.generateRandomBikeDistance();
    stats[:cycling][:count] += DebugHelper.generateRandomBikeCount();

    return stats;
  }
}
