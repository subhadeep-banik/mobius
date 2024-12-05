library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

entity expander is 
generic(v: integer:=8;
        d: integer:=4);
        
  port (inp :           in std_logic_vector(v-1 downto 0); 
        oup :           out std_logic_vector(0 to binsum(v, d)-1));
        
        
end entity expander;

architecture exp of expander is 

type ttype is array (0 to  binsum(v, d)-1) of std_logic_vector(d downto 0); 
signal inter : ttype;


signal inp1 : std_logic_vector(v-1 downto 0); 
begin


rev: for i in 0 to v-1 generate 

    inp1(i)<=inp(i);
end generate rev;

oup(0) <='1';

zt:  for i in 1 to binsum(v,d)-1 generate 

 inter(i)(0) <= inp1(KM(i,0));

 il: for j in 1 to DA(i)-1 generate 
     
     inter(i)(j) <= inter(i)(j-1) and inp1(KM(i,j));
    
 end generate il;


 oup (i)<= inter(i)(DA(i)-1) ; 
 
end generate zt;

end architecture exp;

      
