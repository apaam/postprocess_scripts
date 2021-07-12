function v_iso_hist = sub_sphere_hist(v_iso)

v_iso_hist.vertices = [v_iso.vertices;[0,0,0]];
v_iso_hist.colors = [v_iso.colors;0];
v_iso_hist.faces = zeros(size(v_iso.faces,1)*5,4);

num_vert = size(v_iso_hist.vertices,1);
for i=1:size(v_iso.faces,1)
  v_iso_hist.faces(i*5-5+1,:) = v_iso.faces(i,:);
  v_iso_hist.faces(i*5-5+2,:) = [num_vert,v_iso.faces(i,[1,4]),num_vert];
  v_iso_hist.faces(i*5-5+3,:) = [num_vert,v_iso.faces(i,[2,1]),num_vert];
  v_iso_hist.faces(i*5-5+4,:) = [num_vert,v_iso.faces(i,[3,2]),num_vert];
  v_iso_hist.faces(i*5-5+5,:) = [num_vert,v_iso.faces(i,[4,3]),num_vert];
end

end