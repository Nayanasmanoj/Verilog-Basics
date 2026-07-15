# Verilog-Basics
A running summary of everything learned so far, in order. Meant as quick revision notes — for me before interviews, and for anyone following the repo's progress.


1. The Big Mental Shift: HDL ≠ Software

Verilog code does not execute top-to-bottom like Python or C. Every assign statement describes a physical wire that exists permanently and updates continuously, in parallel with every other wire. You're describing a circuit, not a sequence of steps.

verilogmodule top_module( output one );
    assign one = 1'b1;
endmodule

1'b1 = a 1-bit constant, value 1. module ... endmodule = the basic hardware "block," like a function signature but for a real circuit.


2. Wires: Connection, Not Computation

A wire can simply carry a signal from one point to another with no logic at all.

verilogassign out = in;        // direct connection

A single signal can also fan out to multiple destinations simultaneously — this isn't "copying," it's the same electrical signal reaching multiple places at once.

verilogassign w = a;
assign x = b;
assign y = b;   // b drives two outputs at once, no conflict
assign z = c;


3. Logic Gates = Verilog Operators

GateBehaviorOperatorNOTinverts input~AND1 only if all inputs 1&OR1 if any input 1|NORNOT(OR) — 1 only if all inputs 0~(a|b)XOR1 if inputs differ^XNOR1 if inputs equal^~ or ~^

verilogassign out = ~in;              // NOT
assign out = a & b;            // AND
assign out = ~(a | b);         // NOR
assign out = a ^~ b;           // XNOR

Truth table habit: always sanity-check gate logic against a truth table before trusting the code — e.g. XNOR is 1 exactly when inputs match.


4. Internal Wires — Building Multi-Stage Logic

Real circuits need intermediate signals that aren't inputs/outputs of the module. Declare them with wire.

verilogwire w1, w2, w3;

assign w1 = a & b;
assign w2 = c & d;
assign w3 = w1 | w2;

assign out = w3;

This is the pattern for any multi-gate circuit: name each intermediate stage, then combine.


5. Modeling Real Chips (7458 example)

The 7458 IC = four 2-input AND gates feeding two OR gates. The Verilog is a direct translation of the chip's internal wiring:

verilogmodule top_module (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );

    wire and1, and2, and3, and4;

    assign and1 = p1a & p1b;
    assign and2 = p1c & p1d;
    assign and3 = p2a & p2b;
    assign and4 = p2c & p2d;

    assign p1y = and1 | and2 | (p1e & p1f);
    assign p2y = and3 | and4;
endmodule

Lesson learned the hard way: group inputs into the correct pairs (2-input AND gates, not accidental 3-input groupings) — a typo or wrong grouping compiles fine but gives wrong logic. Always re-check against the real gate structure, not just "does it compile."


6. Naming Rules That Actually Matter


HDLBits' autograder requires the module be named exactly top_module — not the filename, the module name inside the file.
Filename and module name are independent in Verilog — ge1.v can contain module top_module(...). Don't assume they match.



7. ModelSim Workflow (the practical side)

vlib work              # create the compiled-design library (once per project folder)
vmap work work         # map it
vlog yourfile.v         # compile your source into 'work'
vsim top_module          # load the compiled module into the simulator
run 100                  # run simulation for 100 time units




