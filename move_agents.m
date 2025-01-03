function [P1, E1] = move_agents(P0, Pdot, E0, dt)
    % Assuming that there are no restrictions on movement
    dvec = Pdot * dt;
    P1 = P0 + dvec;

    % Velocity restriction example --------------------------------------------
    MAXD = 0.1;
    if MAXD > 0
        n = size(P0, 2);  % Number of agents
        dmag = sqrt(sum(dvec(1, :, :).^2, 3));
        for i = 1:n
            r = dmag(i) / MAXD;
            if r > 1
                P1(1, i, :) = P0(1, i, :) + dvec(1, i, :) / r;
            end
        end
    end

    % Energy consumption ------------------------------------------------------
    ECPUD = 20;  % Energy consumed per unit distance
    dvec_sat = P1 - P0;  % Relative displacement

    dmag_sat = sqrt(sum(dvec_sat(1, :, :).^2, 3));
    % Distance travelled after velocity constrained

    % Incorporate density information to move towards regions of highest densit

    E1 = E0 - ECPUD * dmag_sat;
    for i = 1:n
        if E1(i) <= 0
            E1(i) = 0;
            P1(1, i, :) = P0(1, i, :);
        end
    end
end
