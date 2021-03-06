function [m, elprop, M, bc, ftrac ] = setup_problem(problem, setupinfo)
%setup problem: creates all the necessary data for a given problem

% Corresponds to an 8 noded brick element with 3 dofs per node


% Setup data for the problems
switch problem
    case 'NavierCheck'
        lx = 1; ly=1; lz = 0.001;
        nelx = 11; nely=11; nelz=1;
        
        %Traction force
        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -1000/(lx*ly)]'};
        
        %angles
        angles = [-15 15];
        
%         angles = setupinfo.angles;
%         M = getInterPolMatrix(setupinfo.M);
        
        %Material properties
        EL = 50E9;     ET = 9E9;    nuLT = 0.22;    GLT = 5E9;  GTT = 3.2E9; 
%         EL = 174.6E9;  ET = 7E9;  nuLT = 0.25;    GLT = 3.5E9;   GTT = 1.4E9; nuTL = ET/EL*nuLT;
%          EL = 100e9;    ET = 100e9; nuLT = 0.3;    GLT = EL/(2*(nuLT+1)); GTT = GLT; 
         
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
        
    case 'WhitneyCheck'
        lx = 1; ly=1; lz = 0.001;
        nelx = 11; nely=11; nelz=1;
        
        %Traction force
        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -1000/(lx*ly)]'};
        
        %angles
        angles = [0 90 0];
        
%         angles = setupinfo.angles;
%         M = getInterPolMatrix(setupinfo.M);
        
        %Material properties
        EL = 50E9;     ET = 9E9;    nuLT = 0.22;    GLT = 5E9;  GTT = 3.2E9; 
%         EL = 174.6E9;  ET = 7E9;  nuLT = 0.25;    GLT = 3.5E9;   GTT = 1.4E9; nuTL = ET/EL*nuLT;
%         EL = 100e9;    ET = 100e9; nuLT = 0.3;    GLT = EL/(2*(nuLT+1)); GTT = GLT; 
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);

    case 'KonsolMedUtbredd'
        
        lx = 1; ly=0.1; lz = 0.01;
        nelx = 11; nely=1; nelz=1;
        
        %Traction force
        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -100/(lx*ly)]',   @(x,y) [100000/(ly*lz) 0 0]'};
        
        %angles
        angles = [0 90];% 90];
        
        %Material properties
        EL = 174.6E9;
        ET = 7E9;
        nuLT = 0.25;
        GLT = 3.5E9;
        GTT = 1.4E9;
        nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
%         D = hooke(4,100e9,0.25);

    case 'KonsolMedUtbredd_stacked'
        lx = 1; ly=0.1; lz = 0.01;
%         nelx = 255; nely=25; nlamel=5;
        nelx = 200; nely=20; nlamel=5;
        
        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -1000/(lx*ly)]', @(x,y) [0 0 -100/(lx*ly)]'};
        
        angles = [0]; aspect = (lx/nelx)/(lz/(nlamel*length(angles)))
        
        nlam = length(angles);
        %Material properties
%         EL = 174.6E9;
%         ET = 7E9;
%         nuLT = 0.25;
%         GLT = 3.5E9;
%         GTT = 1.4E9;
%         nuTL = ET/EL*nuLT;
        
%         D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
         D = hooke(4,100e9,0);
        %independent mesh
        m = Mesh();
        m.create_cube_mesh_stacked_solid_elements(lx,ly,lz,nelx,nely,nlam, nlamel);
        
    case 'InspandPlatta'
        lx = 0.1; ly=0.1; lz = 0.002;
        nelx = 20; nely=20; nelz=1;
