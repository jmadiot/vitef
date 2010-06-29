var radius = 30;
var states = new Array(100);
var nb_states = 0;
var ctx;
var selected = false
var selected_state = -1;
var move = false;

function is_eq(name, elmt)
{
		return (elmt[0] == name);
}

function remove(arr, elmt)
{
	arr = arr.slice(remove(arr)); // todo : better
	nb_states--;
}

// tels if the point (x,y) is in a state-circle. return -1 if false, and its index else. TODO
function is_in_circle(x, y)
{
	var over = false
	var i = 0;
	while(i < nb_states)
	{
		if(((x-states[i][0])*(x-states[i][0]) + (y - states[i][1])*(y - states[i][1])) <= radius*radius) return i;
		if(((x-states[i][0])*(x-states[i][0]) + (y - states[i][1])*(y - states[i][1])) <= 4*radius*radius) return (-2);
		i++;
	}
	return (-1);
}

function draw_edge(i, j) //TODO label + better
{
	var xi = states[i][0];
	var xj = states[j][0];
	var yi = states[i][1];
	var yj = states[j][1];
	var norm = Math.sqrt((xi-xj)*(xi-xj)+(yi-yj)*(yi-yj));
	ctx.beginPath();
	arrow(xj + radius * (xi-xj) / norm, yj + radius * (yi -yj) / norm, xi + radius * (xj-xi) / norm, yi + radius * (yj -yi) / norm, norm);
	/*
	ctx.moveTo(xi + radius * (xj-xi) * norm, yi + (yj -yi) * norm);
	ctx.lineTo(xj + radius * (xi-xj) * norm, yj + (yi -yj) * norm);
	
	ctx.stroke(); */
}

function arrow(xi, yi, xj, yj, norm)
{	
	ctx.beginPath();
	ctx.moveTo(xi, yi);
	//ctx.quadraticCurveTo((xi+xj +(yi-yj)*0.5)/2, (yi+yj + (xj-xi)*0.5)/2 ,xj, yj);
	ctx.lineTo(xj, yj);
	ctx.lineTo(xj - 15 *(xj- xi - 0.8 * (yj-yi))/norm, yj - 15 *(yj -yi + 0.8 * (xj -xi)) /norm);
	ctx.moveTo(xj, yj);
	ctx.lineTo(xj - 15 *(xj- xi + 0.8 * (yj-yi))/norm, yj - 15 *(yj -yi - 0.8 * (xj -xi)) /norm);
	ctx.stroke();
	
}


function clicked(event)
{
	var x = event.clientX;
	var y = event.clientY;
	var i = is_in_circle(x, y);
	if(i == -1) // create a new state
	{
		if(radius <= x && x <= 500 -radius && radius <= y && y <= 500 -radius)
		{
			states[nb_states] = [x, y, "foo"];
			nb_states++;
			draw_circle(x, y, radius);
		}
		deselect(selected_state);
	}
	else // move or draw edge. select it.
	{
		if(i == -2)
		{
			selected = false;
			deselect(selected_state);
		}
		else
		{
			if(selected == true)
			{
				if(i == selected_state)
				{
					move = true;
				}
				else 
				{
					deselect(selected_state);
					draw_edge(i, selected_state);
					selected = false;
				}
			}
			else
			{
				selected = true;
				selected_state = i;
				select(i); 
			}
		}
	}
}

function select(i)
{
	//for initial states draw_circle(states[i][0], states[i][1], radius*0.9);
	ctx.strokeStyle = "red";
	ctx.lineWidth = 2;
	draw_circle(states[i][0], states[i][1], radius);
	ctx.strokeStyle = "black";
	ctx.lineWidth = 1;
	//ctx.fillStyle = "black";
}

function deselect(i)
{
	if(0 <= i)
	{
		ctx.strokeStyle = "white";
		ctx.lineWidth = 3;
		draw_circle(states[i][0], states[i][1], radius);
		ctx.strokeStyle = "black";
		ctx.lineWidth = 1;
		draw_circle(states[i][0], states[i][1], radius);
	}
}



function draw_circle(x, y, r)
{
	ctx.beginPath();
	ctx.arc(x, y, r, 0, 2* Math.PI, true);
	ctx.stroke();
}


function init()
{	
	states
	ctx = document.getElementById('can').getContext('2d');
}
