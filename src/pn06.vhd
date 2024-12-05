library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

entity PolySolve is 
generic(neq: integer:=20;
        mob: integer:=6;
        v: integer := 20;
        h: integer := 6;
        k: integer := 3;
        d: integer := 2);
         
port ( Eqin :       in std_logic_vector( 0 to neq*binsum(v, d)-1);-- eq_array(0 to neq-1)(0 to binsum(v, d)-1); 
       Clk:         in std_logic; 
       Res:         in std_logic; 
       Root:          out std_logic_vector(v-1 downto 0);
       root_v:        out std_logic;
       noroot:        out std_logic;
       eoc:           out std_logic);
end entity PolySolve;


architecture recursive of PolySolve is

type eq_array is array (0 to neq-1)  of std_logic_vector(0 to  binsum(v, d)-1); 

signal Eq: eq_array;
 
type Roottype is array (0 to neq-1) of std_logic_vector(0 to 2**h-1); 

signal CT,CT_n: Roottype;

type treetype is array (0 to log2ceil(neq), 0 to 2**(log2ceil(neq)) ) of std_logic_vector(0 to 2**h-1); 
signal B: treetype;

signal exproot: std_logic_vector(0 to binsum(v, d)-1);
type streetype is array (0 to log2ceil(neq-mob), 0 to 2**(log2ceil(neq-mob)) ) of std_logic; 
signal E: streetype;

signal B_n, Dop, LD: std_logic_vector(0 to 2**h-1); 
signal Sel: std_logic_vector(0 to v-h); 
signal RoundxDP, RoundxDN, Rn1, Rn2, Rn1n, Rn2n: integer range 0 to 2**(v-h+2)-1 ;
 
signal Count,Countm: integer range 0 to 2**(v-h+1)-1 ;
 
type Ctype is array (0 to v-h) of std_logic_vector(v-h downto 0); 


signal C: Ctype; 

signal Fp: std_logic_vector(0 to v-h-1); 
signal Lp: std_logic_vector(0 to h-1); 

signal Dp: std_logic_vector(0 to neq-1); 

signal sol,Val,sel2,en,enr,root_p,start,start_n,eoct,root_vt,nrsig,nrsig_n: std_logic;
signal Exin: std_logic_vector(v-1 downto 0);

begin
--  p_main : process (RoundxDP,sel2)
 --          begin
           
 
 --            case RoundxDP is
--	             when 0   => RoundxDN <=1;
 --              when others    => RoundxDN <= RoundxDP+1 when (sel2='0' or RoundxDP<v-d+2) else RoundxDP ;
              
--             end case;    
--  end process p_main;

dist: for i in 0 to neq-1 generate 
           Eq(i) <= Eqin(i*binsum(v,d) to (i+1)*binsum(v,d) -1);
end generate dist;     

  
  RoundxDN <= RoundxDP+1 when ((sel2='0' or RoundxDP<v-d+2) and start='1' ) else RoundxDP ;

 
    p_clk: process (Res, Clk)
         begin
 
                 if Res='0' then
                   RoundxDP  <= 0;
                   Rn1 <= 0;
                   Rn2 <= 0;
                   start <='1';
                   nrsig <='1';
                 elsif Clk'event and Clk  ='1' then
	           RoundxDP <= RoundxDN;
		   Rn1 <= Rn1n;
		   Rn2 <= Rn2n;
		   start <=start_n;
		   nrsig <= nrsig_n;	 
                 end if;  
          -- end if;
 
         
         end process p_clk;
 nrsig_n<= '0' when root_vt='1' else nrsig;
 noroot <= nrsig;         
 start_n<= '0' when eoct='1' else start;        
 Rn1n<=  RoundxDP when  (en='1' and start='1') else Rn1;      
 Rn2n<= Rn1 when  (en='1' and start='1') else Rn2;
enr <= '0' when en='0' or start='0' else '1'; 	
solver: for i in 0 to mob-1 generate
          
          pm: entity PolyMob generic map (v,d,h)
                             port map (Eq(i), Clk, Res,Sel,enr, CT(i));
end generate solver;


sol <= '1' when Rn2 >=v-h else '0';

