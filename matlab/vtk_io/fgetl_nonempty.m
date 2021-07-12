function tline = fgetl_nonempty(fid)

tline = strtrim(fgetl(fid));
while isempty(tline)
  tline = strtrim(fgetl(fid));
end

end