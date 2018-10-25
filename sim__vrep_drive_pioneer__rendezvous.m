%%
%{ 
Scene : /mnt/nixbig/ownCloud/project_code/vrep_QUT_S11/S11_matlab_20180801_002_one_Pioneer.ttt
Produce data for :  camera_extrinsics__generate_path_3D_data_loop_pose_004.m
%}

vrep = VREP();
%{
vrep.simstart()
vrep.simstop()
vrep.disconnect()
vrep.delete
%}
    %  cam_603_vrepcamera = vrep.camera('cam_603_vrepcamera')
cam603sensor = vrep.camera('cam603sensor')
cam603sensor0 = vrep.camera('cam603sensor0')
cam603sensor0.getpose


Pioneer_p3dx_1 = vrep.gethandle('Pioneer_p3dx_1')  ;
Pioneer_p3dx_1__base_link_ = vrep.gethandle('base_link_')  ;
Pioneer_p3dx_1__base_link = vrep.gethandle('base_link')  ;
Pioneer_p3dx_1__pos = vrep.getpos(Pioneer_p3dx_1,-1)
Pioneer_p3dx_1__rot = vrep.getorient(Pioneer_p3dx_1,-1)
Pioneer_p3dx_1__pose = vrep.getpose(Pioneer_p3dx_1,-1)
vrep.getpos(Pioneer_p3dx_1__base_link)
vrep.getpos(Pioneer_p3dx_1__base_link_)


Pioneer_p3dx_2 = vrep.gethandle('Pioneer_p3dx_2')  ;
vrep.getpos(Pioneer_p3dx_2,-1)
vrep.setpos(Pioneer_p3dx_2, Pioneer_p3dx_1__pos,-1)
vrep.setpose(Pioneer_p3dx_2, Pioneer_p3dx_1__pose,-1)
Pioneer_p3dx_1__rot = vrep.getorient(Pioneer_p3dx_1,-1)
vrep.setorient(Pioneer_p3dx_2, Pioneer_p3dx_1__rot , -1)
vrep.setpos(Pioneer_p3dx_2, Pioneer_p3dx_1__pos+[1 0 0],-1)


%-- check that can get and set pose properly 

while true
    Pioneer_p3dx_1__rot = vrep.getorient(Pioneer_p3dx_1,-1)
    vrep.setorient(Pioneer_p3dx_2, Pioneer_p3dx_1__rot , -1)
    pause(0.3)
end
while true
    Pioneer_p3dx_1__rot = vrep.getorient(Pioneer_p3dx_1,-1)
    Pioneer_p3dx_1__pose = vrep.getpose(Pioneer_p3dx_1,-1)
    vrep.setorient(Pioneer_p3dx_2, Pioneer_p3dx_1__pose(1:3,1:3) , -1);
    pause(0.3)
end

%--


%  marker detection --> 2D pixel point
figure_named('cam603sensor0.grab')  ;  
im =  cam603sensor0.grab  ;
idisp(im)
idisp(im2bw(im))
[label, num_sets] = ilabel(im2bw(im))  ;
num_sets
marker_pixels = label==2 ;
idisp(marker_pixels)
blob =  imoments(marker_pixels) 
hold on
plot(blob.uc,blob.vc,'gx')
% 3D point
marker_handle = vrep.gethandle('BoofCV_5_Sphere')
vrep.getpos(marker_handle)

pioneer_handle = vrep.gethandle('Pioneer_p3dx')
class(pioneer_handle)
pioneer_pose = vrep.getpose(pioneer_handle)
pioneer_object = vrep.object('Pioneer_p3dx')
class(pioneer_object)


Pioneer_p3dx_leftMotor_handle = vrep.gethandle('Pioneer_p3dx_leftMotor')  ;
vrep.getjoint(Pioneer_p3dx_leftMotor_handle)
Pioneer_p3dx_rightMotor_handle = vrep.gethandle('Pioneer_p3dx_rightMotor')  ;
vrep.getjoint(Pioneer_p3dx_rightMotor_handle)

vrep.setjointtarget(Pioneer_p3dx_leftMotor_handle,-2.0)
vrep.setjointtarget(Pioneer_p3dx_rightMotor_handle,2.0)

vrep.setjointvel(Pioneer_p3dx_leftMotor_handle,1.0)
vrep.setjointvel(Pioneer_p3dx_rightMotor_handle,-1.0)
vrep.setjointvel(Pioneer_p3dx_rightMotor_handle,1.0)

vrep.setjointvel(Pioneer_p3dx_leftMotor_handle,0.0)
vrep.setjointvel(Pioneer_p3dx_rightMotor_handle,0.0)

vrep.getobjparam_float
vrep.setobjparam_float(pioneer_handle,'left_add_vel',1.0)

way_pts = [
    300.0, 500.0 ; 
    100.0, 500.0 ; 
    120.0, 400.0 ; 
    90.0, 80.0 ; 
    100, 10 ; 
    500.0, 500.0]  ;
class(way_pts)
way_pts = [
    200.0, 200.0 ; 
    100.0, 150.0 ; 
    120.0, 400.0 ; 
    90.0, 80.0 ; 
    100, 10 ; 
    500.0, 500.0]  ;

%{
way_pts = [  ...
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 0 50 ] 
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 100 200 ]
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 150 220 ]
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 200 100 ] 
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 250 120 ]
    pioneer_pose__orig_local(1:2,4)'.*100 ]  ;
way_pts=double(round(way_pts))  ;
class(way_pts)
%}    

pioneer_z_ = pioneer_pose(3,4)
pioneer2_ = pioneer_object
%   pioneer_pose__orig = pioneer_object.getpose
pioneer_pose__orig_local = pioneer_object.getpose


pioneer_object.setpos(single([0 0 0])) ;  pioneer_object.setorient(eye(3))
pioneer_object.setpose( pioneer_pose__orig) ; pioneer_object.setorient(eye(3))
%  [x_old,y_old] = [x,y]
[x,y] = map_to_world(total_path_smoothed__(2,:)',total_path_smoothed__(1,:)') ;
way_pts = [x y].*100  ;
pp = temp__pure_pursuit_vrep_waypoints( ...
    pioneer_z_ , pioneer2_ , ...
    way_pts , vrep ,  pioneer_object )

way_pts

%{  
    RESET THE POSE
    pioneer_object.setpose( pioneer_pose__orig) ; pioneer_object.setorient(eye(3))
    pioneer_object.setpose( pioneer_pose__orig_local) ; pioneer_object.setorient(eye(3))
%}
    global time_stamp
    global detected
    global marker_2D_uv
    global pose_3D
    
    detected_double = double(detected)  ;
    save( strcat('/mnt/nixbig/ownCloud/project_code/mat_files_S11_sim/',datestr(datetime,30),'.mat.txt') , 'time_stamp', 'detected_double', 'marker_2D_uv', 'pose_3D',  '-ascii','-double','-tabs' )
    
    time_stamp = []  ;
    detected = uint32([])  ;
    marker_2D_uv = [0 0 ]  ;
    pose_3D = [ 0 0 0  ]  ;
    
figure_named('pose_3D'); plot3_rows(pose_3D','rx'); hold on; grid on; axis equal; xlabel('x'); ylabel('y')
figure_named('pixels 2D'); plot_rows(marker_2D_uv','rx'); hold on; grid on; axis equal; xlabel('x'); ylabel('y')


    time_stamp_old = time_stamp  ;
    detected_old = detected;
    marker_2D_uv_old = marker_2D_uv  ;
    pose_3D_old = pose_3D  ;