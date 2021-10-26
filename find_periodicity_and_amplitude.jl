using PyCall

#Function to find the amplitude, periodicity, and time of the maximum
function get_amp_period_and_time(sol)
    #Use the scipy package scipy.signal to find the maximum and minimums of the simulation
    function get_max_and_min(sol)
        ss = pyimport("scipy.signal")

        #Transoform solution into a vector
        len = length(sol.u)
        A = Vector{Float64}(undef, len)
        t = Vector{Float64}(undef, len)
        for ii in 1:len
            row = sol.u[ii]
            A[ii] = row[1]
            t[ii] = sol.t[ii]
        end

        #Find indices of peaks and corresponding alkalinity level and time
        #Prominence just gets rid of local minimum from noise
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
    (max_t, max_A, min_t, min_A) = get_max_and_min(sol)
    len = length(sol.u)

    #Transform solution into vector of alkalinity time series
    A = Vector{Float64}(undef, len)
    t = Vector{Float64}(undef, len)
    for ii in 1:len
        row = sol.u[ii]
        A[ii] = row[1]
        t[ii] = sol.t[ii]
    end

    #Initialize vector of amplitudes
    amps = Array{Float64}(undef, length(max_A))
    for ii in 1:(length(max_A))
        mt = max_t[ii]
        if ii == length(max_A)
        mt2 = t[length(t)]
        else
        mt2 = max_t[ii+1]
        end

        #Find minimum between time of this peak and time of next peak
        for jj in 1:(length(min_A))
            mnt = min_t[jj]
            if mt < mnt && mt2 > mnt
                #Amplitude is maximum peak minus minimum peak
                amps[ii] = max_A[ii] - min_A[jj];
            end
        end
    end

    #Initialize final periodicity and amplitude vectors
    periodicity = Array{Float64}(undef, length(amps) - 1)
    amplitude = Array{Float64}(undef, length(amps) - 1)
    times = Array{Float64}(undef, length(amps) - 1)
    for ii in 1:(length(amps) - 1)
        #Periodicity is defined as time of maximum peak minus previous maximum peak
        periodicity[ii] = max_t[ii+1] - max_t[ii]
        #Amplitude is amplitude of that peak
        amplitude[ii] = amps[ii+1]
        times[ii] = max_t[ii+1]
    end
    return (periodicity, amplitude, times)
end
