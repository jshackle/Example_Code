using PyCall
using Polynomials
using Plots


function get_fit(sol)
(periodicity, amplitude) = get_amp_and_period(sol);
bf = Polynomials.fit(periodicity, amplitude, 1);
m = bf[1];
b = bf[0];
return (m,b)
end

function get_amp_and_period(sol)
    (max_t, max_A, min_t, min_A) = get_max_and_min(sol)
    len = length(sol.u)
    A = Vector{Float64}(undef, len)
    t = Vector{Float64}(undef, len)
    for ii in 1:len
        row = sol.u[ii]
        A[ii] = row[1]
        t[ii] = sol.t[ii]
    end
    amps = Array{Float64}(undef, length(max_A))
    for ii in 1:(length(max_A))
        mt = max_t[ii]
        if ii == length(max_A)
        mt2 = t[length(t)]
        else
        mt2 = max_t[ii+1]
        end
        for jj in 1:(length(min_A))
            mnt = min_t[jj]
            if mt < mnt && mt2 > mnt
                amps[ii] = max_A[ii] - min_A[jj];
            end
        end
    end
    periodicity = Array{Float64}(undef, length(amps) - 1)
    amplitude = Array{Float64}(undef, length(amps) - 1)
    for ii in 1:(length(amps) - 1)
        periodicity[ii] = max_t[ii+1] - max_t[ii]
        amplitude[ii] = amps[ii+1]
    end
    return (periodicity, amplitude)
end

function get_amp_period_and_time(sol)
    (max_t, max_A, min_t, min_A) = get_max_and_min(sol)
    len = length(sol.u)
    A = Vector{Float64}(undef, len)
    t = Vector{Float64}(undef, len)
    for ii in 1:len
        row = sol.u[ii]
        A[ii] = row[1]
        t[ii] = sol.t[ii]
    end
    amps = Array{Float64}(undef, length(max_A))
    for ii in 1:(length(max_A))
        mt = max_t[ii]
        if ii == length(max_A)
        mt2 = t[length(t)]
        else
        mt2 = max_t[ii+1]
        end
        for jj in 1:(length(min_A))
            mnt = min_t[jj]
            if mt < mnt && mt2 > mnt
                amps[ii] = max_A[ii] - min_A[jj];
            end
        end
    end
    periodicity = Array{Float64}(undef, length(amps) - 1)
    amplitude = Array{Float64}(undef, length(amps) - 1)
    times = Array{Float64}(undef, length(amps) - 1)
    for ii in 1:(length(amps) - 1)
        periodicity[ii] = max_t[ii+1] - max_t[ii]
        amplitude[ii] = amps[ii+1]
        times[ii] = max_t[ii+1]
    end
    return (periodicity, amplitude, times)
end

function get_max_and_min(sol)
    ss = pyimport("scipy.signal")
    len = length(sol.u)
    A = Vector{Float64}(undef, len)
    t = Vector{Float64}(undef, len)
    for ii in 1:len
        row = sol.u[ii]
        A[ii] = row[1]
        t[ii] = sol.t[ii]
    end
    max_indxs = ss.find_peaks(A, prominence=(.001, 100))
    max_indxs = max_indxs[1]
    max_A = Vector{Float64}(undef, length(max_indxs))
    max_t = Vector{Float64}(undef, length(max_indxs))
    for ii in 1:length(max_indxs)
        max_A[ii] = A[max_indxs[ii]]
        max_t[ii] = t[max_indxs[ii]]
    end

    min_indxs = ss.find_peaks(-A, prominence=(.001, 100))
    min_indxs = min_indxs[1]
    min_A = Vector{Float64}(undef, length(min_indxs))
    min_t = Vector{Float64}(undef, length(min_indxs))
    for ii in 1:length(min_indxs)
        min_A[ii] = A[min_indxs[ii]]
        min_t[ii] = t[min_indxs[ii]]
    end
    return (max_t, max_A, min_t, min_A)
end
