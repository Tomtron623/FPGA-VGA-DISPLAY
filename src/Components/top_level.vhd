--Name: Tomas Martinez Anderson
--Description: Top Level file for DE-10 lite adaptation.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
    generic (
        WIDTH : positive := 8
    );
    port (
        clk : in  std_logic;
        sw  : in  std_logic_vector(9 downto 0);
        key0, key1 : in  std_logic;
        hex0, hex1, hex2, hex3, hex4, hex5 : out std_logic_vector(6 downto 0);
        hex0_dp, hex1_dp, hex2_dp, hex3_dp, hex4_dp, hex5_dp : out std_logic;
        vga_blue, vga_red, vga_green : out std_logic_vector(3 downto 0);
        vga_hs, vga_vs : out std_logic

    );
end entity top_level;

architecture rtl of top_level is

    component vga is
        port (
            clk              : in  std_logic;
            rst              : in  std_logic;
            switches         : in  std_logic_vector(3 downto 0);
            red, green, blue : out std_logic_vector(3 downto 0);
            h_sync, v_sync   : out std_logic
        );
    end component;

begin

    TOP_LVL : vga
        port map (
            clk      => clk,
            rst      => not key0,
            switches => sw(3 downto 0),
            red      => vga_red,
            green    => vga_green,
            blue     => vga_blue,
            h_sync   => vga_hs,
            v_sync   => vga_vs
        );

    hex0 <= (others => '1');
    hex1 <= (others => '1');
    hex2 <= (others => '1');
    hex3 <= (others => '1');
    hex4 <= (others => '1');
    hex5 <= (others => '1');

    hex0_dp <= '1';
    hex1_dp <= '1';
    hex2_dp <= '1';
    hex3_dp <= '1';
    hex4_dp <= '1';
    hex5_dp <= '1';

end architecture rtl;