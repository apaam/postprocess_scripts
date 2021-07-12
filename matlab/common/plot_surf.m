function [hiso] = plot_surf(v_iso)

if isempty(v_iso.vertices)
  disp('no patches found');
  return;
end

% plot surface
hiso = patch('vertices',v_iso.vertices,'faces',v_iso.faces,...
  'linestyle','-','faceLighting','gouraud','faceColor','interp');

hiso.FaceVertexCData = v_iso.colors;
hiso.AlignVertexCenters = 'on';
hiso.DiffuseStrength = 0.3;
hiso.AmbientStrength = 0.5;
hiso.FaceColor = 'interp';
hiso.FaceAlpha = 1.0;
hiso.EdgeColor = [0.0,0.0,0.0];
hiso.EdgeAlpha = 1.0;

hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 15;
hiso.SpecularStrength = 0.1;

% figure settings
colormap default;
view(135,30); axis vis3d; daspect([1,1,1]);

% light('Position',[0 0 1],'Style','infinite');
% light('Position',[-1 -1 -1],'Style','infinite');
% light('Position',[1 1 1],'Style','infinite');
box on; grid on;

end

