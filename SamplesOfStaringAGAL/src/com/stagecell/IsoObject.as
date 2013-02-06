package com.stagecell
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class IsoObject extends Sprite
    {
        protected var _position:Point3D;
        protected var _size:Number;
        protected var _walkable:Boolean = false;
        protected var _vx:Number = 0;
        protected var _vy:Number = 0;
        protected var _vz:Number = 0;

        // 1.2247...のより正確なバージョン
        public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) *
                                               Math.SQRT2;

        public function IsoObject(size:Number)
        {
            _size = size;
            _position = new Point3D();
            updateScreenPosition();
        }

        /**
         * 現在の3Dの位置を画面の位置に変換し、
         * そこに本表示オブジェクトを移動する。
         */
        protected function updateScreenPosition():void
        {
            var screenPos:Point = IsoUtils.isoToScreen(_position);
            super.x = screenPos.x;
            super.y = screenPos.y;
        }

        /**
         * 本オブジェクトの文字列表現
         */
        override public function toString():String
        {
            return "[IsoObject (x:" + _position.x + ", y:" +
                   _position.y + ", z:" + _position.z + ")]";
        }

        /**
         * 3D空間上のX座標を設定／取得する。
         */
        override public function set x(value:Number):void
        {
            _position.x = value;
            updateScreenPosition();
        }
        override public function get x():Number
        {
            return _position.x;
        }

        /**
         * 3D空間上のY座標を設定／取得する。
         */
        override public function set y(value:Number):void
        {
            _position.y = value;
            updateScreenPosition();
        }
        override public function get y():Number
        {
            return _position.y;
        }

        /**
         * 3D空間上のZ座標を設定／取得する。
         */
        override public function set z(value:Number):void
        {
            _position.z = value;
            updateScreenPosition();
        }
        override public function get z():Number
        {
            return _position.z;
        }

        /**
         * 3D空間上の位置をPoint3Dとして設定／取得する。
         */
        public function set position(value:Point3D):void
        {
            _position = value;
            updateScreenPosition();
        }
        public function get position():Point3D
        {
            return _position;
        }

        /**
         * 本オブジェクトの変換された3Dの奥行きを返す。
         */
        public function get depth():Number
        {
            return (_position.x + _position.z) * .866 - 
                    _position.y * .707;
        }

        /**
         * 本オブジェクトの占める空間が他のオブジェクトにより
         * 占有できるかどうかを設定／取得する。
         */
        public function set walkable(value:Boolean):void
        {
            _walkable = value;
        }
        public function get walkable():Boolean
        {
            return _walkable;
        }

        /**
         * 本オブジェクトの大きさを返す。
         */
        public function get size():Number
        {
            return _size;
        }

        /**
         * 本オブジェクトの占めるX-Z平面上の正方形領域
         *を返す。
         */
        public function get rect():Rectangle
        {
            return new Rectangle(x - size / 2, z - size / 2, 
                                 size, size);
        }
        /**
         * X軸方向の速度を設定／取得する。
         */
        public function set vx(value:Number):void
        {
            _vx = value;
        }
        public function get vx():Number
        {
            return _vx;
        }
        
        /**
         * Y軸方向の速度を設定／取得する。
         */
        public function set vy(value:Number):void
        {
            _vy = value;
        }
        public function get vy():Number
        {
            return _vy;
        }
        
        /**
         * Z軸方向の速度を設定／取得する。
         */
        public function set vz(value:Number):void
        {
            _vz = value;
        }
        public function get vz():Number
        {
            return _vz;
        }
    }
}
