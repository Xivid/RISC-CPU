----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:35:55 07/30/2015 
-- Design Name: 
-- Module Name:    ACctrl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ACctrl is
    Port ( nIO : in  STD_LOGIC;
           nMEM : in  STD_LOGIC;
           RD : in  STD_LOGIC;
           WR : in  STD_LOGIC;
           RDIR : in  STD_LOGIC;
           PC : in  STD_LOGIC_VECTOR (15 downto 0);
           Addr : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUOUT : in  STD_LOGIC_VECTOR (7 downto 0);
           nBLE : out  STD_LOGIC;
           nBHE : out  STD_LOGIC;
           ABUS : out  STD_LOGIC_VECTOR (15 downto 0);
           nRD : out  STD_LOGIC;
           nWR : out  STD_LOGIC;
           nMREQ : out  STD_LOGIC;
           DBUS : inout  STD_LOGIC_VECTOR (15 downto 0);
           IOAD : out  STD_LOGIC_VECTOR (1 downto 0);
           IODB : inout  STD_LOGIC_VECTOR (7 downto 0);
           nPRD : out  STD_LOGIC;
           nPWR : out  STD_LOGIC;
           nPREQ : out  STD_LOGIC;
           IR : out  STD_LOGIC_VECTOR (15 downto 0);
           Rtemp : out  STD_LOGIC_VECTOR (7 downto 0));
end ACctrl;

architecture Behavioral of ACctrl is
	signal address, data : std_logic_vector (15 downto 0);
begin

	-- 形成访存/访IO的地址
	address <= Addr when (nMEM = '0' or nIO = '0') else
			   PC when RDIR = '1' else
               address;
	
--	-- 发访存控制信号
----	nMREQ <= (not RDIR) and nMEM;
----	nBLE <= (not RDIR) and address(0);
----	nBHE <= RDIR nor address(0); -- neither read word nor read upper byte -> 1
----	nRD <= (RDIR nor RD) or nMEM;
----	nWR <= (not WR) or nMEM; -- RDIR or?
--	nMREQ <= '0' when (nMEM = '0' or RDIR = '1') else '1';
--	nBLE <= '0' when ((nMEM = '0' and (RD = '1' or WR = '1') and address(0) = '0') or RDIR = '1') else '1';
--	nBHE <= '0' when ((nMEM = '0' and (RD = '1' or WR = '1') and address(0) = '1') or RDIR = '1') else '1';
--	nRD <= '0' when ((nMEM = '0' and RD = '1') or RDIR = '1') else '1';
--	nWR <= '0' when (nMEM = '0' and WR = '1') else '1';
--	ABUS <= address;
--	DBUS <= data when (WR = '1' and nMEM = '0') else (others => 'Z');
--	
--	-- 发访IO控制信号
--	nPREQ <= nIO;
--	nPRD <= (not RD) or nIO; -- RD = '1' and nIO = '0'
--	nPWR <= (not WR) or nIO; -- WR = '1' and nIO = '0'
--	IOAD <= address(1 downto 0);
--	IODB <= data(7 downto 0) when (WR = '1' and nIO = '0') else (others => 'Z');
--	
--	-- 数据暂存与输出
--	data <= ALUOUT & ALUOUT when WR = '1' else -- 复制扩展，以便自由送高位或低位
--			  IODB & IODB when (RD = '1' and nIO = '0') else
--			  DBUS when (RDIR = '1' or (RD = '1' and nMEM = '0'));
--	Rtemp <= data(7 downto 0) when ((nMEM = '0' and address(0) = '0') or (nIO = '0' and RD = '1')) else 
--				data(15 downto 8) when (nMEM = '0' and address(0) = '1');
--	IR <= data when RDIR = '1';
--	
-- Solution B	
	process (RDIR, WR, RD, nIO, nMEM, DBUS, ALUOUT, IODB, address)
	begin
		if RDIR = '1' then
			nMREQ <= '0';
			nBLE <= '0';
			nBHE <= '0';
			nRD <= '0';
			nWR <= '1';
            ABUS <= address;
            DBUS <= (others => 'Z');
			IR <= DBUS;
		elsif nMEM = '0' then
            nMREQ <= '0';
            ABUS <= address;
            nBLE <= address(0);
            nBHE <= not address(0);
            nRD <= not RD;
            nWR <= not WR;
            if RD = '1' and address(0) = '0' then
                DBUS <= (others => 'Z');
                Rtemp <= DBUS(7 downto 0);
            elsif RD = '1' and address(1) = '0' then
                DBUS <= (others => 'Z');
                Rtemp <= DBUS(15 downto 8);
            elsif WR = '1' then
                DBUS <= ALUOUT&ALUOUT;
            end if;
		elsif nIO = '0' then
            nPREQ <= '0';
            IOAD <= address(1 downto 0);
            nPRD <= not RD;
            nPWR <= not WR;
            if RD = '1' then
                -- nPRD <= '0'; 其实这样是对的
                -- nPWR <= '1';
                IODB <= (others => 'Z');
                Rtemp <= IODB;
            elsif WR = '1' then
                -- nPRD <= '1';
                -- nPWR <= '0';
                IODB <= ALUOUT;
            end if;
        else
            nMREQ <= '1';
            nPREQ <= '1';
            ABUS <= address;
            DBUS <= (others => 'Z');
            IOAD <= address(1 downto 0);
            IODB <= (others => 'Z');
		end if;
	end process;
	
	
end Behavioral;

