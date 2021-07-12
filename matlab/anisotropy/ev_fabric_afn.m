function [a_fn,a_fn_tensor,fn_bar] = ev_fabric_afn(fn_mag,cnt_orien)

[~,ac_tensor] = ev_fabric_ac(cnt_orien);

phi_fn_tensor = zeros(3,3);
fn_bar = 0;
for i=1:size(cnt_orien,1)
  cnt_pdf = (1+cnt_orien(i,:)*ac_tensor*cnt_orien(i,:)')/4/pi;
  phi_fn_tensor = phi_fn_tensor...
    +(fn_mag(i)*cnt_orien(i,:)'*cnt_orien(i,:))/4/pi/cnt_pdf;
  fn_bar = fn_bar+fn_mag(i)/4/pi/cnt_pdf;
end
phi_fn_tensor = phi_fn_tensor/size(cnt_orien,1);
fn_bar = fn_bar/size(cnt_orien,1);

phi_fn_tensor_p = sum(diag(phi_fn_tensor))/3;
phi_fn_tensor_div = phi_fn_tensor-phi_fn_tensor_p*eye(3,3); 
a_fn_tensor = 15/2*phi_fn_tensor_div/fn_bar;
a_fn = sqrt(3/2*sum(a_fn_tensor(:).*a_fn_tensor(:)));

end