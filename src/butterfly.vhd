library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity butterfly is 
generic(v: integer := 6);
         
port ( ANF:         in std_logic_vector(0 to 2**v-1);      
       CT:          out std_logic_vector(0 to 2**v-1));
end entity butterfly;


architecture but of butterfly is
 
 signal s,t,u: std_logic_vector(0 to 2**v -1);
 
 begin
 
s<=ANF;
         
  b1: for j in  0 to ( 2**(v-1) -1) generate 
     
    t ( 2*j+1) <=  s(2*j) xor s (2*j+1) ;
    t ( 2*j )  <=  s(2*j)  ;

  end generate b1;
  
 c1: for j in  0 to ( 2**(v-1) -1) generate 
    u ( 2*j+1) <= t(j+ 2**(v-1)) ;
    u ( 2*j )  <= t(j)  ;
  
  end generate c1;
  
  CT<=u;
 
 end architecture but;
 
