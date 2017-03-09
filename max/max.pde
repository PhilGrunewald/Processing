// 29 Jan 2016 6:54 pm Max Grunewald

float x = 100;
float y = 100;

float ball_x = 100;
float ball_y = 100;

float ball_dx = 1;
float ball_dy = 1;


void setup()
{
  size(200,200);
  smooth();
}

void keyPressed() {
  if (keyCode == UP) {
	y -= 1;
	}
  if (keyCode == DOWN) {
	y += 1;
	}
  if (keyCode == LEFT) {
	x -= 4;
	}
  if (keyCode == RIGHT) {
	x += 4;
	}
}

void moveBall() {
  ball_x += ball_dx;
  ball_y += ball_dy;

  if (ball_y < 0) { 
    ball_dy = -ball_dy;
    ball_y  = 1;
  }
  if (ball_x > width) { 
    ball_dx = -ball_dx;
    ball_x  = width-1;
  }
  if (ball_x < 0) { 
    ball_dx = -ball_dx;
    ball_x  = 1;
  }
  if (ball_y > height-10) { 
    if ((ball_x < x+20) && (ball_x > x-20)) {
      ball_dy = -ball_dy;
      ball_y  = height-11;
    } else {
      ball_y = height/2;
    }
  }
}

void draw()
{
moveBall();
background(255);
if (y > 200) {
  background(255,0,0);
}
ellipse(ball_x,ball_y, 5, 5);
strokeWeight(10);
line(x-20,190,x+20,190);
}
