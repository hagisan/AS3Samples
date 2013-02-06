package com.stagecell
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.getDefinitionByName;

    public class MapLoader extends EventDispatcher
    {
        private var _grid:Array;
        private var _loader:URLLoader;
        private var _tileTypes:Object;

        public function MapLoader()
        {
            _tileTypes = new Object();
        }

        /**
         * 指定したURLからテキストファイルを読み込む。
         * @param url 読み込むテキストファイルの場所
         */
        public function loadMap(url:String):void
        {
            _loader = new URLLoader();
            _loader.addEventListener(Event.COMPLETE, onLoad);
            _loader.load(new URLRequest(url));
        }

        /**
         * テキストファイルを解釈してタイル定義とタイルマップに格納する
         */
        private function onLoad(event:Event):void
        {
            _grid = new Array();
            var data:String = _loader.data;

            // まずファイルを1行ずつ取得する。
            var lines:Array = data.split("\n");
            for (var i:int = 0; i < lines.length; i++)
            {
                var line:String = lines[i];

                // タイルタイプ定義の行の場合
                if (isDefinition(line))
                {
                    parseDefinition(line);
                }
                // そうでなく、空行でもコメント行でもなければ、
                // タイルタイプのリストであるから、格子に追加する。
                else if (!lineIsEmpty(line) && !isComment(line))
                {
                    var cells:Array = line.split(" ");
                    _grid.push(cells);
                }
            }
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function parseDefinition(line:String):void
        {
            // 行をトークンに分割する。
            var tokens:Array = line.split(" ");

            // #を取り除く
            tokens.shift();

            // 最初のトークンはシンボルである。
            var symbol:String = tokens.shift() as String;

            // 残りのトークンをループする。
            // トークンは'キー:値'の対である。
            var definition:Object = new Object();
            for (var i:int = 0; i < tokens.length; i++)
            {
                var key:String = tokens[i].split(":")[0];
                var val:String = tokens[i].split(":")[1];
                definition[key] = val;
            }

            // タイプと定義を登録する。
            setTileType(symbol, definition);
        }

        /**
         * シンボルと定義オブジェクトを関連づける。
         * @param symbol 定義に用いる文字
         * @param definition 定義するオブジェクト
         */
        public function setTileType(symbol:String, 
                                    definition:Object):void
        {
            _tileTypes[symbol] = definition;
        }

        /**
         * IsoWorldを生成し、読み込んだマップをループして、
         * マップと定義に基づいてタイルを追加していく。
         * @param size ワールドを生成するときのタイルの大きさ
         * @return フル実装されたIsoWorldのインスタンス
         */
        public function makeWorld(size:Number):IsoWorld
        {
            var world:IsoWorld = new IsoWorld();
            for (var i:int = 0; i < _grid.length; i++)
            {
                for (var j:int = 0; j < _grid[i].length; j++)
                {
                    var cellType:String = _grid[i][j];
                    var cell:Object = _tileTypes[cellType];
                    var tile:IsoObject;
                    switch (cell.type)
                    {
                        case "DrawnIsoTile":
                            tile = new DrawnIsoTile(size,
                                                    parseInt(cell.color),
                                                    parseInt(cell.height));
                            break;

                        case "DrawnIsoBox":
                            tile = new DrawnIsoBox(size,
                                                   parseInt(cell.color),
                                                   parseInt(cell.height));
                            break;

                        case "GraphicTile":
                            var graphicClass:Class = getDefinitionByName(
                                                        cell.graphicClass
                                                     ) as Class;
                            tile = new GraphicTile(size,
                                                   graphicClass,
                                                   parseInt(cell.xoffset),
                                                   parseInt(cell.yoffset));
                            break;

                        default:
                            tile = new IsoObject(size);
                            break;
                    }
                    tile.walkable = (cell.walkable == "true");
                    tile.x = j * size;
                    tile.z = i * size;
                    world.addChild(tile);
                }
            }
            return world;
        }

        /**
         * 行にスペースしかない場合にtrueを返す。
         * @param line 調べる文字列
         */
        private function lineIsEmpty(line:String):Boolean
        {
            for (var i:int = 0; i < line.length; i++)
            {
                if (line.charAt(i) != " ") return false;
            }
            return true;
        }

        /**
         * 行が//で始まるコメントならtrueを返す。
         * @param line 調べる文字列
         */
        private function isComment(line:String):Boolean
        {
            return line.indexOf("//") == 0;
        }

        /**
         * 行が#で始まる定義ならtrueを返す。
         * @param line 調べる文字列
         */
        private function isDefinition(line:String):Boolean
        {
            return line.indexOf("#") == 0;
        }
    }
}
