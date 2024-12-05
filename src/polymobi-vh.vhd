library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.all;

entity PolyMob is 
generic(v: integer := 8;
        d: integer := 3;
        h: integer := 5);
         
port ( ANF:         in std_logic_vector(0 to binsum(v, d) - 1); 
       Clk:         in std_logic; 
       Res:         in std_logic; 
       Sel:         in  std_logic_vector(0 to v-h); 
       EN:          in std_logic;
       CT:          out std_logic_vector(0 to 2**h-1));
end entity PolyMob;


architecture recursive of PolyMob is


type Sigtype is array (0 to v) of std_logic_vector(0 to binsum(v, d)-1); 
 
signal InxDP,In1xDN,In2xDN: Sigtype;

signal Mobin:std_logic_vector(0 to 2**h-1);

--signal Sel: std_logic_vector(0 to v-d); 
--signal RoundxDP,   Count: integer range 0 to 2**(v-d+1)-1 ;

 
 

begin


--RoundxDP < = to_integer(unsigned(Rnd));

--   p_main : process (RoundxDP)
--           begin
           
 
--             case RoundxDP is
--	             when 0   => RoundxDN <=1;
--               when others    => RoundxDN <= RoundxDP+1 ;
              
--             end case;    
--  end process p_main;

 
--    p_clk: process (Res, Clk)
--         begin
--           if Res='0' then
--                   RoundxDP  <= 0;
	     
--           elsif Clk'event and Clk  ='1' then

--			 RoundxDP <= RoundxDN;
                   
--           end if;
--         end process p_clk;
         
         

--Count <= 0 when RoundxDP < v-d-1 else RoundxDP - v+d+1; 


InxDP(0) <= ANF ;

f1: for i in 1 to v-h generate 


   --C(i) <= std_logic_vector( to_unsigned(Count+v-d-i, v-d+1));

   --Sel(i) <= C(i)(v-d-i);

   r0: entity RegScanEN (structural)
       generic map ( binsum(v-i, d) ) 	
       port map    ( In1xDN(i-1)(0 to binsum(v-i, d)-1) ,In2xDN(i-1)(0 to binsum(v-i, d)-1) ,Sel(i),EN, Clk,  InxDP(i)(0 to binsum(v-i, d)-1) ); 

   In1xDN(i-1)(0 to (binsum(v-i,d)-1)) <= InxDP(i-1)(0 to (binsum(v-i,d)-1));
   in1: for j in 0 to (binsum(v-i,d)-1) generate 
            In2xDN(i-1)(j)<= In1xDN(i-1)(j) xor InxDP(i-1)(AM(j,v-i)) when AM(j,v-i)>0 else In1xDN(i-1)(j);
   end generate in1;
 
  end generate f1;
  
  min: process(InxDP)
  begin
  Mobin <= (others=>'0');
  lp: for i in 0 to binsum(h,d)-1 loop
  
  Mobin(ind(i)) <=  InxDP(v-h)(i);
  
  end loop lp;
  end process min;
  
  mut: entity mob (mymob)
      generic map ( 2**h, h ) 
      port map ( Mobin,  CT  );


end architecture recursive;

