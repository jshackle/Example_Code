using DifferentialEquations
using Plots

#Note: must either include or run find_periodicity_and_amplitude.jl to run this file
function get_problem(p, u0, t)
    #Define sigmoidal function
    function S(z, z0)
        return atan(pi*z/(2*z0))*2/pi
    end

    #Function for parameter jump
    function gamma_jump(t_change, t, vals)
        if t < t_change
            return vals[1]
        end
        if t >= t_change
            return vals[2]
        end
    end

    #Function of our differential equation
    function f!(du, u, p, t)
        #Create k value including external forcing
        k = p[2]*(1 + p[4] * cos(2 * pi * t / 40000))
        du[1] = p[1]*(1 + gamma_jump(5*10^7, t, p[5])*S(u[1]-2, 0.1)) - k * u[1] * exp(u[2])
        du[2] = k * u[1] - p[3]
    end
    prob = ODEProblem(f!, u0, t, p);
    return prob
end

function run_example2()
tspan = (0.0, 10.0^8);
#p = [I, k, M, alpha, gamma]
p = [4*10^(-6), 0.05, 0.1, 0.001, (0.06, 0.09)];
#u0 = [A0, P0]
u0 = [2, log(10^(-3))];
prob = get_problem(p, u0, tspan)
#Solve ODE with high tolerance and accurate solver for stiff differential equations
sol = solve(prob, KenCarp58(), maxiters=10^(10), reltol=10^(-16), abstol=10^(-16));
(p, a, t) = get_amp_period_and_time(sol);

plot(sol, vars=(1), legend=false)
xlabel!("Time (yr)")
ylabel!("Alkalinity")
savefig("example2_alkalinity_vs_time.png")

scatter(p./1000, a, legend=false)
xlabel!("Periodicity (kyr)")
ylabel!("Amplitude (Alkalinity)")
savefig("example2_periodicity_vs_amplitude.png")

plot(t, a, legend=false)
xlabel!("Time (yr)")
ylabel!("Amplitude (Alkalinity)")
savefig("example2_amplitude_vs_time.png")

plot(t, p./1000, legend=false)
xlabel!("Time (yr)")
ylabel!("Periodicity (kyr)")
savefig("example2_period_vs_time.png")
end

run_example2()
