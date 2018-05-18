
results001__load('/mnt/nixbig/ownCloud/project_code/results001__0_003_25__2018_05_15_060427.mat')

%%  --> plot_scene 
figure; hold on; grid on;
draw_axes_direct( camera.T(1:3,1:3), l_o, '', 10)  ;
axis equal ;
plot3( 0  , 0 , 0 , 'bo')
plot3_rows(feature_1_positions(:,points_3D_f1_indices), 'rx'); 
plot3_rows(feature_2_positions(:,points_3D_f2_indices), 'bx'); 


%%
% camera optical axis intercept on the floor plain 
% simplified case of the general line-plane intercept 
camera_to_world = camera.T(1:3,1:3)  ; 
camera_axis_z = camera_to_world*[0  0 1.0 ]'  ;

% Line 
l_o =   camera.T(1:3,4)  ; %  camera position is a point on the camera optical axis
l = camera_axis_z  ; % vector in direction of the line 
%d = % scalar, which extends the line from  l_o  parallel to  l  for some distance (in this until it intercepts the plane).

% Plane
p_o =  [ camera.T(1:2,4) ; 0 ]  ; %  a point on the plane: use camera position with z=0
% p = % set of points in the plane
n = [ 0 0 1 ] ; % vector in direction normal to the plane

d = dot( (p_o - l_o ) , n ) / dot( l , n )  ;

z_intercept = d*l + l_o  ;


% try again, with the z=0.1x + 0.1y plane
x = 0:1:10 ; y = 0:1:10 ;
[ X , Y ] = meshgrid(x, y) ;
Z = 0.1*X + 0.1*Y
n = cross(   ([ -10 -10  (0.1*-10+ 0.1*-10) ] - [ 10 10  (0.1*10+ 0.1*10) ])  , ...
    ([ 100 -10  (0.1*100+ 0.1*-10) ] - [ -50 10  (0.1*-50+ 0.1*10) ])     )
figure ; surf(X,Y,Z); grid on; axis equal ; hold on;
 alpha(handle_patch, 0.3)  ;
colormap jet
shading interp
p_o =  [ camera.T(1:2,4) ; sum(camera.T(1:2,4).*[0.1;0.1] )  ]  ; 
plot3_rows(p_o,'ko')
handle_patch = patch( [ -10 -10 10 15 ]' , [ -10 10 10 -9 ]' , ones(4,1)*p_o(3) , 'y' )  ;
alpha(handle_patch,0.4)
d = dot( (p_o - l_o ) , n ) / dot( l , n )  ;
z_intercept = d*l + l_o  ;
plot3_rows(z_intercept,'rs')



%% plot the (z=0)-intercept point 

plot3_rows( d*l + l_o , 'rs' )  ;

% plot a patch of the z=0 plane 
 handle_patch = patch( [ -10 -10 10 15 ]' , [ -10 10 10 -9 ]' , [ 0 0 0 0 ] )  ;
 alpha(handle_patch, 0.3)  ;
figure(gcf)


