module xnr(input a,b,output out);
   assign out = (a&b)|(~a&~b);
endmodule

