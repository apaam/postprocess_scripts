clc; clear; close all;

out_flag = 0;
out_dir = 'result_figs/';
in_dir = 'data/netdem/';

num_steps = 1;
sig_x = zeros(1,num_steps);
sig_y = zeros(1,num_steps);
sig_z = zeros(1,num_steps);

len_x = zeros(1,num_steps);
len_y = zeros(1,num_steps);
len_z = zeros(1,num_steps);

parfor i=1:num_steps
  num_cyc = (i+40-1)*10000;
  
  tmp_data = myvtk_read(sprintf(...
    '%s/contact/contact_000_%015u.vtk',in_dir,num_cyc));
  
  min_x = min(tmp_data.points(:,1));
  min_y = min(tmp_data.points(:,2));
  min_z = min(tmp_data.points(:,3));
  max_x = max(tmp_data.points(:,1));
  max_y = max(tmp_data.points(:,2));
  max_z = max(tmp_data.points(:,3));
  
  len_x(i) = max_x-min_x;
  len_y(i) = max_y-min_y;
  len_z(i) = max_z-min_z;
  
  tmp_data = myvtk_read(sprintf(...
    '%s/wall/wall_000_%015u.vtk',in_dir,num_cyc));
  
  sig_x(i) ...
    = abs(tmp_data.force(1,1)-tmp_data.force(2,1))/2/len_y(i)/len_z(i);
  sig_y(i) ...
    = abs(tmp_data.force(3,2)-tmp_data.force(4,2))/2/len_x(i)/len_z(i);
  sig_z(i) = abs(tmp_data.force(6,3))/len_x(i)/len_y(i);
  
  fprintf('Finished %03u ...\n',i);
end

% calculations
strain_axial = log(len_z(1)./len_z);
strain_vol = log(len_x(1)*len_y(1)*len_z(1)./len_x./len_y./len_z);
stress_p = (sig_x+sig_y+sig_z)/3;
stress_q = sqrt(3/2)*sqrt(...
  (sig_x-stress_p).^2+(sig_y-stress_p).^2+(sig_z-stress_p).^2);

% plot stress
figure; hold on;
plot(1:num_steps,sig_x/1e6,'-o',...
  'linewidth',2.0,'markerindices',1:10:num_steps,'markersize',7.0);
plot(1:num_steps,sig_y/1e6,'-s',...
  'linewidth',2.0,'markerindices',1:10:num_steps,'markersize',7.0);
plot(1:num_steps,sig_z/1e6,'-s',...
  'linewidth',2.0,'markerindices',1:10:num_steps,'markersize',7.0);
xlabel('Step');
ylabel('Stresses [MPa]');
legend('Lateral-x','Lateral-y','Axial-z',...
  'edgecolor','none','location','best');
myfiguresize(16,12,'cm');
if out_flag>0
  myprint([out_dir,'stress_step'],'pdf');
end

% plot q vs strain
figure; hold on;
plot(strain_axial*100,stress_q./stress_p,'-o',...
  'linewidth',2.0,'markerindices',1:10:num_steps,'markersize',7.0);
xlabel('Axial strain [%]');
ylabel('Deviatroic stress ratio');
myfiguresize(16,12,'cm');
if out_flag>0
  myprint([out_dir,'q_strain'],'pdf');
end

% plot q vs p
figure; hold on;
plot(stress_p/1e6,stress_q/1e6,'-o',...
  'linewidth',2.0,'markerindices',1:10:num_steps,'markersize',7.0);
xlabel('Mean effective stress [MPa]');
ylabel('Deviatroic stress [MPa]');
myfiguresize(16,12,'cm');
if out_flag>0
  myprint([out_dir,'q_p'],'pdf');
end

% plot vol strain vs axial strain
figure; hold on;
plot(strain_axial*100,strain_vol*100,'-o',...
  'linewidth',2.0,'markerindices',1:10:num_steps,'markersize',7.0);
xlabel('Axial strain [%]');
ylabel('Volumetric strain [%]');
set(gca, 'YDir','reverse')
myfiguresize(16,12,'cm');
if out_flag>0
  myprint([out_dir,'vol_axial_strain'],'pdf');
end










