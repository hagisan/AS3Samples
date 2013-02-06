package com.stagecell
{
    import flash.geom.Point;

    public class IsoUtils
    {
        // 1.2247...のより高精度なバージョン
        public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) *
                                               Math.SQRT2;

        /**
         * 等角空間の3Dの点を2Dの画面の位置に変換する。
         * @arg pos 3Dの点
         */
        public static function isoToScreen(pos:Point3D):Point
        {
            var screenX:Number = pos.x - pos.z;
            var screenY:Number = pos.y * Y_CORRECT + 
                                 (pos.x + pos.z) * .5;
            return new Point(screenX, screenY);
        }

        /**
         * 2Dの画面の位置を等角空間の3Dの点に変換する。
         * y = 0と仮定している。
         * @arg point 2Dの点
         */
        public static function screenToIso(point:Point):Point3D
        {
            var xpos:Number = point.y + point.x * .5;
            var ypos:Number = 0;
            var zpos:Number = point.y - point.x * .5;
            return new Point3D(xpos, ypos, zpos);
        }
    }
}
