library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity ppa is
generic (w	: integer := 8);
  port(
        a: in std_logic_vector(0 to 2**w-1);
        z: out std_logic_vector(0 to 2**w-1)
      );
end;

architecture brentkung of ppa is

     
 

 
 


 
type Sigtype is array (0 to w) of std_logic_vector(0 to 2**w-1); 
 
signal s,t: Sigtype;
 
 
begin

st: for i in 0 to 2**w-1 generate

   s(0)(i)<= a(i);


end generate st;

z(0) <= not a(0);

st1: for i in 1 to 2**w-1 generate
   z(i)<= a(i) xor t(w-1)(i-1);
end generate st1;

a0: for i in 0 to w-1 generate

     a1: for j in 0 to 2**(w-1-i)-1 generate

             s(i+1)( 2**(i+1)*j + 2**(i+1)-1 ) <= s(i)( 2**(i+1)*j + 2**(i+1)-1 ) and s(i)( 2**(i+1)*j + 2**(i+1)-1  - 2**i ) ;
  

     
             a2: for k in 0 to 2**(i+1)-2 generate

                  s(i+1)(2**(i+1)*j + k ) <= s(i)( 2**(i+1)*j  +k )  ;
  
             end generate a2;
     
     
     end generate a1;
    
end generate a0;
 
 t(0)<=s(w);
 
b0: for i in 0 to w-2 generate
 
   
     b1: for j in 0 to 2**(w)-1 generate 
     
     

             
         b2: if j mod 2**(w-1-i) = ( 2**(w-2-i) -1) and j >( 2**(w-2-i) -1) generate 
         
                t(i+1)(j) <= t(i)(j) and t(i)(j-2**(w-2-i));
             
         end generate b2;
         
         b3: if j mod 2**(w-1-i) /= (2**(w-2-i) -1) or j <= (2**(w-2-i) -1) generate
           
              t(i+1)(j) <= t(i)(j);
 
         end generate b3;
         
     end generate b1;
 
 end generate b0;
 
 
end architecture brentkung;
