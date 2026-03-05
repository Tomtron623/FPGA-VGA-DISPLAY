-- Name: 
-- Section #:
-- PI Name: 
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div_tb is
end clk_div_tb;

architecture tb of clk_div_tb is
    component clk_div
    port (
        clk       : in  std_logic;
        rst       : in std_logic;
        pixel_clk : out std_logic
    );
end component;

    signal clk1   : std_logic := '0';
    signal clk2   : std_logic;
    signal rst    : std_logic := '1';

    constant CLK_IN_FREQ  : natural := 50_000_000;
    constant CLK_OUT_FREQ : natural := 25_000_000;

    constant DIV_FACTOR   : natural := CLK_IN_FREQ / CLK_OUT_FREQ;
    constant HALF_TOGGLE  : natural := DIV_FACTOR / 2;
begin

    UUT : clk_div
        port map (
            clk => clk1,
            rst => rst,
            pixel_clk => clk2);

    process
    begin
        wait for 10 ns;
        clk1 <= not clk1;
    end process;


    process
    begin
        rst <= '1';
        wait for 1 us;
        rst <= '0';

        wait until rising_edge(clk1);
        assert (clk2 = '0') report "Output should be low after reset" severity error;


        for i in 0 to HALF_TOGGLE - 1 loop
            wait until rising_edge(clk1);
        end loop;

        assert (clk2 = '1') report "Output should be high after 0.5 ms" severity error;


        for i in 0 to HALF_TOGGLE - 1 loop
            wait until rising_edge(clk1);
        end loop;

        assert (clk2 = '0') report "Output should be low after 1 ms" severity error;

        report "SIMULATION FINISHED";

        wait;
    end process;
end tb;