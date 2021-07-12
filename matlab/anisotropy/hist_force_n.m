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

[a_fn,a_fn_tensor,fn_bar] = ev_fabric_afn(fn_mag,cnt_orien);

% - calculate sphere histogram
res = 10; angle_tol = sqrt(4*pi/(6*res^2))/2;
[vertices,faces] = sub_generate_sphere(res);
num_cnt = size(cnt_orien,1);
fn_patch = zeros(size(faces,1),1);
for i=1:size(faces,1)
  patch_normal = mean(vertices(faces(i,:),:),1);
  patch_normal = patch_normal/norm(patch_normal);
  tmp_id = abs(cnt_orien*patch_normal')>cos(angle_tol);
  fn_patch(i) = sum(fn_mag(tmp_id))/sum(tmp_id)/fn_bar;
  for j=1:4
    vert_tmp = vertices(faces(i,j),:);
    [theta_tmp,phi_tmp,~] = cart2sph(vert_tmp(1),vert_tmp(2),vert_tmp(3));
    [x_tmp,y_tmp,z_tmp] = sph2cart(theta_tmp,phi_tmp,fn_patch(i));
    vertices(faces(i,j),:) = [x_tmp,y_tmp,z_tmp];
  end
end

sph_hist.vertices = vertices;
sph_hist.faces = faces;
sph_hist.colors = zeros(size(vertices,1),1);
sph_hist.colors(1:4:end) = fn_patch;
sph_hist.colors(2:4:end) = fn_patch;
sph_hist.colors(3:4:end) = fn_patch;
sph_hist.colors(4:4:end) = fn_patch;
sph_hist = sub_sphere_hist(sph_hist);

% -- plot sphere histogram
figure;
plot_surf(sph_hist);
xlabel('x'); ylabel('y'); zlabel('z');
colorbar; myfiguresize(12,9,'cm');
annotation(gcf,'textbox',[0.8,0.88,0.74,0.13],'linestyle','none',...
  'string',{'$f_n/\bar{f}_n$'},'fontsize',15,'fitboxtotext','off',...
  'interpreter','latex');
if out_fig>0
  myprint([out_dir,'hist_fn_gjk_epa'],'pdf');
end






