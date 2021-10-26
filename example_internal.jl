using DifferentialEquations
using Plots
using Statistics

#Note: must either include or run find_periodicity_and_amplitude.jl to run this file
function get_problem(p, u0, t)
    #Define sigmoidal function
    function S(z, z0)
        return atan(pi*z/(2*z0))*2/pi
    end

    #Function of our differential equation
    function f!(du, u, p, t)
        #Create k value including external forcing
        k = p[2]*(1 + p[4] * cos(2 * pi * t / 40000))
        du[1] = p[1]*(1 + p[5]*S(u[1]-2, 0.1)) - k * u[1] * exp(u[2])
        du[2] = k * u[1] - p[3]
    end
    prob = ODEProblem(f!, u0, t, p);
    return prob
end

function find_internal_period()
tspan = (0.0, 10.0^8);

gamma_range = 0:0.01:0.15;
internal_period = Array{Float64}(undef, length(gamma_range));

for ii in 1:length(gamma_range)
#p = [I, k, M, alpha, gamma]
p = [4*10^(-6), 0.05, 0.1, 0, gamma_range[ii]];
#u0 = [A0, P0]
u0 = [2, log(10^(-3))];
prob = get_problem(p, u0, tspan)
#Solve ODE with high tolerance and accurate solver for stiff differential equations
sol = solve(prob, KenCarp58(), maxiters=10^(10), reltol=10^(-16), abstol=10^(-16));
(p, a, t) = get_amp_period_and_time(sol);
internal_period[ii] = mean(p[(length(p)-50):length(p)]);
end

scatter(gamma_range, internal_period./1000 , legend=false)
xlabel!("Feedback Strength")
ylabel!("Internal Period (kyr)")
savefig("example_internal_period.png")
end

find_internal_period()
