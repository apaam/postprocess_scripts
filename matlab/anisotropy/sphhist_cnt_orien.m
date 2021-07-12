clc; clear; close all;

% - output setting
out_dir = 'result_figs/';
out_fig = 0;

% - import dem data
in_dir = 'result_data/monotonic_size/case_packing_0p10/post/';
file_list = dir([in_dir,'fc*.dump']);
in_file = [in_dir,file_list(end).name];
tmp_data = importdata(in_file,' ',9);

cnt_orien = tmp_data.data(:,1:3)-tmp_data.data(:,4:6);
cnt_orien_norm = sqrt(sum(cnt_orien.*cnt_orien,2));
cnt_orien = cnt_orien./cnt_orien_norm.*sign(cnt_orien(:,3));

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
figure;
plot_surf(sph_hist);
xlabel('x'); ylabel('y'); zlabel('z');
colorbar; myfiguresize(11,11,'cm');
if out_fig>0
  myprint([out_dir,'sphhist_contact_orien_0p10'],'pdf');
end








