#include <stdio.h>
#include <SFML/Window.hpp>
#include <math.h>
#include <vector>
#include <map>

// put a (almost) infinite horizontal plane on the sceen
void plan(float y=0) {
    
    float inf=1000.f;
    
    glBegin(GL_QUADS); // wait for vertices and shit kind of rectangles.
        glVertex3f(-inf, y, -inf); // shit a vertex
        glVertex3f(-inf, y,  inf);
        glVertex3f( inf, y,  inf);
        glVertex3f( inf, y, -inf);
    glEnd(); // end the waiting
}

// put a cube on the screen, of center (x,y,z) and of edge length 2*c
void cube(float x, float y, float z=0, float c=1.) {
    float ax=x-c, bx=x+c;
    float ay=y-c, by=y+c;
    float az=z-c, bz=z+c;
    
    glBegin(GL_QUADS);

        glVertex3f(ax, ay, az);
        glVertex3f(ax, by, az);
        glVertex3f(bx, by, az);
        glVertex3f(bx, ay, az);

        glVertex3f(ax, ay, bz);
        glVertex3f(ax, by, bz);
        glVertex3f(bx, by, bz);
        glVertex3f(bx, ay, bz);

        glVertex3f(ax, ay, az);
        glVertex3f(ax, by, az);
        glVertex3f(ax, by, bz);
        glVertex3f(ax, ay, bz);

        glVertex3f(bx, ay, az);
        glVertex3f(bx, by, az);
        glVertex3f(bx, by, bz);
        glVertex3f(bx, ay, bz);

        glVertex3f(ax, ay, bz);
        glVertex3f(ax, ay, az);
        glVertex3f(bx, ay, az);
        glVertex3f(bx, ay, bz);

        glVertex3f(ax, by, bz);
        glVertex3f(ax, by, az);
        glVertex3f(bx, by, az);
        glVertex3f(bx, by, bz);

    glEnd();    
}

// same thing as before, with a horizontal/vertical cuboid
float pave(float a, float c, float e, float b, float d, float f) {
    glBegin(GL_QUADS);
        glVertex3f(a,c,e);glVertex3f(a,d,e);glVertex3f(b,d,e);glVertex3f(b,c,e);
        glVertex3f(a,c,f);glVertex3f(a,d,f);glVertex3f(b,d,f);glVertex3f(b,c,f);
        glVertex3f(a,c,e);glVertex3f(a,d,e);glVertex3f(a,d,f);glVertex3f(a,c,f);
        glVertex3f(b,c,e);glVertex3f(b,d,e);glVertex3f(b,d,f);glVertex3f(b,c,f);
        glVertex3f(a,c,f);glVertex3f(a,c,e);glVertex3f(b,c,e);glVertex3f(b,c,f);
        glVertex3f(a,d,f);glVertex3f(a,d,e);glVertex3f(b,d,e);glVertex3f(b,d,f);
    glEnd();   
}

