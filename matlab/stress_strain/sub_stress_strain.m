function [sig_x,sig_y,sig_z,len_x,len_y,len_z] ...
  = sub_stress_strain(in_dir,id_cycs)

num_steps = numel(id_cycs);
sig_x = zeros(1,num_steps);
sig_y = zeros(1,num_steps);
sig_z = zeros(1,num_steps);

len_x = zeros(1,num_steps);
len_y = zeros(1,num_steps);
len_z = zeros(1,num_steps);

parfor i=1:num_steps
  id_cyc = id_cycs(i);
  
  tmp_data = myvtk_read(sprintf(...
    '%s/contact/contact_000_%015u.vtk',in_dir,id_cyc));
  
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
    '%s/wall/wall_000_%015u.vtk',in_dir,id_cyc));
  
  sig_x(i) ...
    = abs(tmp_data.force(1,1)-tmp_data.force(2,1))/2/len_y(i)/len_z(i);
  sig_y(i) ...
    = abs(tmp_data.force(3,2)-tmp_data.force(4,2))/2/len_x(i)/len_z(i);
  sig_z(i) = abs(tmp_data.force(6,3))/len_x(i)/len_y(i);
  
  fprintf('Finished %03u ...\n',i);
end





