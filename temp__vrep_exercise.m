

vrep = VREP();


cam = vrep.camera('DefaultCamera');

% then get the camera position
p = cam.getpos
o = cam.getorient

cam.setpos(2*p)
cam.setpos(0.5*p)

bill = vrep.loadmodel('people/Walking Bill');

fire = vrep.loadmodel('other/fire')
T = fire.getpose()
vrep.simstart();
vrep.simstop();

pioneer1 = vrep.loadmodel('robots/mobile/pioneer p3dx')

pioneer2 = vrep.loadmodel('robots/mobile/pioneer p3dx')

pioneer_z = pioneer2.getpos()
pioneer_z = pioneer_z(3)

pioneer2_T = pioneer2.getpos()
pioneer2.setpos( pioneer2_T+ [ 1.5 , 0.5 , 0.0] )
%n=pioneer2.name()
pioneer2.setorient( r2t(rotz(pi/2)) , pioneer2)
pioneer2.setpos( [0.1 0.1 0.0] , pioneer2)
pioneer1.setpos( [0.1 0.1 0.0] , pioneer2)
pioneer1.setpos( [0.1 0.1 pioneer_z] )

