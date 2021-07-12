function data_patch = sub_vtk_data_patch(fid,num_elem,num_vals)

data_patch = zeros(num_elem,num_vals);

id_elem = 1;
id_vals = 0;

tline = fgetl_nonempty(fid);
while ischar(tline)
  tmp = split(tline);
  
  % cast the data of line into the atom array
  for i=1:numel(tmp)
    id_vals = id_vals+1;
    if id_vals>num_vals
      id_elem = id_elem+1;
      id_vals = id_vals-num_vals;
    end
    
    data_patch(id_elem,id_vals) = str2double(tmp{i});
  end
  
  if id_elem~=num_elem || id_vals~=num_vals
    tline = fgetl_nonempty(fid);
  else
    break;
  end
end

end

