clc; clear; close all;

% - output setting
out_dir = 'result_figs/';
out_fig = 0;

% - import dem data
in_dir = 'result_data/monotonic_size/case_packing_0p10/post/';
file_list = dir([in_dir,'fc*.dump']);
in_file = [in_dir,file_list(1).name];
tmp_data = importdata(in_file,' ',9);

cnt_orien = tmp_data.data(:,1:3)-tmp_data.data(:,4:6);
cnt_orien_norm = sqrt(sum(cnt_orien.*cnt_orien,2));
cnt_orien = cnt_orien./cnt_orien_norm;

fc = tmp_data.data(:,7:9);
fn = tmp_data.data(:,10:12);
ft = tmp_data.data(:,13:15);

fc_mag = sqrt(sum(fc.*fc,2));
fn_mag = sqrt(sum(fn.*fn,2));
ft_mag = sqrt(sum(ft.*ft,2));

fc_mag_ave = mean(fc_mag);

tan_orien = ft./ft_mag;
[a_ft,a_ft_tensor,fn_bar] ...
  = ev_fabric_aft(ft_mag,fn_mag,tan_orien,cnt_orien);

id_comp = 1;

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
figure;
plot_surf(sph_hist);
xlabel('x'); ylabel('y'); zlabel('z');
colorbar; myfiguresize(11,11,'cm');
if out_fig>0
  myprint([out_dir,'sphhist_force_t_0p10'],'pdf');
end






