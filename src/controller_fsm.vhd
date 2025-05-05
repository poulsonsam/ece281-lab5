----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;


architecture FSM of controller_fsm is

type sm_state is (s_1, s_2, s_3, s_4);
	
	-- Here you create variables that can take on the values defined above. Neat!	
	signal f_Q, f_Q_next: sm_state;
begin
-----next state equations
     f_Q_next <= s_1 when (f_Q = s_4) else
                 s_2 when (f_Q = s_1) else
                 s_3 when (f_Q = s_2) else
                 s_4 when (f_Q = s_3) else
                 
                 s_1; --default


-- Output logic
    with f_Q select
    o_cycle <= "0001" when s_1,
                "0010" when s_2,
                "0100" when s_3,
                "1000" when s_4,
                
                "0001" when others; -- default/reset
---next state register
stateregister_process: process(i_adv)
    begin
	   if rising_edge (i_adv) then
	       if i_reset = '1' then
                f_Q <= s_1;
            else
                f_Q <= f_Q_next;
            end if;
            end if;
  end process stateregister_process;	

end FSM;