root_p <= sol and Val;
 
Count <= 0 when Rn2 < v-h else Rn2 - v+h; 
Countm <= 0 when RoundxDP < v-h-1 else RoundxDP - v+h+1; 

f1: for i in 1 to v-h generate 


   C(i) <= std_logic_vector( to_unsigned(Countm+v-h-i, v-h+1));

   Sel(i) <= C(i)(v-h-i);
end generate f1;

Fp <= std_logic_vector(to_unsigned(Count,v-h));

------inter--------------------------------------------------------
--intv<= '1' when RoundxDP = 17248 and Val='1' else '0';

--inter<= CT(4)(0 to 10)& root_vt & Exin(19) & Exin(18) & Exin(17) & Exin(16) & Exin(15) & Exin(14)& Exin(13) & Exin(12)& Exin(11) & Exin(10)& Exin(9) & Exin(8)& Exin(7) & Exin(6)
--& Exin(5) & Exin(4)& Exin(3) & Exin(2)& Exin(1) & Exin(0);
-------------------------------------------------------------------
--1st pipeline
-------------------------------------------------------------------
r1: for i in 0 to (mob)-1 generate

 rp0: entity RegE (structural)
       generic map ( 2**h ) 	
       port map    ( CT(i), en, Clk,  CT_n(i) ); 

end generate r1;  
-------------------------------------------------------------------
--or network
-------------------------------------------------------------------
a1: for i in 0 to (mob)-1 generate
	B(0,i) <= CT_n(i);
end generate a1;  
a2: for i in mob to 2**(log2ceil(mob)) generate
	B(0,i) <= (others =>'0');
end generate a2;  
 
 
tree: for t in 1 to log2ceil(mob) generate 

  level: for l in 0 to (2**(log2ceil(mob) - t )) -1 generate 
         B(t,l) <= B(t-1,2*l) or  B(t-1,2*l+1);
  end generate level;
end generate tree;  
  
-------------------------------------------------------------------
--2nd pipeline
-------------------------------------------------------------------
---val=0 implies allone

sel2<= '0' when Val='0' or RoundxDP=v-h+1 else '1';
en <= '0' when Val='1' and sol='1'  else '1';
eoc<= '1' when Val='0' and Count= (2**(v-h)-1) else '0';
eoct<= '1' when Val='0' and Count= (2**(v-h)-1) else '0';
 rp1: entity RegScan (structural)
       generic map ( 2**h ) 	
       port map    ( B(log2ceil(mob),0 ),LD, sel2 ,Clk,  B_n ); 

 
-------------------------------------------------------------------
-- priority encoder
-------------------------------------------------------------------
e1: entity PEnc (enc)
    generic map(h,k) 
    port map (B_n, Lp, Val );
     
Root<= Fp & Lp;
Exin<=  Fp & Lp;

d1: entity decoder (rtl)
    generic map (h)
    port map (Lp, Dop);
    
LD <=  B_n or Dop;



expand: entity expander (exp) generic map (v,d) port map (Exin, exproot);


-------------------------------------------------------------------
-- remaining
-------------------------------------------------------------------

dprod: for i in mob to neq-1 generate
   
     
    dp1: entity dotprod (dp) generic map(binsum(v,d)) port map (Eq(i),exproot, Dp(i));

  
end generate dprod;


-------------------------------------------------------------------
--or network
-------------------------------------------------------------------
a21: for i in 0 to (neq-mob)-1 generate
	E(0,i) <= Dp(mob+i);
end generate a21;  
a22: for i in neq-mob to 2**(log2ceil(neq-mob)) generate
	E(0,i) <= '0';
end generate a22;  



 
tree1: for t in 1 to log2ceil(neq-mob) generate 

  level1: for l in 0 to (2**(log2ceil(neq-mob) - t )) -1 generate 
        E(t,l) <= E(t-1,2*l) or  E(t-1,2*l+1);
  end generate level1;
end generate tree1;  

root_v<= '1' when E(log2ceil(neq-mob),0 )='0' and root_p='1' else '0';
root_vt<= '1' when E(log2ceil(neq-mob),0 )='0' and root_p='1' else '0';

end architecture recursive;

