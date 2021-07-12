function data_point = ev_point_atom(point_list,data_atom,wall_bound)
% point_list is mx3
% wall_bound is mx6 matrix, m is the number of walls, each wall is
%   representd by a point in wall (1:3), and normal direction (4:6)

rad_sphere = 0.0005;
vol_sphere = pi/6*(rad_sphere*2)^3;

rad_measure = 0.005;
vol_measure_ref = pi/6*(rad_measure*2)^3;

num_point = size(point_list,1);
data_point.porosity = zeros(num_point,1);
data_point.stress = zeros(num_point,6);
data_point.pos = zeros(num_point,3);
data_point.vel = zeros(num_point,3);

for ip = 1:num_point
  center_pos = point_list(ip,:);
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
  
  data_point.pos(ip,:) = center_pos;
  data_point.porosity(ip) = 1-sum(id_atom_in_cell)*vol_sphere/vol_measure;
  if isfield(data_atom,'c_stress13')
    data_point.stress(ip,1:3) ...
      = sum(data_atom.c_stress13(id_atom_in_cell,:),1)/vol_measure;
    data_point.stress(ip,4:6) ...
      = sum(data_atom.c_stress46(id_atom_in_cell,:),1)/vol_measure;
  end
  data_point.vel(ip,:) ...
    = sum(data_atom.v(id_atom_in_cell,:),1)/sum(id_atom_in_cell);
end





