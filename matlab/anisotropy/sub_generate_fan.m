function fan_patch = sub_generate_fan(...
  rad_inner,rad_outer,angle_right,angle_left,num_layer)

cell_width = (rad_outer-rad_inner)/num_layer;
cell_id = 0;
cell_vertices = zeros(5000,2);
cell_faces = zeros(5000,4);
fan_angle = angle_left-angle_right;
for i=1:num_layer
  rad_1 = rad_inner+cell_width*(i-1);
  rad_2 = rad_inner+cell_width*i;
  peri = fan_angle*rad_1;
  
  num_col = ceil(peri/cell_width);
  angle_step = fan_angle/num_col;
  
  for j=1:num_col
    cell_id = cell_id+1;
    
    angle_1 = angle_right+angle_step*(j-1);
    angle_2 = angle_right+angle_step*j;
    node_1 = rad_1*[cos(angle_1),sin(angle_1)];
    node_2 = rad_2*[cos(angle_1),sin(angle_1)];
    node_3 = rad_2*[cos(angle_2),sin(angle_2)];
    node_4 = rad_1*[cos(angle_2),sin(angle_2)];
    
    cell_vertices(cell_id*4+[-3,-2,-1,0],:) = [node_1;node_2;node_3;node_4];
    cell_faces(cell_id,:) = cell_id*4+[-3,-2,-1,0];
  end
end
cell_vertices(cell_vertices(:,2)==0,:) = [];
cell_faces(cell_faces(:,1)==0,:) = [];

fan_patch.vertices = cell_vertices;
fan_patch.faces = cell_faces;
end





