function d = density_map(x,y)
    % Parameters for the three dense areas
    mu1 = [-3, 3];   % Top left corner
    mu2 = [3, 3];    % Top right corner
    mu3 = [3, -3];   % Bottom right corner
    mu4 = [-3,-3];   % Bottom left corner

   
    sigma = eye(2); % Identity covariance matrix for simplicity

    r1 = 60;
    r2 = 80;
    r3 = 0;
    r4 = 10;


    % Compute the Gaussian densities for each point
    d1 = (r1)*exp(-sum((([x(:), y(:)] - mu1) / sigma).^2, 2) / 2);
    d2 = (r2)*exp(-sum((([x(:), y(:)] - mu2) / sigma).^2, 2) / 2);
    d3 = (r3)*exp(-sum((([x(:), y(:)] - mu3) / sigma).^2, 2) / 2);
    d4 = (r4)*exp(-sum((([x(:), y(:)] - mu4) / sigma).^2, 2) / 2);
    
    default_den = 0; % Default density

    % Combine the densities
    d = d1 + d2 + d3 + d4 + default_den;

    % Reshape to the size of the input grids
    d = reshape(d, size(x));
end
