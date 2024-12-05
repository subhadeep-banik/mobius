-------------------------------------------------------------------------------
-- Title      : DDBEN
-- Project    : 
-------------------------------------------------------------------------------
-- File       : aes_tb.vhd
-- Author     : Francesco Regazzoni  <regazzoni@alari.ch>
-- Company    : Advanced Learning and Research Insitute, Lugano 
-- Created    : 2013-11-3
-- Last update: 2013-11-3
-- Platform   : ModelSim (simulation), Synopsys (synthesis)
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Test bench for the AES core of Frank 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Francesco Regazzoni
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-11-3  1.0      rf      Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
 
use work.mob_pkg.all;
use work.eq_pkg.all;
use work.all;

--use work.aes_pack.all;

entity polysolve_tb is
end polysolve_tb;


architecture tb of polysolve_tb is   

 
 signal  Eqin :     std_logic_vector (0 to 20*binsum(20 ,2) -1);--(0 to 8  -1);     
 
 signal   Root    :               std_logic_vector  (20 - 1 downto 0);
 signal   Res     : std_logic ; 
 signal   root_v,noroot  : std_logic ; 
 signal   eoc     : std_logic ; 
 signal   Clk     : std_logic;                    -- driving clock
    


 

  component PolySolve
  -- generic(neq: integer:=20;
   --     mob: integer:=12;
   --     v: integer := 20;
   --     h: integer := 12;
   --     m: integer := 3;
   --     k: integer := 6;
   --     d: integer := 2);
  port(
        Eqin   : in std_logic_vector (0 to 20*binsum(20 ,2) -1);
        Clk    : in  std_logic ;
        Res    : in  std_logic ;
        Root   :              inout std_logic_vector(20-1 downto 0);
        root_v : out std_logic;
        noroot : out std_logic;
        eoc    : out std_logic  
  );
  end component;
       


   
begin

  -- Instantiate the module under test (MUT)
  mut: PolySolve
 --    generic map (
 --    neq    => 20 ,
 --    mob    => 12 ,
 --    v    =>   20 ,
 --    m => 3,
 --    k   => 6,
 --     d   =>2
 -- ) 

    port map (
      Eqin => Eqin,
      Clk=>Clk,
      Res=>Res,
      Root=>Root,
      root_v=>root_v,
      noroot=>noroot,
      eoc=>eoc      
  );

  -- Generate the clock
--  ClkxC <= not (ClkxC) after clkphasehigh;


  Tb_clkgen : process
  begin
     Clk <= '1';
     wait for 0.5 ns;
     Clk <= '0';
     wait for 0.5 ns;
  end process Tb_clkgen;

  -- obtain stimulus and apply it to MUT
  ----------------------------------------------------------------------------
  B1 : block
   begin


  -- timing of clock and simulation events
 


  Tb_stimappli : process
                         type sigarray is array(0 to 20 -1) of 
                        STD_LOGIC_VECTOR(0 to binsum(20 ,2) -1);
    variable temp_e: sigarray;
    variable count,numroot    : integer;
    variable INLine   : line;
        variable temp_d   : STD_LOGIC_VECTOR(0 to 2**20-1);
    variable temp_f   : STD_LOGIC_VECTOR(0 to 20-1);    
        variable temp_r   : STD_LOGIC_VECTOR(0 to 2**20-1);
    variable temp_i   : STD_LOGIC_VECTOR(127 downto 0); 
    variable temp_t   : STD_LOGIC_VECTOR(127 downto 0); 
    variable temp_w   : STD_LOGIC_VECTOR(127 downto 0); 
     constant clkphasehigh: time:= 0.5 ns;
  constant clkphaselow: time:= 0.5 ns;
  constant responseacquisitiontime: time:= 0.75 ns;
  constant stimulusapplicationtime: time:= 0.25 ns;
  constant resetactivetime:         time:=  1 ns;


  file tfile,keyfile,ptfile ,wfile: TEXT;


  begin
    file_open(ptfile,"Setpolyn20.txt", read_mode);
 
         count:=0;
         numroot:=0;
    -- default values



    -- process until we run out of stimuli
  


 appli_loop : while not (endfile(ptfile)) loop
    

          count:=count+1;
      l1: for i in 0 to 20-1 loop
  
      readline(ptfile,INLine);
      read(INLine,temp_e(i));
      Eqin(i*binsum(20,2) to (i+1)*binsum(20,2) -1) <= temp_e(i);
      
     end loop l1;
             readline(ptfile,INLine);
        hread(INLine,temp_r);
      --  readline(ptfile,INLine);
    --    read(INLine,temp_f);
    --       ml: for j in 0 to 20-1 loop 
    --    troot(j)<=temp_f(j);
    --    end loop ml;
        
      wait for 10*resetactivetime;

    -- process until we run out of stimuli
    Res       <= '0';
    --Eq <= (others => '0');
 
    wait for resetactivetime;
    Res       <= '1';

     
     -- wait for (20 -5 + 3)*2*clkphasehigh;
      
      
      inner_loop: loop
      
      
      
       ----a:for j in 0 to 31 loop
      

     if root_v='1' then
        numroot:=numroot+1;
      	assert temp_r(to_integer(unsigned(Root))) = '1' report "======>>> DOES NOT MATCH <<<======" severity failure;
      	report "succ + "&  integer'image(count) & "   +0x" &to_hstring(Root) & "#root=" & integer'image(numroot);
      end if;

      --if j<31 then 
      
      if eoc='0' then 
                wait for  2*clkphasehigh ;
      else 
      wait for  50*2*clkphasehigh ;--- resetactivetime      ;
      exit inner_loop;
      end if;
      end loop inner_loop;
 
  --  wait for 5*resetactivetime;
  --  Res       <= '0';
  --  wait for resetactivetime;
  ---  Res       <= '1';
    end loop appli_loop;
    
    wait until Clk'event and Clk = '1';
    file_close(ptfile);
    wait;
  end process Tb_stimappli;
end block;
end tb;






