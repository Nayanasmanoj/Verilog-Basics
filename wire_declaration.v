module wd(input a,b,c,d,output o1,o2);
   wire w1,w2;
   assign w1=a&b;
   assign w2=c&d;
   assign o1=w1|w2;
   assign o2=~o1;
endmodule
