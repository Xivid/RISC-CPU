----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:37:42 07/29/2015 
-- Design Name: ȡָ����ģ��
-- Module Name:    IFctrl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- 	T0����ʱǰ�����ڷ���ָ�����źţ�����IR����ʱ���½���PC+1��
--		������ģ����IR��
-- 	��д�׶�PCupdate�ź���Чʱ����PCΪPCnew��
-- 	��λʱPC���㡣
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFctrl is
    Port ( T0 : in  STD_LOGIC;
		   CLK : in STD_LOGIC;
           -- RST : in  STD_LOGIC;
           PCnew : in  STD_LOGIC_VECTOR (15 downto 0);
           PCupdate : in  STD_LOGIC;
           IRdata : in  STD_LOGIC_VECTOR (15 downto 0); -- �ӷô����ģ�鷢����ָ����
           PCout : out  STD_LOGIC_VECTOR (15 downto 0); -- ����ָ���ַ
           RDIR : out  STD_LOGIC; -- �ߵ�ƽ��ô����ģ���ָ����
           IRout : out  STD_LOGIC_VECTOR (15 downto 0)); -- ָ����������ģ��
end IFctrl;

architecture Behavioral of IFctrl is
	signal PC, IR : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
	signal nextPC : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
	
begin

	RDIR <= T0; -- ���ƶ�ָ��
	
	process (T0)
	begin
		if T0 = '1' and T0'event then
            PC <= PCnew;
        end if;
	end process;
	
	PCout <= PC;
	IRout <= IRdata when (T0 and CLK) = '1' else unaffected;
    -- IRout <= IR;
end Behavioral;

