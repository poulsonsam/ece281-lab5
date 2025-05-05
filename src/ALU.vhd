----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           Y : out std_logic_vector ( 1 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
           
end ALU;



    

architecture Behavioral of ALU is

  component ripple_adder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC
       );
   end component ripple_adder;
    signal w_carry : STD_LOGIC_VECTOR(6 downto 0);  -- Internal carry wires
    signal w_result : STD_LOGIC_VECTOR(7 downto 0); -- o_result wire
    signal w_sum : STD_LOGIC_VECTOR(7 downto 0); -- sum out of the adder wire
    signal w_or : std_logic_vector (7 downto 0);
    signal w_and : std_logic_vector (7 downto 0);
    signal w_lilmux : std_logic_vector (7 downto 0);
    
begin
    ---o_flag output
   o_flags(0) <= (not(i_op(0) XOR i_A(7) XOR i_B(7))) and (not i_op(1)) and (i_A(7) XOR w_sum(7));
   --Carry output
  o_flags(1) <= (not i_op(1)) and w_carry(0);
  --Negative
  o_flags(2) <= w_result(7); ---what is different between sum and result not sure what to use
  --Zero
  o_flags(3) <= '1' when w_result = "00000000" else '0';
   --but why and gate if only one input?
   
   
   -- OR and AND
   w_and <= i_A AND i_B;
   w_or <= i_A OR i_B;
   
   
    
    
     full_adder_0: ripple_adder
    port map(
        A     => i_A(3 downto 0),
        B     => i_B(3 downto 0),
        Cin   => i_op(0),   -- Directly to input here
        S     => o_result(3 downto 0),
        Cout  => w_carry(0)
    );

    full_adder_1: ripple_adder
    port map(
        A     => i_A(7 downto 4),
        B     => i_B(7 downto 4),
        Cin   => w_carry(0),
        S     => o_result(7 downto 4),
        Cout  => w_carry(1)
    );

--mux
o_result <= w_sum when (i_op(1) = '0' and i_op(2) = '0') or (i_op(1) = '0' and i_op(2) = '1') else
            w_and when (i_op(1) = '1' and i_op(2) = '0') else
            w_or when (i_op(1) = '1' and i_op(2) = '1') else
            x"00";
            
 w_lilmux <= i_B when (i_op(0) = '0') else
             not i_B;
            
            
   
            
            
--process
 --begin
  --  case lilmux is
   ---- when i_B => Y(0) <= '0';
   -- when not i_B => Y(1) <= '1';
   -- end case;
   -- end process;
    -- final output flag
end Behavioral;