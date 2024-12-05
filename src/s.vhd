library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

entity SS is 
 generic (v: integer := 20;
          d: integer :=2;
          m: integer :=1;
          h: integer := 3);
 
	port (
		-- inputs
 
		Res:		in std_logic ;
		Clk:		in std_logic ;
		eoct: in std_logic ;
		sel2:  in std_logic ;
		root_p :  in std_logic ;
			root_vt :  in std_logic ;	
			en:  in std_logic ;	
		-- outputs
		start: 	out std_logic;
		RoundxDP:out unsigned(v-h+1 downto 0) ;
		Rn1:out unsigned(v-h+1 downto 0) ;
		Rn2:out unsigned(v-h+1 downto 0) ;
		nrsig:out std_logic;
		root_pn:out std_logic;
		root_pnn:out std_logic;
		R:out  Cttype
	); 
end SS;

architecture E of SS is

 --type Cttype is array (0 to (h)-1) of unsigned(v-h+1 downto 0) ;  
signal  start_n,s: std_logic; 
signal RoundxDPi,RoundxDN :  unsigned(v-h+1 downto 0) ;
signal		Rn1i,RN1n:  unsigned(v-h+1 downto 0) ;
signal		Rn2i, Rn2n:  unsigned(v-h+1 downto 0) ;
signal		nrsigi,nrsig_n:  std_logic;
signal		root_pni:  std_logic;
signal		root_pnni: std_logic;
signal		Ri,R_n:   Cttype;


begin 


   start <=s;
   RoundxDP<=RoundxDPi;
   Rn1<=Rn1i;
   Rn2<=Rn2i;
		nrsig<=nrsigi;
		root_pn<=root_pni;
		root_pnn<=root_pnni;
		R<=Ri;
	demux_pr: process(all)
	begin
	  if Res='0' then
	           s <='1';
	           RoundxDPi  <= to_unsigned(0,v-h+2);
                   Rn1i <=  to_unsigned(0,v-h+2);
                   Rn2i <=  to_unsigned(0,v-h+2);
 
                   nrsigi <='1';
                   root_pni<='0';
                   root_pnni<='0';
                   rin: for i in 0 to (h)-1 loop 
                      Ri(i) <= to_unsigned(0,v-h+2);
                   end loop rin;        
                   
	    elsif Clk'event and Clk  ='1' then
	            
		   s <=start_n;
		   RoundxDPi <= RoundxDN;
		   Rn1i <= Rn1n;
		   Rn2i <= Rn2n;
		--   start <=start_n;
		   nrsigi <= nrsig_n;	 
		   root_pni<=root_p;  
		   root_pnni<=root_pni;  
		   Ri<=R_n;     		   
	   end if;
	end process;
	
 nrsig_n<= '0' when root_vt='1' else nrsigi;	
 start_n<= '0' when eoct='1' else s;  
 Rn1n<=  RoundxDPi when  (en='1' and s='1') else Rn1i;      
 Rn2n<= Rn1i when  (en='1' and s='1') else Rn2i;
 R_n(0) <= Rn2i when  (en='1' and s='1') else Ri(0);
 
 resg: for i in 1 to (h/m)-1 generate
   R_n(i) <= Ri(i-1) when  (en='1' and s='1') else Ri(i);
 end generate resg;  
     
   RoundxDN <= RoundxDPi+1 when ((sel2='0' or RoundxDPi<v-d+2) and s='1' ) else RoundxDPi ;

end E;
