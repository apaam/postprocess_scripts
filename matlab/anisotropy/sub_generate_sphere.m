function [vertices,faces] = sub_generate_sphere(res)

vertices = zeros(res*res*6*4,3);
faces = zeros(res*res*6,4);

x = linspace(-1,1,res+1);
y = linspace(-1,1,res+1);

num_faces = 0;
for i=1:res
  for j=1:res
    num_faces = num_faces+1;
    faces(num_faces,:) = (num_faces-1)*4+[1,2,3,4];
    vertices(faces(num_faces,:),:) = [...
      x(i),y(j),-1;...
      x(i+1),y(j),-1;...
      x(i+1),y(j+1),-1;...
      x(i),y(j+1),-1];
  end
end

for i=1:res
  for j=1:res
    num_faces = num_faces+1;
    faces(num_faces,:) = (num_faces-1)*4+[1,2,3,4];
    vertices(faces(num_faces,:),:) = [...
      x(i),y(j),1;...
      x(i+1),y(j),1;...
      x(i+1),y(j+1),1;...
      x(i),y(j+1),1];
  end
end

for i=1:res
  for j=1:res
    num_faces = num_faces+1;
    faces(num_faces,:) = (num_faces-1)*4+[1,2,3,4];
    vertices(faces(num_faces,:),:) = [...
      x(i),-1,y(j);...
      x(i+1),-1,y(j);...
      x(i+1),-1,y(j+1);...
      x(i),-1,y(j+1)];
  end
end

for i=1:res
  for j=1:res
    num_faces = num_faces+1;
    faces(num_faces,:) = (num_faces-1)*4+[1,2,3,4];
    vertices(faces(num_faces,:),:) = [...
      x(i),1,y(j);...
      x(i+1),1,y(j);...
      x(i+1),1,y(j+1);...
      x(i),1,y(j+1)];
  end
end

for i=1:res
  for j=1:res
    num_faces = num_faces+1;
    faces(num_faces,:) = (num_faces-1)*4+[1,2,3,4];
    vertices(faces(num_faces,:),:) = [...
      -1,x(i),y(j);...
      -1,x(i+1),y(j);...
      -1,x(i+1),y(j+1);...
      -1,x(i),y(j+1)];
  end
end

for i=1:res
  for j=1:res
    num_faces = num_faces+1;
    faces(num_faces,:) = (num_faces-1)*4+[1,2,3,4];
    vertices(faces(num_faces,:),:) = [...
      1,x(i),y(j);...
      1,x(i+1),y(j);...
      1,x(i+1),y(j+1);...
      1,x(i),y(j+1)];
  end
end

for i=1:size(vertices,1)
  [theta,phi,~] = cart2sph(vertices(i,1),vertices(i,2),vertices(i,3));
  [vertices(i,1),vertices(i,2),vertices(i,3)] = sph2cart(theta,phi,1);
end

end




