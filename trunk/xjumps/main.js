var epileptic = false;
var blink = 0;
var begin = true;
var lost = false;
var h = 0;
// queues describing the position and length of the queues
var Qx = new Queue();
var Qlen = new Queue();
// position of the player
var posx = 250;
var posy = 470;		

var step =0;
// its speed
var speedx = 0;
var speedy = 0;
// speed of the game 
var maxint = 100;
var interval = 0;
var level = 1;
var looksto = 0;
var mut;
// dealing with multi key pressed
var left_pressed = false;
var right_pressed = false;
var up_pressed = false;

// reset everything
function restart()
{
	clearInterval(mut);
	begin = true;
	lost = false;
	h = 0;
	Qx = new Queue();
	Qlen = new Queue();
	posx = 250;
	posy = 470;		
	step =0;
	speedx = 0;
	speedy = 0;
	maxint = 50;
	interval = 0;
	level = 1;
	looksto = 0;
	init();
	left_pushed = false;
	right_pushed = false;
	up_pushed = false;
	epileptic = false;
	blink = 0;
	
}

// deal with keyboard events
function keydown(e)
{
	var touche = (window.Event) ? e.which : e.keyCode;
	switch(touche){
		case 82: restart(); break; //r
		case 80: begin = !begin; break//p
		case 83: draw(); break//s		
		case 37: left_pressed = true; break//left
		case 38: up_pressed = true; break//up
		case 39: right_pressed = true; break//right
		case 69: epileptic= !epileptic	
	}	
}

function keyup(e)
{
	var touche = (window.Event) ? e.which : e.keyCode;
	switch(touche)
	{
		case 37: left_pressed = false; break//left
		case 38: up_pressed = false; break//up
		case 39: right_pressed = false; break//right	
	}	
}


// distance to the closet (in height) level
// dummy remark : if dist()== 0, we are ON a level
function dist()
{
	var dis = 1000;
	var tempx =0;
	var templen = 0;
	var tempo = 0;
	for(var k = 0; k < Qx.getSize(); k++)
	{
		tempx = Qx.dequeue();
		templen = Qlen.dequeue();
		tempo = 450 - 80*k + 20*h- posy;
		if((tempx +10<= posx)){ 
			if((posx -30<= tempx + templen*16))
			{
			  	if((0 <= tempo)) dis =  Math.min(dis, tempo);
		 	}
		 }
		Qx.enqueue(tempx);
		Qlen.enqueue(templen);
	}
	return dis;
}

// moves depending on the speed. some look if dist()==0
function moveup()
{
	if(dist() ==0 && speedy >= 0) speedy = -35;
}

function moveleft()
{
	if(posx > 46)
	{
		if(dist() == 0)
		{
			posx -=5;
		  speedx = 0;
		}
		else speedx -=3;
	}
	else speedx = - speedx;
	looksto = 0;
}

function moveright()
{
	if(posx < 482)
	{
		if(dist() == 0){
		  posx +=5;
		  speedx = 0;
		 }
		else speedx +=3;
	}
	else speedx = - speedx;
	looksto=2;
}

// initializes the queue with random levels 
function fill_Q()
{
	var len = 500;
	var x = 0;
	Qx.enqueue(15);
	Qlen.enqueue(30);
	for(var i = 0; i < 6; i++){
		len=Math.floor(Math.random()*5+5);
		x=Math.floor(Math.random()*(500 -16*len -16))+15;	
		Qx.enqueue(x);
		Qlen.enqueue(len);
	}
}

// change the speed with respect to the keys currently pressed
function changespeed()
{
	var dis = dist();
	if(left_pressed) moveleft();
	if(right_pressed) moveright();
	if(up_pressed) moveup();
	if(posx + speedx < 46)
	{
		posx = 46; speedx = - speedx;
	}
	else{
		if(posx + speedx > 482)
		{
			posx = 482;
			speedx = - speedx;
		}
		else
		{
			if(speedx >= 0 && dis == 0) speedx = Math.max(0, speedx - 5);
			if(speedx < 0 && dist == 0) speedx=Math.min(0, speedx + 5);
			posx += speedx;
		}
	}
	if(dis <= speedy){
		speedy =  0;
		posy += dis;
	}
	else{
		posy += speedy;
		speedy = speedy + 5;
	}
	if(posy > 500) lost = true;
}	

// draws the current levels
function draw_Q(ctx)
{
	var tempx;
	var templen;
	draw_background(ctx);
	if( blink == 0 ||  !epileptic)
	{
	for(var k = 0; k < Qx.getSize(); k++)
	{
		tempx = Qx.dequeue();
		templen = Qlen.dequeue();
		//roundedRect(ctx, tempx, 450 - 50*k+10*h,  templen, 10, 5);
		drawbrik(ctx, tempx, 450 - 80*k+ 20*h,  templen);
		Qx.enqueue(tempx);
		Qlen.enqueue(templen);
	}
	}
	
	draw_walls(ctx);
}
// draws everything ... tricky
function draw()
{
  var ctx = document.getElementById('can').getContext('2d');
	if(begin && !lost)
	{						
		//speedup if the player is too high 
		if(200 < posy && posy < 350 && interval != 0) interval = Math.max(interval, Math.floor(3*maxint/4));
		if(posy < 200)
		{
			interval = 0;
			posy +=10
		}
			
		if(interval == 0)
		{
			if(h==4)
			{
				 //new level
				level++;
				if(level % 10 == 0 && maxint > 1)
				{
					if(interval == maxint) interval --;
					maxint--;
				}
				Qx.dequeue();
				Qlen.dequeue();
				// new level			
				var len=Math.floor(Math.random()*5+5);
				x=Math.floor(Math.random()*(500 -16*len -16))+15;	
				Qx.enqueue(x);
				Qlen.enqueue(len);
				h=0;
			}
			else h++;
			
		}
		if(dist() == 20 && interval==0) posy +=20;
		changespeed();
		blink++;	
		if(blink == 20) blink = 0;
		draw_Q(ctx, blink);
		drawplayer(ctx, posx, posy, looksto);
		ctx.fillRect(0, 500, 500, 30);
		CanvasTextFunctions.draw(ctx,"sans", 15, 5, 520, "FLOOR = "+ level);
		interval++;
		if(interval == maxint) interval =0;
	}
	if(!begin && !lost) CanvasTextFunctions.draw(ctx,"sans", 50, 150, 250, "Pause");
	if(lost)
	{
		clearInterval();
		CanvasTextFunctions.draw(ctx,"sans", 50, 40, 250, "Game Over !");
	}
}

// main function
function init()
{
	var ctx = document.getElementById('can').getContext('2d');
  ctx.strokeStyle='white';
	ctx.fillStyle="black";
	fill_Q();
	//"mutex"
	mut = setInterval(draw, 40);
}	