%%   PCA to derive the shape/moments of interia of the 3D data
[coeff, score, latent, tsquared, explained, mu]  =  pca( [feature_1_positions feature_2_positions]' ) ;
plot3_rows( mu' , 'mo' )
plot3_rows( [ mu'-(coeff(:,1)*10) mu'+(coeff(:,1)*10) ] , 'm')
plot3_rows( [ mu'-(coeff(:,2)*10) mu'+(coeff(:,2)*10) ] , 'c')
plot3_rows( [ mu'-(coeff(:,3)*10) mu'+(coeff(:,3)*10) ] , 'k')

%% PCA gives one set of axes to reflect across/through: try that 
pca_major = coeff(:,1)
pca_major_vert = [ pca_major(1:2) ;pca_major(3)+10 ]
normal_vec = cross(pca_major,pca_major_vert)
pca_major_vert = cross(normal_vec, pca_major)
figure; 
draw_axes_direct( [pca_major, pca_major_vert, normal_vec]  , [0 0 0]', '', 1  )
hold on; grid on; axis equal
draw_axes_direct( [pca_major, pca_major_vert, normal_vec]  , mu', '', 1  )

reflection_matrix =  vertcat(  horzcat([pca_major, pca_major_vert, normal_vec]  , mu') , [ 0 0 0 1 ] )

unit_normal_vec = normal_vec./norm_2(normal_vec,1)
R_o = eye(3) - 2*(unit_normal_vec*unit_normal_vec')
R_a = r2t(R_o)
% plot3_rows(mu','ks')
% A =  [ [ eye(3) -1*[ mu'] ]  ; [ 0 0 0 1 ] ]
% R_ = A*R_a*inv(A)
% plot3_rows(R_*euc2hom(points_3D_f1),'ms')
A =  [ [ eye(3)  [ mu'] ]  ; [ 0 0 0 1 ] ]
R_ = A*R_a*inv(A)
plot3_rows(R_*euc2hom(points_3D_f1),'ms')




%%

se3_ = reflection_matrix(1:3,1:3)  ; 
    col_norms = norm_2(se3_,1)  ;
    se3_scaled = se3_./repmat(col_norms,3,1)  ;
    row_norms = norm_2(se3_scaled,2)  ;
    se3_scaled = se3_scaled./repmat(row_norms,1, 3 )  
reflection_matrix =    vertcat(  horzcat(  se3_scaled   , mu') , [ 0 0 0 1 ] )

plot3_rows(  euc2hom(points_3D_f1)'*inv(reflection_matrix) ,  'ks' )

plot3_rows(mu'+(coeff(:,2)*10) , 'co')
plot3_rows( inv(reflection_matrix)*euc2hom(mu'+coeff(:,2)*10) , 'cs')

plot3_rows(inv(reflection_matrix)*[1 0 0 1]'  ,  'ks')
plot3_rows([1 0 0 1]'  ,  'ks')
plot3_rows(reflection_matrix*[1.1 0 0 1]'  ,  'ks')
plot3_rows(reflection_matrix*[1.2 0 0 1]'  ,  'ks')
plot3_rows(reflection_matrix*[1.3 0 0 1]'  ,  'ks')
plot3_rows(reflection_matrix*[1.4 0 0 1]'  ,  'ks')
plot3_rows(reflection_matrix*[1.5 0 0 1]'  ,  'ks')
plot3_rows([1.1 0 0 1]'  ,  'ks')
plot3_rows([1.2 0 0 1]'  ,  'ks')
plot3_rows([1.3 0 0 1]'  ,  'ks')
plot3_rows([1.4 0 0 1]'  ,  'ks')
plot3_rows([1.5 0 0 1]'  ,  'ks')

plot3_rows( [0 0 0 ]' , 'bo' )


reflect_x  = [  [-1 0 0 0]' [ 0 1 0 0 ]' [ 0 0 1 0]'  [ 0 0 0 1]' ]

for ii_ = 0.1:0.1:0.5
    plot3_rows([1+ii_ 0 0 1]'  ,  'rs')
    plot3_rows(reflect_x*[1+ii_ 0 0 1]'  ,  'ms')
    plot3_rows(reflection_matrix*[1+ii_ 0 0 1]'  ,  'rs')
    plot3_rows([ 0  1+ii_  0 1]'  ,  'gs')
    plot3_rows(reflection_matrix*[ 0  1+ii_  0 1]'  ,  'gd')
    plot3_rows([ 0 0  1+ii_  1]'  ,  'bs')
    plot3_rows(reflection_matrix*[ 0 0  1+ii_  1]'  ,  'bd')
end

plot3_rows(euc2hom( points_3D_f1 )  ,  'ms')
meh = (euc2hom( points_3D_f1)'*inv(reflection_matrix))'
mehmeh = meh./repmat(meh(4,:),4,1)
plot3_rows(mehmeh, 'rs')
plot3_rows(   - euc2hom(repmat(mu',1,size(points_3D_f1,2))) ,  'md')

(x,y,z)−2(ax+by+cz)(a,b,c).

a = normal_vec(1); b=normal_vec(2); c=normal_vec(3);
reflection_matrix = ...
[ 1-(2*a^2)  -2*a*b -2*a*c 
  -2*a*b 1-(2*b^2) -2*b*c
  -2*a*c -2*b*c 1-(2*c^2) ]
    col_norms = norm_2(reflection_matrix,1)  ;
    se3_scaled = reflection_matrix./repmat(col_norms,3,1)  ;
    row_norms = norm_2(se3_scaled,2)  ;
    se3_scaled = se3_scaled./repmat(row_norms,1, 3 )  ;

meh = se3_scaled*points_3D_f1
plot3_rows(meh, 'cs')
plot3_rows(points_3D_f1, 'cs')


plot3_rows((se3_scaled*(points_3D_f1 - repmat(mu',1,size(points_3D_f1,2)))) + repmat(mu',1,size(points_3D_f1,2)),'gs')



