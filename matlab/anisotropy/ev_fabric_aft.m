function [a_ft,a_ft_tensor,fn_bar] ...
  = ev_fabric_aft(ft_mag,fn_mag,tan_orien,cnt_orien)

[~,ac_tensor] = ev_fabric_ac(cnt_orien);

phi_ft_tensor = zeros(3,3);
fn_bar = 0;
for i=1:size(cnt_orien,1)
  cnt_pdf = (1+cnt_orien(i,:)*ac_tensor*cnt_orien(i,:)')/4/pi;
  phi_ft_tensor = phi_ft_tensor...
    +(ft_mag(i)*tan_orien(i,:)'*cnt_orien(i,:))/4/pi/cnt_pdf;
  fn_bar = fn_bar+fn_mag(i)/4/pi/cnt_pdf;
end
phi_ft_tensor = phi_ft_tensor/size(cnt_orien,1);
fn_bar = fn_bar/size(cnt_orien,1);

phi_ft_tensor_p = sum(diag(phi_ft_tensor))/3;
phi_ft_tensor_div = phi_ft_tensor-phi_ft_tensor_p*eye(3,3); 
a_ft_tensor = 15/3*phi_ft_tensor_div/fn_bar;
a_ft = sqrt(3/2*sum(a_ft_tensor(:).*a_ft_tensor(:)));

end