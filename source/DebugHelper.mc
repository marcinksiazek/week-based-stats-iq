import Toybox.Lang;
import Toybox.Cryptography;

(:glance)
 class DebugHelper
{
    (:debug) static function generateRandomNumber(range as Number) as Number {
        var randomBytes = Cryptography.randomBytes(1);
        var random = randomBytes[0];
        // Convert the byte to an integer between 1 and 10
        var distance = (random % range) + 1;
        return distance;
    }
    (:debug) static function generateRandomRunDistance() as Number {
        return generateRandomNumber(50) * 1000 + generateRandomNumber(9) * 100;
    }
    (:debug) static function generateRandomRunCount() as Number {
        return generateRandomNumber(5);
    }
    (:debug) static function generateRandomSwimDistance() as Number {
        return generateRandomNumber(9) * 1000 + generateRandomNumber(9) * 50;
    }
    (:debug) static function generateRandomSwimCount() as Number {
        return generateRandomNumber(6);
    }
    (:debug) static function generateRandomBikeDistance() as Number {
        return generateRandomNumber(110) * 1000 + generateRandomNumber(9) * 100;
    }
    (:debug) static function generateRandomBikeCount() as Number {
        return generateRandomNumber(4);
    }
}