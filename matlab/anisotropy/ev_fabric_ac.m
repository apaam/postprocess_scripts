function [ac,ac_tensor] = ev_fabric_ac(cnt_orien)

phi_ac_tensor = zeros(3,3);
for i=1:size(cnt_orien,1)
  phi_ac_tensor = phi_ac_tensor+cnt_orien(i,:)'*cnt_orien(i,:);
end
phi_ac_tensor = phi_ac_tensor/size(cnt_orien,1);

phi_ac_tensor_p = sum(diag(phi_ac_tensor))/3;
phi_ac_tensor_div = phi_ac_tensor-phi_ac_tensor_p*eye(3,3); 
ac_tensor = 15/2*phi_ac_tensor_div;
ac = sqrt(3/2*sum(ac_tensor(:).*ac_tensor(:)));

end