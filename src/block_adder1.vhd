library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity block_adder is
generic ( len: integer := 256;
            w: integer :=  16
        );
  port(
        ar: in std_logic_vector(0 to len-1);
        br: in std_logic_vector(0 to len-1);
        sr: out std_logic_vector(0 to len-1)
      );
end;

architecture brentkung of block_adder is

    signal  s0,s1      :  std_logic_vector(0 to len-1);
  
    signal c,c0,c1      :  std_logic_vector(len-1 downto 0);

 	signal a,b,s:  std_logic_vector(0 to len-1);

begin

r: for i in 0 to len-1 generate
a(i)<=ar(len-1-i);
b(i)<=br(len-1-i);
sr(i)<=s(len-1-i);
end generate r;


 
a0: entity byte_adder (brentkung) generic map (w) port map (a(0 to w-1), b(0 to w-1), '0', s(0 to w-1), c(0) );

d: for i in 1 to len/w-1 generate
   a1: entity byte_adder (brentkung) generic map (w) port map (a(i*w to i*w + w-1), b(i*w to i*w + w-1), '0', s0(i*w to i*w + w-1), c0(i) );
   b1: entity byte_adder (brentkung) generic map (w) port map (a(i*w to i*w + w-1), b(i*w to i*w + w-1), '1', s1(i*w to i*w + w-1), c1(i) );  
end generate d;

e: for i in 1 to len/w-1 generate
   s(i*w to i*w + w-1) <= s0(i*w to i*w + w-1) when c(i-1) ='0' else s1(i*w to i*w + w-1);
   c(i) <= c0(i) when c(i-1) = '0' else c1(i);
end generate e;

 

end architecture brentkung;






