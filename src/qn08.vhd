library ieee;
use ieee.std_logic_1164.all;
 
use ieee.numeric_std.all;
use std.textio.all;
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

entity PolySolve is 
generic(neq: integer:=20;
        mob: integer:=8 ;
        v: integer := 20;
        h: integer := 8 ;
        m: integer := 3;
        k: integer := 4;
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
--signal RoundxDP, RoundxDN, Rn1, Rn2, Rn1n, Rn2n: integer range 0 to 2**(v-h+2)-1 ;
signal RoundxDP, RoundxDN, Rn1, Rn2, Rn1n, Rn2n: unsigned(v-h+1 downto 0) ;--integer range 0 to 2**(v-h+2)-1 ;
--signal Count,Countm: integer range 0 to 2**(v-h+1)-1 ;
 signal Count,Countm: unsigned(v-h+1 downto 0) ;
type Ctype is array (0 to v-h) of std_logic_vector(v-h+1 downto 0); 


signal C: Ctype; 

signal Fp: std_logic_vector(0 to v-h-1); 
signal Lp: std_logic_vector(0 to h-1); 

signal Dp,Dpn: std_logic_vector(0 to neq-1); 

signal sol,Val,sel2,en,enr,root_p,root_pn,start,start_n,eoct,root_vt,nrsig,nrsig_n,root_pnn: std_logic;
signal Exin,Exin_n,Exin_nn: std_logic_vector(v-1 downto 0);

 type Cttype is array (0 to (h)-1) of unsigned(v-h+1 downto 0) ;  
signal R,R_n: Cttype;

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

  
  RoundxDN <= RoundxDP+1 when ((sel2='0' or RoundxDP<v-h+2+(h/m)) and start='1' ) else RoundxDP ;

 
    p_clk: process (all)
         begin
 if Clk'event and Clk  ='1' then
                 if Res='0' then
                    RoundxDP  <= to_unsigned(0,v-h+2);
                   Rn1 <=  to_unsigned(0,v-h+2);
                   Rn2 <=  to_unsigned(0,v-h+2);
                   start <='1';
                   nrsig <='1';
                   root_pn<='0';
                   root_pnn<='0';
                   rin: for i in 0 to (h)-1 loop 
                      R(i) <= to_unsigned(0,v-h+2);
                   end loop rin;                
                 else
	           RoundxDP <= RoundxDN;
		   Rn1 <= Rn1n;
		   Rn2 <= Rn2n;
		   start <=start_n;
		   nrsig <= nrsig_n;	 
		   root_pn<=root_p;  
		   root_pnn<=root_pn;  
		   R<=R_n;     		   
                 end if;  
          end if;
 
         
         end process p_clk;
 nrsig_n<= '0' when root_vt='1' else nrsig;
 noroot <= nrsig;         
 start_n<= '0' when eoct='1' else start;        
 Rn1n<=  RoundxDP when  (en='1' and start='1') else Rn1;      
 Rn2n<= Rn1 when  (en='1' and start='1') else Rn2;
 R_n(0) <= Rn2 when  (en='1' and start='1') else R(0);
 
 resg: for i in 1 to (h/m)-1 generate
   R_n(i) <= R(i-1) when  (en='1' and start='1') else R(i);
 end generate resg;  
enr <= '0' when en='0' or start='0' else '1'; 	
solver: for i in 0 to mob-1 generate
          
          pm: entity PolyMob generic map (v,d,m,h)
                             port map (Eq(i), Clk, Res,Sel,enr, CT(i));
end generate solver;


sol <= '1' when R((h/m )-1) >=v-h else '0';

root_p <= sol and Val;
 
--Count <= 0 when Rn2 < v-h else Rn2 - v+h; 
--Countm <= 0 when RoundxDP < v-h-1 else RoundxDP - v+h+1; 
Count <= to_unsigned(0,v-h+2) when R((h/m )-1) < v-h else R((h/m )-1) - to_unsigned(v-h,v-h+2); 
Countm <= to_unsigned(0,v-h+2) when RoundxDP < v-h-1 else RoundxDP - to_unsigned(v-h-1,v-h+2); 
f1: for i in 1 to v-h generate 


  -- C(i) <= std_logic_vector( to_unsigned(Countm+v-h-i, v-h+1));
   C(i) <=  std_logic_vector(Countm + to_unsigned(v-h-i, v-h+2));
   Sel(i) <= C(i)(v-h-i);
end generate f1;

--Fp <= std_logic_vector(to_unsigned(Count,v-h));
Fp <= std_logic_vector(Count(v-h-1 downto 0));
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

sel2<= '0' when Val='0' or RoundxDP<=v-h+1+(h/m) else '1';--RoundxDP=v-h+1 else '1';
en <= '0' when Val='1' and sol='1'  else '1';
k1: if v-h > 30 generate
eoc<=  '1' when Val='0' and Count(30 downto 0) = (2**(30)-1+2**(30) ) and Count (v-h-1 downto 31) = (2**(v-h-31)-1)  else '0';
eoct<= '1' when Val='0' and Count(30 downto 0) = (2**(30)-1+2**(30) ) and Count (v-h-1 downto 31) = (2**(v-h-31)-1)  else '0';
end generate k1;
k2: if v-h < 31 generate
eoc<= '1' when Val='0' and Count= (2**(v-h)-1) else '0';
eoct<= '1' when Val='0' and Count= (2**(v-h)-1) else '0';
end generate k2;
 rp1: entity RegScan (structural)
       generic map ( 2**h ) 	
       port map    ( B(log2ceil(mob),0 ),LD, sel2 ,Clk,  B_n ); 

 
-------------------------------------------------------------------
-- priority encoder
-------------------------------------------------------------------
e1: entity PEnc (enc)
    generic map(h,k) 
    port map (B_n, Lp, Val );
     
--Root<= Fp & Lp;
Exin<=  Fp & Lp;




nr1: entity norn1 (rtl)
 generic map (2**h)
port map (B_n,LD);

--d1: entity decoder (rtl)
--    generic map (h)
--    port map (Lp , Dop);
    
-- LD <=  B_n or Dop;



re: entity RegE (structural) generic map (v) port map(Exin, root_p,Clk,Exin_n);
                         
expand: entity expander (exp) generic map (v,d) port map (Exin_n, exproot);

Root<= Exin_nn;
rf: entity RegE (structural) generic map (v) port map(Exin_n, root_pn,Clk,Exin_nn);
-------------------------------------------------------------------
-- remaining
-------------------------------------------------------------------

dprod: for i in mob to neq-1 generate
   
     
    dp1: entity dotprod (dp) generic map(binsum(v,d)) port map (Eq(i),exproot, Dp(i));

  
end generate dprod;
-------------------------------------------------------------------
 
 rp2: entity RegE (structural)
       generic map ( neq-mob ) 	
       port map    ( Dp(mob to (neq)-1), root_pn, Clk,  Dpn(mob to (neq)-1) ); 

 


-------------------------------------------------------------------
--or network
-------------------------------------------------------------------
a21: for i in 0 to (neq-mob)-1 generate
	E(0,i) <= Dpn(mob+i);
end generate a21;  
a22: for i in neq-mob to 2**(log2ceil(neq-mob)) generate
	E(0,i) <= '0';
end generate a22;  
-------------------------------------------------------------------





-------------------------------------------------------------------
tree1: for t in 1 to log2ceil(neq-mob) generate 

  level1: for l in 0 to (2**(log2ceil(neq-mob) - t )) -1 generate 
        E(t,l) <= E(t-1,2*l) or  E(t-1,2*l+1);
  end generate level1;
end generate tree1;  

root_v<= '1' when E(log2ceil(neq-mob),0 )='0' and root_pnn='1' else '0';
root_vt<= '1' when E(log2ceil(neq-mob),0 )='0' and root_pnn='1' else '0';

end architecture recursive;

