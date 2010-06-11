var redbrik = new Image();
var bluebrik = new Image();
var player_left = new Image();
var player_right = new Image();
var background = new Image();

redbrik.src="redbrik.png";
bluebrik.src="bluebrik.png";
player_right.src="player_right.gif";
player_left.src="player_left.gif";
background.src="background.png";

function drawbrik(ctx, x, y, len){
	for(var i = 0; i < len; i++){
		ctx.drawImage(redbrik, x+16*i, y);
	}
}

function drawplayer(ctx,x,y, looksto){
	if(looksto == 0)	ctx.drawImage(player_left, x-32, y-32);
	else ctx.drawImage(player_right, x-32, y-32);
}

function draw_background(ctx){
	for(var i = 1; i < 31; i++){
		for(var j = 0; j < 32; j++) ctx.drawImage(background, 16*i-1, 16*j);
	}
}

function draw_walls(ctx){
	for(var i = 0; i < 16; i++){
		ctx.drawImage(bluebrik, 0, 32*i);
		ctx.drawImage(bluebrik, 485, 32*i);
	}
}
