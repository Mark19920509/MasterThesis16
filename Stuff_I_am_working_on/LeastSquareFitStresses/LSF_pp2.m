

%mesh and edof for stresses
[ips_sedof,~,~,~,~,~,~,~,~,ips_mesh,~] = cubeMesher(1,1,1,mesh.nelx,mesh.nely,mesh.nelz, 2,2,2, 3);
[tau_sedof,~,~,~,~,~,~,~,~,tau_mesh,~] = cubeMesher(1,1,1,mesh.nelx,mesh.nely,mesh.nelz, 2,2,3, 2);

%Number of laminates
nLam = el(1).elprop.nLam;

%smear stresses to nodes
ips_a = smearInPlaneStressesToNodes(mesh, el, a);

%Get postprocessed shear stresses
clear tau_xz tau_yz
es_xz = zeros(3,mesh.nel,nLam); es_yz = zeros(3,mesh.nel,nLam);
for iel=1:mesh.nel
    input = zeros(size(ips_sedof,1), nLam);
    for ilay=1:nLam
        temp = ips_a(:,ilay);
        ips_es = temp(ips_sedof);
        input(:,ilay) =ips_es(:,iel);
    end
    [tau_xz(:,iel), tau_yz(:,iel)] = el(iel).ShearStressesPostProcess(input, 'shear'); 
    for ilay=1:nLam
        ind = (1:3) + 2*(ilay-1);
        es_xz(:,iel,ilay) = tau_xz(ind,iel);
        es_yz(:,iel,ilay) = tau_yz(ind,iel);
    end
end

as_xz = smearToNodes_MultipleLayers(tau_mesh, es_xz, 3);
as_yz = smearToNodes_MultipleLayers(tau_mesh, es_yz, 3);

tau_a = zeros(max(max(tau_sedof)), el(1).elprop.nLam);
tau_a(1:2:end,:) = as_xz; tau_a(2:2:end,:) = as_yz;

%Post process normal stress in transverse direction
clear sig_zz
es_zz = zeros(4,mesh.nel,nLam);
for iel=1:mesh.nel
    input = [];
    for ilay=1:el(1).elprop.nLam
        temp = tau_a(:,ilay);
        tau_es = temp(tau_sedof);
        input = [input, tau_es(:,iel)];
    end
    sig_zz(:,iel) = el(iel).NormalStressPostProcess(input); 
    for ilay=1:nLam
        ind = (1:4) + 3*(ilay-1);
        es_zz(:,iel,ilay) = sig_zz(ind,iel);
    end
end


%%Plot
plotEl = [5];
for iel = plotEl
    zpoints_local = linspace(-1,1,20);
    zpoints_global = linspace(0,mesh.lz,20);
    thicknessInterpolator = InterpolatorX2; tauInterp = InterpolatorX3; sigzzInterp = InterpolatorX4;
    zitr = 1;
    for ilay = 1:nLam
        for iz = 1:length(zpoints_local)
            plot_tauxz(zitr) = tauInterp.eval_N(zpoints_local(iz))*es_xz(:,iel,ilay);
            plot_tauyz(zitr) = tauInterp.eval_N(zpoints_local(iz))*es_yz(:,iel,ilay);
            plot_sigzz(zitr) = sigzzInterp.eval_N(zpoints_local(iz))*es_zz(:,iel,ilay);
            plot_zz(zitr) = thicknessInterpolator.eval_N(zpoints_local(iz))*el(iel).elprop.lamZCoordsG(:,ilay);
            zitr = zitr + 1;
            
        end
    end
    
    figure
    title('\sigma_{xz}')
    plot(plot_tauxz, plot_zz,'k');
    xlabel('Thickness'); ylabel('\sigma')
    
    figure
    title('\sigma_{zz}')
    plot(plot_sigzz, plot_zz,'k');
    xlabel('Thickness'); ylabel('\sigma')
end


% return
% as = smearStrainsToNodes(mesh, el, a);
% es = as(sedof);
% el(postEl).postProcess2(es(:,postEl))



% sdim = 3;
% sedof = zeros(sdim*8,mesh.nel);
% sdof = reshape(1:mesh.nno*sdim,sdim,mesh.nno)';
% for i=1:mesh.nel
%     m = sdof(mesh.nomesh(:,i),:)'; m = m(:);
%     sedof(:,i) = m;
% end