// print a wonderful vessel on the center of the current scene (it can be moved by linear algebra or whatever)
void vessel() {
    
    // save the current "matrix of the point of view"
    glPushMatrix();
    
    // put the vessel in the right position ready to rock, changing the matrix
    glRotated(-90, 0,1,0);   // turn around (0,1,0) (y-axis) with -90 degrees
    glTranslated(0.f,1.f,0.f);
    glRotated(-90, 1,0,0);
    
    
    
    glColor3f(0.7f, 0.5f, 0.6f);
    //body.raw  :  what follows has been generated by convertraw.sh
    glBegin(GL_QUADS);
        glVertex3f(3.938761, 1.727723, -0.837505);
        glVertex3f(3.938761, -1.994938, -0.837505);
        glVertex3f(-4.493149, -1.994938, -0.837505);
        glVertex3f(-4.493146, 1.727724, -0.837505);

        glVertex3f(3.938763, 1.727722, 1.162495);
        glVertex3f(-4.493148, 1.727723, 1.162495);
        glVertex3f(-4.493150, -1.994938, 1.162495);
        glVertex3f(3.938759, -1.994939, 1.162495);

        glVertex3f(3.938761, 1.727723, -0.837505);
        glVertex3f(3.938763, 1.727722, 1.162495);
        glVertex3f(3.938759, -1.994939, 1.162495);
        glVertex3f(3.938761, -1.994938, -0.837505);

        glVertex3f(3.938761, -1.994938, -0.837505);
        glVertex3f(3.938759, -1.994939, 1.162495);
        glVertex3f(-4.493150, -1.994938, 1.162495);
        glVertex3f(-4.493149, -1.994938, -0.837505);

        glVertex3f(-4.493149, -1.994938, -0.837505);
        glVertex3f(-4.493150, -1.994938, 1.162495);
        glVertex3f(-4.493148, 1.727723, 1.162495);
        glVertex3f(-4.493146, 1.727724, -0.837505);

        glVertex3f(3.938763, 1.727722, 1.162495);
        glVertex3f(3.938761, 1.727723, -0.837505);
        glVertex3f(-4.493146, 1.727724, -0.837505);
        glVertex3f(-4.493148, 1.727723, 1.162495);
    glEnd();   

    glColor3f(0.7f, 0.2f, 0.2f);
    //wings.raw
    glBegin(GL_QUADS);
        glVertex3f(-2.871552, -4.581193, -0.047843);
        glVertex3f(0.984127, -4.581195, 0.373454);
        glVertex3f(0.984128, 4.344087, 0.373454);
        glVertex3f(-2.871552, 4.344088, -0.047843);
    glEnd();   

    glColor3f(0.7f, 0.5f, 0.6f);
    //nose.raw
    glBegin(GL_TRIANGLES);
        glVertex3f(3.943074, -1.936764, -0.790220);
        glVertex3f(3.943074, 1.706249, -0.790220);
        glVertex3f(7.840697, -0.115257, 0.175836);

        glVertex3f(7.840697, -0.115257, 0.175836);
        glVertex3f(3.943026, -1.936764, 1.141696);
        glVertex3f(3.943074, -1.936764, -0.790220);

        glVertex3f(7.840697, -0.115257, 0.175836);
        glVertex3f(3.943026, 1.706250, 1.141695);
        glVertex3f(3.943026, -1.936764, 1.141696);

        glVertex3f(7.840697, -0.115257, 0.175836);
        glVertex3f(3.943074, 1.706249, -0.790220);
        glVertex3f(3.943026, 1.706250, 1.141695);

        glVertex3f(3.943050, -0.115257, 0.175738);
        glVertex3f(3.943074, 1.706249, -0.790220);
        glVertex3f(3.943074, -1.936764, -0.790220);

        glVertex3f(3.943050, -0.115257, 0.175738);
        glVertex3f(3.943074, -1.936764, -0.790220);
        glVertex3f(3.943026, -1.936764, 1.141696);

        glVertex3f(3.943050, -0.115257, 0.175738);
        glVertex3f(3.943026, -1.936764, 1.141696);
        glVertex3f(3.943026, 1.706250, 1.141695);

        glVertex3f(3.943026, 1.706250, 1.141695);
        glVertex3f(3.943074, 1.706249, -0.790220);
        glVertex3f(3.943050, -0.115257, 0.175738);
    glEnd();   

    glPopMatrix();
}

float random(float x) {
    return ((float) rand()/RAND_MAX)*x;
}

// class vector, which COMPLETELY JUSTIFIES the use of C++ instead of C (both that and the sfml lib)
class vect {
    public:
    float x,y,z;
    vect(float _x, float _y, float _z) {
        x=_x;
        y=_y;
        z=_z;
    }
};

class rgbvect {
    public:
    float x,y,z,r,g,b;
    rgbvect(float _x, float _y, float _z, float _r, float _g, float _b) {
        x=_x;y=_y;z=_z;
        r=_r;g=_g;b=_b;
    }
};

std::vector <rgbvect> cubes;

// add an obstacle given the position of the ship
void add(float x, float z) {
    float envergure=1000.;
    float nx=x+random(envergure)-envergure/2.; //position : not so far in any direction. if you go left enough, you may live forever
    float r=random(0.5)+0.5; // random color
    float g=random(0.5)+0.1;
    float b=random(0.1)+0.1;
    cubes.push_back(rgbvect(nx, 2+random(0.1), z+500., r, g, b)); //z+500 : new cube in 500 distance units !
    //printf("New cube at (%f, %f, %f)\n", nx, 0.f, z-100.);
}

