clc; clear; close all;

% - output setting
out_dir = 'result_figs/';
out_fig = 0;

% - import dem data
in_dir = 'data/netdem/';
file_name = 'contact/contact_000_000000000400000.vtk';
vtk_data = myvtk_read([in_dir,file_name]);

cnt_orien = vtk_data.dir_n;

% - calculate anisotropy
[ac,ac_tensor] = ev_fabric_ac(cnt_orien);

[vertices,faces] = sub_generate_sphere(20);
cnt_orien_pdf = zeros(size(faces,1),1);
for i=1:size(faces,1)
  vert_c = sum(vertices(faces(i,:),:),1);
  vert_c_unit = vert_c'/norm(vert_c);
  cnt_orien_pdf(i) = (1+vert_c_unit'*ac_tensor*vert_c_unit)/4/pi*4*pi;
  for j=1:4
    vert_tmp = vertices(faces(i,j),:);
    [theta_tmp,phi_tmp,~] = cart2sph(vert_tmp(1),vert_tmp(2),vert_tmp(3));
    [x_tmp,y_tmp,z_tmp] = sph2cart(theta_tmp,phi_tmp,cnt_orien_pdf(i));
    vertices(faces(i,j),:) = [x_tmp,y_tmp,z_tmp];
  end
end

mysph.vertices = vertices;
mysph.faces = faces;
mysph.colors = zeros(size(vertices,1),1);
mysph.colors(1:4:end) = cnt_orien_pdf;
mysph.colors(2:4:end) = cnt_orien_pdf;
mysph.colors(3:4:end) = cnt_orien_pdf;
mysph.colors(4:4:end) = cnt_orien_pdf;
mysph = sub_sphere_hist(mysph);

% -- plot sphere histogram
figure;
plot_surf(mysph);
box on; myfiguresize(16,12,'cm');


% - calculate sphere histogram
% -- pi*(r*angle_tol)^2*n=4*pi*r^2
res = 10; angle_tol = sqrt(4/(6*res^2)); patch_area = 4*pi/(6*res^2);
[vertices,faces] = sub_generate_sphere(res);
num_cnt = size(cnt_orien,1);
cnt_orien_pdf = zeros(size(faces,1),1);
for i=1:size(faces,1)
  patch_normal = mean(vertices(faces(i,:),:),1);
  patch_normal = patch_normal/norm(patch_normal);
  tmp_dot = abs(cnt_orien*patch_normal');
  cnt_orien_pdf(i) = sum(tmp_dot>cos(angle_tol))/2/num_cnt/patch_area*4*pi;
  for j=1:4
    vert_tmp = vertices(faces(i,j),:);
    [theta_tmp,phi_tmp,~] = cart2sph(vert_tmp(1),vert_tmp(2),vert_tmp(3));
    [x_tmp,y_tmp,z_tmp] = sph2cart(theta_tmp,phi_tmp,cnt_orien_pdf(i));
    vertices(faces(i,j),:) = [x_tmp,y_tmp,z_tmp];
  end
end

sph_hist.vertices = vertices;
sph_hist.faces = faces;
sph_hist.colors = zeros(size(vertices,1),1);
sph_hist.colors(1:4:end) = cnt_orien_pdf;
sph_hist.colors(2:4:end) = cnt_orien_pdf;
sph_hist.colors(3:4:end) = cnt_orien_pdf;
sph_hist.colors(4:4:end) = cnt_orien_pdf;
sph_hist = sub_sphere_hist(sph_hist);

% -- plot sphere histogram
hold on;
h2 = plot_surf(sph_hist);
set(h2,'facealpha',0.3);








