% simulation parameters
TFINAL = 10;
NSTEPS = 50;
NARENA = 50;

% agent parameters
K = 5;
RANDOM_AGENTS = 10;     % # of randomly generated agents scattered on 
                        % [-K,K]^2, if RANDOM_AGENTS = 0, then positions 
                        % at t = 0 is given by lloyds_input.csv

RCOM = 3.0;             % radius of communication used by all agents
ROBS = 3.2;             % radius of observation used by all agents
INIT_ENERGY = 100;       % initial "energy" stored in each agent

% plot toggles - set to 0 to suppress plot
SHOW_DENSITY = 1;       % 3D plot of density surface at TFINAL
SHOW_ARENA = 1;         % 2D contour plot showing agent paths
SHOW_POSITION = 1;      % position vs time plot
SHOW_ENERGY = 1;        % energy vs time plot

%% SETUP

% defining arena

xarena = linspace(-K, K, NARENA);
yarena = linspace(-K, K, NARENA);
[X,Y] = meshgrid(xarena, yarena);

% importing initial values -----------------------------------------------
if (RANDOM_AGENTS == 0)
    initval = readmatrix('lloyds_input.csv');  
    nagents = length(initval);
else
   nagents = RANDOM_AGENTS;
    % Initialize agents randomly within a 1 by 1 matrix in the middle
    initval = [0.5*(1 - 2 * rand(nagents, 1)) / 2, 0.5*(1 - 2 * rand(nagents, 1)) / 2];
end
% pre-allocation & initialization -----------------------------------------
D = nan(NARENA, NARENA, NSTEPS-1);  % all density data
% D(:,:,i) are the arena densities for the i-th timestep

P = nan(NSTEPS, nagents, 2);        % all position data 
for i = 1:2
    P(:,:,i) = ones(NSTEPS, 1) * initval(:,i)';
end
% P(i,j,k) is agent-j's k-position (x=1, y=2) at the i-th timestep

Pdot = zeros(NSTEPS-1, nagents, 2);
% Pdot(i,j,k) is agent-j's k-velocity (x=1, y=2) at the i-th timestep

E = INIT_ENERGY * ones(NSTEPS, nagents);          % all energy data
% E(i,j) is agent-j's energy at the i-th timestep

G = nan(nagents, nagents, NSTEPS-1);  % all network data 
% G(:,:,i) is the adjacentcy matrix at the i-th timestep


%% SIMULATION
idx = 1:nagents;                    % vector of indices for agents
t = linspace(0,TFINAL,NSTEPS)';    
tstep = t(2);

for i = 1:NSTEPS-1

    % ============================================================= WEEK 7 
    % compute a meshgrid of densities used for weighting agent position
    D(:,:,i) = density_map(X,Y); 

    % packaging position data for easy use
    p0 = [P(i,:,1)' P(i,:,2)'];     
    
    % ============================================================= WEEK 8 
    % identifying which agents communicate with one another
    G(:,:,i) = lloyds_adjacency_matrix(p0, RCOM); 

    % identifying observation sets
    graph_components = conncomp(graph(G(:,:,i),'omitselfloops'));

    for j = 1:max(graph_components)
        % get positions of all agents in observation set
        set_idx = idx(graph_components == j);
        nobset = length(set_idx);
        p0_set = nan(nobset,2);
        for k = 1:nobset
            p0_set(k,:) = p0(set_idx(k),:);
        end

        % ========================================================= WEEK 9 
        % getting all weighted position data in obs set
        set_data = observation_set(p0_set, X, Y, D(:,:,i), ROBS);

        % see Eq. 14 of the course manual
        [~, p1_set] = kmeans(set_data, [], 'Start', p0_set);

        % saving new positions for plotting/contraining movements
        for k = 1:nobset
            for m = 1:2
                P(i+1,set_idx(k),m) = p1_set(k,m);
            end
        end
    end

    % calculating velocity
    Pdot(i,:,:) = (P(i+1,:,:) - P(i,:,:)) / tstep;    

    % ============================================================= WEEK 10
    % Adjusting positions for velocity/energy constraints
    [P(i+1,:,:), E(i+1,:)] = move_agents(P(i,:,:), Pdot(i,:,:), E(i,:), tstep);

end

%% PLOTTING
% note that the density at tfinal is used for the plots


if (SHOW_DENSITY)
    figure 
    surf(X,Y,D(:,:,end));
end

if (SHOW_ARENA) 
    my_colours = ["#FF0000", "#00FF00", "#0000FF", "#00FFFF", ...
    "#FF00FF", "#FFFF00", "#0072BD", "#D95319", "#EDB120", ...
    "#7E2F8E", "#77AC30", "#4DBEEE", "#A2142F"];
    
    figure 
    % plotting density ----------------------------------------------------
    % If agent paths are hard to see, place a colormap command after
    % contourf() to adjust colour scheme
    contourf(X,Y,D(:,:,end),20)  
    hold on

    % plotting agent paths ------------------------------------------------

    % text offset for agent index
    tos = 0.01*[max(P(:,:,1),[],"all") max(P(:,:,1),[],"all")]; 

    for i=1:nagents
        % start = agent index
        clr = my_colours(mod(i,length(my_colours))+1);  
        text(P(1,i,1)+tos(1), P(1,i,2)+tos(2), ...
            num2str(i), 'Color', clr);     

        % agent path
        plot(P(:,i,1), P(:,i,2), "Color", clr);   

        % end = star
        plot(P(end,i,1), P(end,i,2), "Marker", "pentagram",... 
            "Color",clr,"MarkerFaceColor",clr);         
    end
    hold off
end

legend_labels = cell(nagents,1);
for i = 1:nagents
    legend_labels{i} = strcat("agent ", num2str(i));
end

if (SHOW_POSITION)
    figure
    subplot(211)
    plot(t, P(:,:,1))
    title("Position")
    xlabel("t")
    ylabel("x")
    legend(legend_labels);
    
    subplot(212)
    plot(t, P(:,:,2))
    xlabel("t")
    ylabel("y")

end

if (SHOW_ENERGY)
    figure
    plot(t,E)
    xlabel("t")
    ylabel("Energy")
    legend(legend_labels);
end

%% EXPORTING DATA

% --- Matlab - for arena animation ---
save("lloyds_output.mat", "t", "P", "D", "G");  

% --- Excel/Other - for further analysis ---
x = P(:,:,1);
y = P(:,:,2);
output_table = [array2table(t) array2table(x) array2table(y) ...
    array2table(E)];
writetable(output_table,"lloyds_output.csv"); 




    

