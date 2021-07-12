clc; clear; close all;

% - output setting
out_dir = 'result_figs/';
out_fig = 0;

% - import dem data
in_dir = 'data/netdem/';
file_name = 'contact/contact_000_000000000400000.vtk';
vtk_data = myvtk_read([in_dir,file_name]);

cnt_orien = vtk_data.dir_n;

fc = vtk_data.force;
fn = sum(vtk_data.force.*vtk_data.dir_n,2).*vtk_data.dir_n;
ft = vtk_data.force-fn;

fc_mag = sqrt(sum(fc.*fc,2));
fn_mag = sqrt(sum(fn.*fn,2));
ft_mag = sqrt(sum(ft.*ft,2));

fc_ave = mean(fc_mag);
tan_orien = ft./ft_mag;

% - calculate anisotropy
[ac,ac_tensor] = ev_fabric_ac(cnt_orien);
[a_ft,a_ft_tensor,fn_bar] ...
  = ev_fabric_aft(ft_mag,fn_mag,tan_orien,cnt_orien);

id_comp = 1;

% - plot contact pdf
[theta_grid,phi_grid] ...
  = meshgrid(linspace(-pi,pi,100),linspace(-pi,pi,50)/2);
aft_grid = zeros(50,100);
nx = zeros(50,100);
ny = zeros(50,100);
nz = zeros(50,100);
for i=1:50
  for j=1:100
    [orien_x,orien_y,orien_z] = sph2cart(theta_grid(i,j),phi_grid(i,j),1);
    orien_vec = [orien_x,orien_y,orien_z]';
    ft_vec ...
      = a_ft_tensor*orien_vec-orien_vec'*a_ft_tensor*orien_vec*orien_vec;
    aft_grid(i,j) = norm(ft_vec(id_comp));
    [nx(i,j),ny(i,j),nz(i,j)] ...
      = sph2cart(theta_grid(i,j),phi_grid(i,j),abs(aft_grid(i,j)));
  end
end

% - test 
figure;
surf(nx,ny,nz,'facealpha',0.3);
myfiguresize(16,12,'cm');
axis equal; box on;



% - calculate sphere histogram
res = 10; angle_tol = sqrt(4/(6*res^2));
[vertices,faces] = sub_generate_sphere(res);
num_cnt = size(cnt_orien,1);
ft_patch = zeros(size(faces,1),3);
for i=1:size(faces,1)
  patch_normal = mean(vertices(faces(i,:),:),1);
  patch_normal = patch_normal/norm(patch_normal);
  tmp_id = abs(cnt_orien*patch_normal')>cos(angle_tol);
  ft_patch(i,:) = sum(ft(tmp_id,:),1)/sum(tmp_id)/fn_bar;
  for j=1:4
    vert_tmp = vertices(faces(i,j),:);
    [theta_tmp,phi_tmp,~] = cart2sph(vert_tmp(1),vert_tmp(2),vert_tmp(3));
    [x_tmp,y_tmp,z_tmp] ...
      = sph2cart(theta_tmp,phi_tmp,norm(ft_patch(i,id_comp)));
    vertices(faces(i,j),:) = [x_tmp,y_tmp,z_tmp];
  end
end

sph_hist.vertices = vertices;
sph_hist.faces = faces;
sph_hist.colors = zeros(size(vertices,1),1);
sph_hist.colors(1:4:end) = vecnorm(ft_patch(:,id_comp),2,2);
sph_hist.colors(2:4:end) = vecnorm(ft_patch(:,id_comp),2,2);
sph_hist.colors(3:4:end) = vecnorm(ft_patch(:,id_comp),2,2);
sph_hist.colors(4:4:end) = vecnorm(ft_patch(:,id_comp),2,2);
sph_hist = sub_sphere_hist(sph_hist);

% -- plot sphere histogram
hold on;
plot_surf(sph_hist);
xlabel('x'); ylabel('y'); zlabel('z');
colorbar; myfiguresize(16,12,'cm');





