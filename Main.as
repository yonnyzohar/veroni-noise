package {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Main extends MovieClip {


		var values: Array = [
			0x000000,
			0x080808,
			0x101010,
			0x181818,
			0x202020,
			0x282828,
			0x303030,
			0x383838,
			0x404040,
			0x484848,
			0x505050,
			0x585858,
			0x606060,
			0x686868,
			0x696969,
			0x707070,
			0x787878,
			0x808080,
			0x888888,
			0x909090,
			0x989898,
			0xA0A0A0,
			0xA8A8A8,
			0xA9A9A9,
			0xB0B0B0,
			0xB8B8B8,
			0xBEBEBE,
			0xC0C0C0,
			0xC8C8C8,
			0xD0D0D0,
			0xD3D3D3,
			0xD8D8D8,
			0xDCDCDC,
			0xE0E0E0,
			0xE8E8E8,
			0xF0F0F0,
			0xF5F5F5,
			0xF8F8F8,
			0xFFFFFF
		];

		var points: Array = [];
		var row: int = 0;
		var col: int = 0;
		var w: int;
		var h: int;
		var bd: BitmapData;
		var bmp: Bitmap;
		var tileW: int;
		var tileH: int;
		var numRowTiles: int = 8;
		var numColTiles: int = 8;

		public function Main() {
			// constructor code
			w = stage.stageWidth / 2;
			h = stage.stageHeight / 2;

			bd = new BitmapData(w, h, false, 0xffffff);
			bmp = new Bitmap(bd);
			stage.addChild(bmp);
			
			tileW = w / numColTiles;
			tileH = h / numRowTiles;
			bmp.scaleX = bmp.scaleY = 2;
			values.reverse();
			createPoints();

			stage.addEventListener(Event.ENTER_FRAME, update);
		}


		function bob(): void {

			var row: int = 0;
			var col: int = 0;

			for (row = 0; row < h; row++) {
				for (col = 0; col < w; col++) {
					var colQ: int = col / tileW;
					var rowQ: int = row / tileH;
					var distArr: Array = [];


					for (var i: int = -1; i <= 1; i++) {
						for (var j: int = -1; j <= 1; j++) {
							if (points[rowQ + i] && points[rowQ + i][colQ + j]) {
								var p: Object = points[rowQ + i][colQ + j];
								var distX: int = Math.abs(p.col - col);
								var distY: int = Math.abs(p.row - row);
								p.dist = Math.sqrt((distX * distX) + (distY * distY));

								distArr.push(p.dist);

							}
						}
					}

					distArr.sort(Array.NUMERIC);
					var shortestDist: Number = distArr[0];
					var secondShortestDist: Number = distArr[1];
					var totalDist: Number = shortestDist + secondShortestDist;

					var numPer: Number = shortestDist / totalDist  ;
					if (numPer > 1) {
						numPer = 1;
					}
					if (numPer < 0) {
						numPer = 0;
					}

					var index: int = values.length * numPer;
					bd.setPixel(col, row, values[index]);
				}
			}
		}


		//setInterval(bob, 100);


		function update(e: Event): void {
			var p: Object;
			for (var i: int = 0; i < points.length; i++) {
				for (var j: int = 0; j < points[i].length; j++) {
					p = points[i][j];
					if (p.currCol == undefined) {
						p.currCol = int(p.col / tileW);
						//trace("p.currCol " + p.currCol);
					}
					if (p.currRow == undefined) {
						p.currRow = int(p.row / tileH);
						//trace("p.currRow " + p.currRow);
					}

					if (p.randomX == undefined) {
						var startX: int = (tileW * p.currCol);
						var startY: int = (tileH * p.currRow);

						p.randomX = (Math.random() * tileW) + startX;
						p.randomY = (Math.random() * tileH) + startY;

						//trace(tileW, tileH, startX, startY, p.randomX, p.randomY);
					}


					var distX: int = Math.abs(p.col - p.randomX);
					var distY: int = Math.abs(p.row - p.randomY);
					var dist: Number = Math.sqrt((distX * distX) + (distY * distY));

					if (dist > 2) {
						var xDist: Number;
						if (p.randomX > p.col) {
							xDist = p.randomX - p.col;
							p.col += xDist / 10;
						} else {
							xDist = p.col - p.randomX;
							p.col -= xDist / 10;
						}


						var yDist: Number;
						if (p.randomY > p.row) {
							yDist = p.randomY - p.row;
							p.row += yDist / 10;
						} else {
							yDist = p.row - p.randomY;
							p.row -= yDist / 10;
						}

					} else {
						var startX: int = (tileW * p.currCol);
						var startY: int = (tileH * p.currRow);
						p.randomX = (Math.random() * tileW) + startX;
						p.randomY = (Math.random() * tileH) + startY;
					}


				}
			}
			bd.lock();
			bob();
			bd.unlock();
		}



		function createPoints(): void {
			var row: int = 0;
			var col: int = 0;

			for (row = 0; row < h; row += tileH) {
				var pCol: Array = [];
				for (col = 0; col < w; col += tileW) {
					var rndX: int = col + Math.random() * tileW;
					var rndY: int = row + Math.random() * tileH;
					bd.setPixel(rndX, rndY, 0xff0000);
					pCol.push({
						row: rndY,
						col: rndX
					});
				}
				points.push(pCol);
			}
		}



	}

}