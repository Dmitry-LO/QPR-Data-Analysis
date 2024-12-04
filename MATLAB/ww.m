%% FEATool Multiphysics Version 1.15.4, Build 22.05.128, Model M-Script file.
%% Created on 18-May-2022 14:22:48 with MATLAB 9.3.0.713579 (R2017b) PCWIN64.


%% Starting new model.
fea.sdim = { 'x', 'y', 'z' };
fea.geom = struct;

%% Geometry operations.
gobj = gobj_block( [0], [1], [0], [1], [0], [1], 'B1' );
fea = geom_add_gobj( fea, gobj );

fea.grid = gridgen( fea, 'gridgen', 'default', 'hmax', 0.1, 'grading', 0.3, 'itmax', 650 );

fea.grid = gridgen( fea, 'gridgen', 'default', 'hmax', 0.1, 'grading', 0.3, 'itmax', 650 );


%% Boundary settings.

%% Solver call.

%% Equation settings.

%% Grid operations.

%% Geometry operations.

%% Boundary settings.

%% Geometry operations.
fea = geom_extrude_face( fea, 'B1', 6, 0.5, [0  0  1] );

pdegplot(fea,'CellLabels','on','FaceLabels','on','FaceAlpha',0.5)