%         nelx = 40; nely=40; nelz=1;

        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -5000/(lx*ly)]'};%*sin(pi*y/ly)
        
        angles = [0 90];
        
        %Material properties
        EL = 174.6E9;
        ET = 7E9;
        nuLT = 0.25;
        GLT = 3.5E9;
        GTT = 1.4E9;
        nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);

    case 'Konsol'
        lx = 0.1; ly=0.01; lz = 0.002;
        nelx = 20; nely=1; nelz=1;
        
        tractionInfo.sides = [2];
        tractionInfo.tractions = {@(x,y) [0,0, -50/(lz*ly)]'};
        
        angles = [0];
        
        EL = 174.6E9;
        ET = 7E9;
        nuLT = 0.25;
        GLT = 3.5E9;
        GTT = 1.4E9;
        nuTL = ET/EL*nuLT;
        
%         D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
                D = hooke(4,100e9,0);
        
    case 'MembraneUnsymmetric'
        lx = 0.1; ly=0.01; lz = 0.002;
        nelx = 10; nely=2; nelz=1;
        
        tractionInfo.sides = [2];
        tractionInfo.tractions = {@(x,y) [1000 0 0]'};
        
        angles = [0 0 90 90];
        
        %Material properties
        EL = 174.6E9;
        ET = 7E9;
        nuLT = 0.25;
        GLT = 3.5E9;
        GTT = 1.4E9;
        nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso( EL, ET, nuLT, GLT, GTT );
        
    case 'Konsol_stacked'
        lx = 0.1; ly=0.01; lz = 0.002;
        nelx = 20; nely=1; nlamel=1;
        
        tractionInfo.sides = [2];
        tractionInfo.tractions = {@(x,y) [0 0 -50/(lz*ly)]'};
        
        angles = [0];
        nlam = length(angles);
        D = hooke(4,100e9,0.25);
        
        m = Mesh();
        m.create_cube_mesh_stacked_solid_elements(lx,ly,lz,nelx,nely,nlam, nlamel);    
        
    case 'CurvedBeam'
        inner_radius=4.12; lx = 0.1; thickness = 0.2;  lz = thickness;
        nelr = 1; nelphi=10; nelx=1;
        
        tractionInfo.sides = [3];
        tractionInfo.tractions = {@(x,y) [0 0 -1/(thickness*lx)]'};
        
        angles = [0];  ap = (inner_radius*pi/nelphi)/(thickness/nelr);
        
        nlam = length(angles);
        %Material properties
%         EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9;nuTL = ET/EL*nuLT;
        
%         D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
         D = hooke(4,1e7,0.25);

        %independent mesh
        m = Mesh();
        m.create_quarter_cylinder_mesh(lx, inner_radius, thickness, nelr, nelphi, nelx)
        
    case 'CurvedBeam_stacked'
        inner_radius = 4.12; lx = 0.1; thickness = 0.2; lz = thickness;
        nlamel = 1; nelphi=60; nelx=1;
        
        tractionInfo.sides = [3];
        tractionInfo.tractions = {@(x,y) [0 0 -1/(thickness*lx)]'};%*sin(pi*y/ly)
        
        angles = [0]; 
        
        nlam = length(angles); ap = (inner_radius*pi/nelphi)/(thickness/(nlam*nlamel));
        %Material properties
%         EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9;nuTL = ET/EL*nuLT;
        
%         D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
         D = hooke(4,1e7,0.25);
        
        %independent mesh
        m = Mesh();
        m.create_quarter_cylinder_mesh_stacked_solid_elements(lx,inner_radius,thickness,nlam, nlamel, nelphi, nelx);
        
    case 'InspandPlatta_stacked'
        lx = 0.1; ly=0.1; lz = 0.002;
        nelx = 150; nely=150; nlamel=3;
        nelx = 20; nely=20; nlamel=8;
%         nelx = 3; nely=40; nlamel=8;
        
        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -5000/(lx*ly)]'};%*sin(pi*y/ly)
        
        angles = [0 90];aspect = (lx/nelx)/(lz/(nlamel*length(angles)))
        
        nlam = length(angles);
        %Material properties
        EL = 174.6E9;
        ET = 7E9;
        nuLT = 0.25;
        GLT = 3.5E9;
        GTT = 1.4E9;
        nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
        
        %independent mesh
        m = Mesh();
        m.create_cube_mesh_stacked_solid_elements(lx,ly,lz,nelx,nely,nlam, nlamel);
        
    case 'HybridStress2'
        lx = 1; ly=0.25; lz = 0.025;
        nelx = 110; nely=1; nelz=1;

        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -1000*sin(pi*x/lx)]'};
        
        angles = [0 90 0]; aspect = (lx/nelx)/(lz/nelz)
        
        %Material properties
        EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9; nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
%         D = hooke(4,100e9,0.25);

    case 'HybridStress2_stacked'
        lx = 1; ly=0.25; lz = 0.025;
        nelx = 110; nely=1; nlamel=10;

        tractionInfo.sides = [5];   
        tractionInfo.tractions = {@(x,y) [0 0 -1000*sin(pi*x/lx)]'};
        
        angles = [0 90 0]; aspect = (lx/nelx)/(lz/(nlamel*length(angles)))
        
        %Material properties
        EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9; nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
%         D = hooke(4,100e9,0.25);
        
        nlam = length(angles);

        m = Mesh();
        m.create_cube_mesh_stacked_solid_elements(lx,ly,lz,nelx,nely,nlam, nlamel);
        
    case 'HybridStress2_plate'
        lx = 0.1; ly=0.1; lz = 0.01;
        nelx = 61; nely=61; nelz=1;

        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -1000]'}; %*sin(pi*x/lx)*sin(pi*y/ly)
        
        angles = [90 -45 45 0]; aspect = (lx/nelx)/(lz/nelz);
        
        %Material properties
        EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9; nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
%         D = hooke(4,100e9,0.25);

    case 'HybridStress2_plate_stacked'
        lx = 0.1; ly=0.1; lz = 0.01;
        nelx = 61; nely=61; nlamel=5;

        tractionInfo.sides = [5];   
        tractionInfo.tractions = {@(x,y) [0 0 -1000]'};%*sin(pi*x/lx)*sin(pi*y/ly)
        
        angles = [90 -45 45 0]; aspect = (lx/nelx)/(lz/(nlamel*length(angles)))
        
        %Material properties
        EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9; nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
%         D = hooke(4,100e9,0.25);
        
        nlam = length(angles);

        m = Mesh();
        m.create_cube_mesh_stacked_solid_elements(lx,ly,lz,nelx,nely,nlam, nlamel);
        
    case 'HybridStress2_sym_plate'
        lx = 0.1/2; ly=0.1/2; lz = 0.001;
        nelx = 30; nely=30; nelz=1;

        tractionInfo.sides = [5];
        tractionInfo.tractions = {@(x,y) [0 0 -1000]'}; %*sin(pi*x/lx)*sin(pi*y/ly)
        
        angles = [90 -45 45 0]; aspect = (lx/nelx)/(lz/nelz);
        
        %Material properties
        EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9; nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
%         D = hooke(4,100e9,0.25);

    case 'HybridStress2_sym_plate_stacked'
        lx = 0.1; ly=0.1; lz = 0.005;
        nelx = 30; nely=101; nlamel=5;

        tractionInfo.sides = [5];   
        tractionInfo.tractions = {@(x,y) [0 0 -1000]'};%*sin(pi*x/lx)*sin(pi*y/ly)
        
        angles = [90 -45 45 0]; aspect = (lx/nelx)/(lz/(nlamel*length(angles)))
        
        %Material properties
        EL = 174.6E9;ET = 7E9;nuLT = 0.25;GLT = 3.5E9;GTT = 1.4E9; nuTL = ET/EL*nuLT;
        
        D = hooke_trans_iso(EL, ET, nuLT, GLT, GTT);
%         D = hooke(4,100e9,0.25);
        
        nlam = length(angles);

        m = Mesh();
        m.create_cube_mesh_stacked_solid_elements(lx,ly,lz,nelx,nely,nlam, nlamel);
    otherwise
        error('Unknown problem type')
end

% Create element properties
elprop = ElementProperties();
elprop.setup(lz, angles, D);

% Create mesh
if ~(exist('m','var'))
m = Mesh();
m.create_cube_mesh(lx,ly,lz,nelx,nely,nelz);
end

% Interpolation matrix
if ~(exist('M','var'))
M = getInterPolMatrix(1);
end

% Load and boundary conditions
bc = cubeBC(problem, m.dof, m.sideElements);

ftrac = zeros(m.ndofs,1);
%setup traction-force-vector
for iside = 1:length(tractionInfo.sides)
    cSideIndex = tractionInfo.sides(iside);
    cSideNodes = m.sideElements(cSideIndex).nodes;
    cSideElements = m.sideElements(cSideIndex).elements;
    
    cTraction =  tractionInfo.tractions{iside};
    
    for ii = 1:size(cSideNodes,2)
        
        sideNodes = cSideNodes(:,ii);
        
        %Simple hack to get to only get for nodes (Needed if
        %"stacked" element is used)
        sideNodes = sideNodes([1 2 end-1, end]);
        
        ncoords = m.coord(:,sideNodes);
        ex = ncoords(1,:); ey = ncoords(2,:); ez = ncoords(3,:);
        
        switch cSideIndex
            case 1
                e1 = ey; e2 = ez;
            case 2
                e1 = ey; e2 = ez;
            case 3
                e1 = ex; e2 = ez;
            case 4
                e1 = ex; e2 = ez;
            case 5
                e1 = ex; e2 = ey;
                case 6
                e1 = ex; e2 = ey;
        end
        
%         sideDofs = m.dof(cSideNodes(:,ii),1:3)';
        sideDofs = m.dof(sideNodes,1:3)';
        sideDofs = sideDofs(:);
        
        cElement = cSideElements(ii);
        %         feltrac = solid8trac(e1,e2,[0,0,-50/(lx*ly)]',1);
        feltrac = solid8traction(e1,e2,cTraction,3);
        
        ftrac(sideDofs) = ftrac(sideDofs) + feltrac;
    end
    
end

