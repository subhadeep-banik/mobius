library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity byte_adder is
generic (w	: integer := 8);
  port(
        a: in std_logic_vector(0 to w-1);
        b: in std_logic_vector(0 to w-1);
        c: in std_logic;
        s: out std_logic_vector(0 to w-1);
        cout:  out std_logic
      );
end;

architecture brentkung of byte_adder is

    signal g,p :  std_logic_vector(w-1 downto 0);
    signal LG       :  std_logic_vector(w-1 downto 0);
 

 
begin


--r: for i in 0 to w-1 generate
--a(i)<=ar(w-1-i);
--b(i)<=br(w-1-i);
--sr(i)<=s(w-1-i);
--end generate r;

a1: for i in 0 to w-1 generate

g(i) <= a(i) and b(i);
p(i) <= a(i) xor b(i);

end generate a1;
 

 
LG(0) <= g(0) or (c  and p(0));
b1: for i in 1 to w-1 generate
 LG(i) <= g(i) or (LG(i-1)  and p(i));
end generate b1;


s(0) <= p(0) xor c;
 c1: for i in 1 to w-1 generate
 s(i) <= p(i)  xor LG(i-1);
end generate c1;

cout<= LG(w-1);
end architecture brentkung;