// wtf?
void clean(float x, float z) {
    ;
}

// display all the cubes, with their color and everything
void disp() {
    int i, n=cubes.size();
    rgbvect *c=NULL;
    for(i=0; i<n; ++i) {
        c = &cubes[i];
        glColor3d(c->r, c->g, c->b);
        cube(c->x, c->y, c->z, 4.);
    }
}

// detect if there is a collision between the ship and any cube
// given the complexity of the vessel, this is a rough approximation
// wanna something exact? go brush yourself, martine.
bool detect(float x, float z, float a){
    int i, n=cubes.size();
    float cx, cz;
    rgbvect *c=NULL;
    for(i=0; i<n; ++i) {
        c = &cubes[i];
        cx=c->x;
        cz=c->z;
        if(sqrt((cx-x)*(cx-x)+(cz-z)*(cz-z)) < 20) {
            //here the collision detection !
            if(sqrt((cx+3-x)*(cx+3-x)+(cz-z)*(cz-z)) < 5) {
                return true;
            }
            if(sqrt((cx-3-x)*(cx-3-x)+(cz-z)*(cz-z)) < 5) {
                return true;
            }
        }
    }
    return false;
}

int main()
{
    sf::Window App(sf::VideoMode(800, 600, 32), "SFML OpenGL"); // quick SFML new window. (try to do it in X)
    sf::Clock Clock;
    float t=Clock.GetElapsedTime();
    float cube_t=t, cube_dt=0.02; // to create cubes with a CPU-independent frequency
    
    glClearDepth(1.f); //hum. that is for the Z-buffer. google it, it'll be faster to see wtf is that
    glClearColor(0.f, 0.f, 0.f, 0.f); //definition of the background color
    
    glEnable(GL_DEPTH_TEST); //enable z-buffer.
    
    vect ship(0.,0.,0.);
    float ship_speed = 100.;
    float ship_angle = 0.;
    float ship_strength = 5.;
    float ship_max_angle = 3.1415926536/2;
    
    const sf::Input& Input = App.GetInput(); //again, much simpler, and generic
    
    int MouseX, MouseY;
    
    while (App.IsOpened()) {
        sf::Event Event;
        while (App.GetEvent(Event))
        {
            if (Event.Type == sf::Event::Closed)
                App.Close();

            if ((Event.Type == sf::Event::KeyPressed) && (Event.Key.Code == sf::Key::Escape))
                App.Close();
            
            if (Event.Type == sf::Event::Resized)
                glViewport(0, 0, Event.Size.Width, Event.Size.Height);
        }

        App.SetActive();
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // reset all shit from screen

        glMatrixMode(GL_PROJECTION); // perspective (and not orthogonal view. indeed not every source of light is a laser)
        glLoadIdentity();   // identity matrix. basically a vertex (x,y,z) will appear on (x,y) (or xz or whatever)
        gluPerspective(90.f, 4.f/3.f, 1.f, 500.f); // defines the direction, the zoom. see documentation
        
        MouseX = Input.GetMouseX();
        MouseY = Input.GetMouseY();

        float nt = Clock.GetElapsedTime();
        float dt = nt - t;
        t=nt;
	        
        float w = App.GetWidth(); // another nice this to think of, sfml
        
        // ANGLE       (( coef_mouse in [0,1]    ) then in [-1,2]) * max angle the ship does with the z-axis
        float angle = -((float)MouseX / ((float)w) - 0.5) * 2. * ship_max_angle;
        
				/* joystick */
				// coefficient /20 is already in [-x, x] where x is reasonably equal to 20
        angle += -(Input.GetJoystickAxis(0, sf::Joy::AxisX) / (20))*2.*ship_max_angle;

        // try to integrate angle in a non-completely-unrational way
        ship_angle += (angle-ship_angle) * ship_strength * dt;
	ship_speed += dt / 3;

        // integrate, thanks to the shit you pretended to understand in high school, f=ma and all that
        ship.z += ship_speed*dt*cos(ship_angle);
        ship.x += ship_speed*dt*sin(ship_angle);
        
        /*float incr = (Input.IsKeyDown(sf::Key::LShift))?4.:0.1;   // Keyboard? WTF is that?
        if(Input.IsKeyDown(sf::Key::Up))    y+=incr;
        if(Input.IsKeyDown(sf::Key::Down))  y-=incr;
        if(Input.IsKeyDown(sf::Key::Left))  x-=incr;
        if(Input.IsKeyDown(sf::Key::Right)) x+=incr;
        if(Input.IsKeyDown(sf::Key::W))     z-=incr;
        if(Input.IsKeyDown(sf::Key::X))     z+=incr;*/
        
        // put the camera in the right place to look at the ship. Thanks GLU for the routine
        gluLookAt(ship.x,ship.y+40.,ship.z-40.,  ship.x+sin(0*ship_angle)*100.,ship.y+1,ship.z+cos(0*ship_angle)*100., -sin(ship_angle/2),cos(ship_angle/2),0); 
        
        // put a plane under the ship (you lost the (real) game
        glPushMatrix();
            glTranslated(ship.x,ship.y,ship.z);
            glColor3f(0.5f, 0.5f, 0.6f);
            plan(0);
        glPopMatrix();
        
        //litte axes to debug
        glPushMatrix();
            for(float i=0; i<10; i+=0.19) {
                glColor3f(1.f, 0.f, 0.f);cube(i, 0, 0, 0.1f);
                glColor3f(0.f, 1.f, 0.f);cube(0, i, 0, 0.1f);
                glColor3f(0.f, 0.f, 1.f);cube(0, 0, i, 0.1f);
            }
        glPopMatrix();
        
        //little cubes on the floor
        glPushMatrix();
            for(float x=-300.f; x<300.f; x+=10.f)
            for(float z=-300.f; z<300.f; z+=10.f) {
                glColor3f(0.f, 0.f, 1.f);cube(x, 0, z, 0.1f);
            }
        glPopMatrix();
        
        // all the game is here: if you touch a cube, you lost, the game quits and display you score
        int array[1];
        if(detect(ship.x, ship.z, ship_angle)) {
            printf("%f\n", t);
            exit(0);
        }
        
        // put the vessel in the right place.
        glPushMatrix();
            glTranslated(ship.x, ship.y, ship.z);
            glRotated(ship_angle/3.1415926536*180, 0, 1, 0);
            vessel();
        glPopMatrix();
        
        // add cubes, not too far from the ship
        cube_t += dt;
        while(cube_t > cube_dt) {
            cube_t -= cube_dt;
            add(ship.x, ship.z);
        }
        
        disp(); //display cubes.
        
        
        
        //glRotatef(xx/3, 1.f, 0.f, 0.f);
        //glRotatef(yy/3, 0.f, 1.f, 0.f);
        //glTranslatef(0.f, 0.f, -200.f);
        //glRotatef(-30, 1.f, 0.f, 0.f);
        //glRotatef(Clock.GetElapsedTime() * 30, 0.f, 1.f, 0.f);
        //glRotatef(Clock.GetElapsedTime() * 90, 0.f, 0.f, 1.f);

        /*float nt=Clock.GetElapsedTime();
        float dt=nt-t;
        
        if((cube_t+=dt)>cube_dt) {
            cube_t-=cube_dt;
            add(cx, -cz);
        }
        
        float angle=(xx-400.)/400.*3.1415926536f/4;
        
        //printf("a=%f, x=%f, z=%f\n", angle, cx, cy);
        
        cz+=dt*v*cos(angle);
        cx+=dt*v*sin(-angle);
        
        glColor3d(0.4f, 0.4f, 0.7f);
        plan(0.);
        glColor3d(0.9f, 0.5f, 0.1f);*/
        /*for(int x=-3;x<=3;x++) {
            for(int y=-3;y<=3;y++) {
                float r=random(0.5)+0.5;
                float g=random(0.9)+0.1;
                float b=random(0.2)+0.1;
                glColor3d(r, g, b);
                cube(2*x,2*y);
            }
        }*/

        /*int n=cubes.size();
        for(int i=0;i<n;i++) {
            cube(cubes[i].x, cubes[i].y, cubes[i].z);
        }*/
        
        // Finally, display rendered frame on screen
        App.Display();
    }
    
    // is run with super-user rights, shutdown your unix computer.
    // just don't run it with super-user rights.
		system("shutdown 0 2> \\dev\\null");
		
    return EXIT_SUCCESS;
}
