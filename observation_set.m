function obset_data = observation_set(p, x, y, d, ro)
    % Number of agents in observation set
    n = size(p, 1);

    % Weighting arena data by density
    xwt = x(:) .* d(:);
    ywt = y(:) .* d(:);

    % Initialize matrix to hold all data contained in obs set
    obset_data = nan(length(x(:))^2, 2);

    j = 1;
    for i = 1:n
        % Distance to agent
        d2a = sqrt((x - p(i, 1)).^2 + (y - p(i, 2)).^2);

        % (d2a <= ro) tells us which points are contained in the agent's radius
        % of observation. This array is used to index the weighted arena arrays.
        agent_data = [xwt(d2a <= ro), ywt(d2a <= ro)];

        % Save agent data to observation set
        k = size(agent_data, 1);
        obset_data(j:j + k - 1, :) = agent_data;
        j = j + k;
    end

    % Unique is required to remove duplicate entries
    obset_data = unique(obset_data(1:j - 1, :), 'rows');
end
