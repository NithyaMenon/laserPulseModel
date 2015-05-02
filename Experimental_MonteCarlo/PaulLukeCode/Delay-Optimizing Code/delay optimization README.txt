Delay Optimization readme

These files are required to perform delay optimization:
delOp.m
experimentFile.m (or equivalent)


To summarize the I/O of these pieces of these files, delOp(T,n) is the top-level function call. It has a magic value at the top of the file for the repetition rate of the laser (in nanoseconds), which should be made as accurate as possible. If an experiment's details are specified using experimentFile, delOp will compute the optimal set of delays for the T and n inputs. See the documentation header in delOp.m for more details.


Here are two examples of how to generate an experiment file from a digitizing design.

Example 1: The design features three completely independent delay paths, which cannot be combined.

In this example, one of the delays must be used to generate the pi/2 pulses, which sets the "zero" relative delay. Thus, there are effectively only two delays whose values must be specified, because the relative delays are all that matter. In experimentFile, set nDelays to 2. The compositeDelays function must reflect the full set of available delays, so it copies the values of the tunable delays and adds a zero delay: [0; delay1; delay2] Lastly, the constraint function must be specified. We constrain the delays to be between 0 and 1 as a fraction of the repetition rate using the upper and lower bound variables. There are no equality constraints, so those are left blank. Lastly, we choose delay1 < delay2 arbitrarily so that we eliminate the equivalent minimum that could be found from swapping the values of the two delays.

Example 2: The design features two independent delay paths which are chosen separately; there are four total permutations of the two delays.

In this example, an EOM is used twice, once to decide on the first delay, and the second time to decide on the second delay. The pi/2 pulses are generated from one of these four options, let's say the one using neither delay1 nor delay2, and that path can be made independent of the other three. What this means is that we must include an offset delay equal to the difference between the arrival of a pulse from the input laser and the output of a pi/2 pulse. The experiment file for this design will have nDelays = 3 (offset, delay1, delay2) and three composite delays: [offset+delay1; offset+delay2; offset+delay1+delay2] If there were additional delay paths (delay3, delay4, etc.), the number of composite delays would grow exponentially, as the composite delays are permutations of the set of delay paths. The fmincon constraints for this design are much the same as the first example, except the offset
does not have to be less than delay1.