function make_CF_file(solution,num_waypoints,polynomial_order,time_vector,filename)

% make sure no exponential notation is in solution
solution = round(solution,6);

old_time = time_vector
diff_mat = -eye(length(old_time)) + diag(ones(length(old_time)-1,1),1);
diff_mat = diff_mat(1:end-1,:);
time_vector = diff_mat*old_time';

num_states = size(solution,2);

% Polynomial vectors in solution are sorted as follows:
% c_n t^n + c_{n-1} t^{n-1} + ...  --> [c_n c_{n-1} ... c_0]

for ii=1:num_waypoints-1 % B/C initial (or last) waypoint not included in solution
    solution_vector_start = (ii-1)*(polynomial_order+1) + 1;
    M(ii,1) = time_vector(ii);
    for jj=1:num_states
        state_idx_start = 1 + (jj-1)*(polynomial_order+1); % Where the state begins
        
        M(ii,state_idx_start + 1 : state_idx_start + polynomial_order + 1) = flip(solution(solution_vector_start : solution_vector_start + polynomial_order,jj));
    end
end


csvwrite('temp.csv',M);

file_in = fopen('temp.csv','r');
file_out = fopen('traj.csv','w');
fprintf(file_out, 'duration,x^0,x^1,x^2,x^3,x^4,x^5,x^6,x^7,y^0,y^1,y^2,y^3,y^4,y^5,y^6,y^7,z^0,z^1,z^2,z^3,z^4,z^5,z^6,z^7,yaw^0,yaw^1,yaw^2,yaw^3,yaw^4,yaw^5,yaw^6,yaw^7,\n')

while ~feof(file_in)
    fprintf(file_out,fgets(file_in));
end


% if nargin == 5
%     csvwrite(filename,M);
% else
%     csvwrite('traj.csv',M);
% end




end