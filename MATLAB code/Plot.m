%%%%% Surface plots can be plotted here %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%surf(BETA,ALPHA,group11)
figure
%surfc(BETA,ALPHA,group11)
%surfc(BETA,ALPHA,group22)
%surfc(BETA,ALPHA,group44)
surfc(BETA,ALPHA,group44)
% Adjust the view angle
view(60, 22)

% Add title and axis labels
%title('3D Plot of F-measure VS \alpha and \beta')
%title('3D Plot of Recall VS \alpha and \beta')
title('3D Plot of Precision VS \alpha and \beta')
xlabel('\beta')
ylabel('\alpha')
zlabel('F-measure')