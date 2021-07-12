function myprint( filename, style )

% get style sheet info
style_name = 'default'; % The name of your style file (NO extension)
s = hgexport('readstyle', style_name);

if nargin < 2, style = 'pdf'; end

% set(gcf,'color','w');
% set(gca,'FontSize',15,'FontName','Arial');
% set(findall(gcf,'type','text'),'FontSize',15,...
%   'FontName','Arial'); % or Times New Roman, Arial
% set(gca,'LineWidth',0.75);

% apply style sheet info
switch style
  case 'eps'
    filename_ext = [filename,'.eps'];
    s.Format = 'epsc';
    hgexport(gcf, filename_ext, s);
    % system(['~/MyBin/mycommand_epsfix ', filename_ext]);
        
  case 'jpg'
    filename_ext = [filename,'.jpg'];
    s.Format = 'jpeg';
    hgexport(gcf, filename_ext, s);
    
  case 'png'
    filename_ext = [filename,'.png'];
    s.Format = 'png';
    hgexport(gcf, filename_ext, s);
    
  case 'tif'
    filename_ext = [filename,'.tif'];
    s.Format = 'tiff';
    hgexport(gcf, filename_ext, s);
    
  case 'fig'
    filename_ext = [filename,'.fig'];
    saveas(gcf, filename_ext);
    
  case 'pdf'
    filename_ext = [filename,'.pdf'];
    print(gcf,filename_ext,'-dpdf','-r600');
    
  case 'pdf_opengl'
    filename_ext = [filename,'.pdf'];
    print(gcf,filename_ext,'-dpdf','-opengl','-r600');
    
  otherwise
    filename_ext = [filename,'.pdf'];
    print(gcf,filename_ext,'-dpdf','-r600');
end

end



