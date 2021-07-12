function data_cell = ev_mesh_atom(cell_list,data_atom,wall_bound)
% cell_list is patch data layout, i.e. contains vertices and faces
% wall_bound is mx6 matrix, m is the number of walls, each wall is 
%   representd by a point in wall (1:3), and normal direction (4:6) 

rad_sphere = 0.0005;
vol_sphere = pi/6*(rad_sphere*2)^3;

rad_measure = 0.005;
vol_measure_ref = pi/6*(rad_measure*2)^3;

num_cell = size(cell_list.faces,1);
data_cell.porosity = zeros(num_cell,1);
data_cell.stress = zeros(num_cell,3);

for ic = 1:num_cell
  nodes = cell_list.vertices(cell_list.faces(ic,:),:);
  center_pos = mean(nodes,1);
  tmp = data_atom.points-center_pos;
  id_atom_in_cell = sum(tmp.^2,2)<=rad_measure^2;
  
  vol_measure = vol_measure_ref;
  for iw = 1:size(wall_bound,1)
    wall_pos = wall_bound(iw,1:3);
    wall_norm = wall_bound(iw,4:6)/norm(wall_bound(iw,4:6));
    dist = abs(dot(center_pos-wall_pos,wall_norm));
    if dist<rad_measure
      vol_measure = vol_measure-ev_vol_cap(rad_measure,rad_measure-dist);
    end
  end

  data_cell.porosity(ic) = 1-sum(id_atom_in_cell)*vol_sphere/vol_measure;
end





