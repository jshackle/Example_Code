# Glacial Cycles Example Code
This repository contains example simulations of the calcifier-alkalinity model in Julia. Primarily, note that before running sample simulations, **you must run the "find_periodicity_and_amplitude.jl" file first.** The reason for this is noted below in the descriptions of the various files. The various examples can be run ordinarily as Julia files, and they will produce graphs into the directory in which they are run. The expected output of the files are included as .png files in this repository as well.

The code was created using Julia Version 1.5.3 and DifferentialEquations.jl version 6.16.0.
# Necessary Libraries
1. DifferentialEquations.jl
2. Plots.jl
3. PyCall.jl
4. Statistics.jl
5. Scipy (used by PyCall.jl)

# Find Periodicity and Amplitude
This code contains a helper function used by the example simulations which uses PyCall to call the Python library Scipy for the `find_peaks` function. It then uses peak data to calculate an array of times, periodicities, and amplitudes to return. 

# Example 1
Example 1 runs a simulation of the calcifier-alkalinity model with parameters set as:

        #p = [I, k, M, alpha, gamma]
        p = [4*10^(-6), 0.05, 0.1, 0.001, 0.06];
        
The code then produces plots of:
1. Time vs Alkalinity ("example1_alkalinity_vs_time.png")
2. Periodicity vs Time ("example1_period_vs_time.png")
3. Amplitude vs Time ("example1_amplitude_vs_time.png")
4. Amplitude vs Periodicity ("example1_periodicity_vs_amplitude.png")

# Example 2
Example 2 runs a simulation of the calcifier-alkalinity model with parameters set as:

        #p = [I, k, M, alpha, gamma]
        p = [4*10^(-6), 0.05, 0.1, 0.001, (0.06, 0.09)];
        
where `(0.06, 0.09)` indicates that $$\gamma$$ changes from $$0.06$$ to $$0.09$$ at $$t = 5\times 10^7$$. The code produces the same four plots as example 1. 

# Example Internal
Example internal produces a graph of the internal period of the calcifier-alkalinity model for the range of $$\gamma$$ `gamma_range = 0:0.01:0.15;` The function runs a simulation for $$t = 10^8$$ years for each value of $$\gamma$$ in that range before averaging the final $$50$$ values of periodicity. A plot of this average periodicity versus the value of $$\gamma$$ is produced as a result ("example_internal_period.png"). 

# Example Devils Staircase
This example creates a plot ("example_devils_staircase.png") of average duration ($$\alpha = 0.003$$) vs internal period within the range of $$\gamma$$ `gamma_range = 0.06:0.01:0.15;` This range is chosen to be above the Hopf Bifurcation found at $$\gamma = 0.05$$. Average duration is found similar to internal period, that is running the simulation for $$t = 10^8$$ years before averaging the final $$50$$ values of periodicity.
