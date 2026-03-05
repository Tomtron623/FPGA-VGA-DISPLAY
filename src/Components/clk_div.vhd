--Name: Tomas Martinez Anderson
--Description: 25Mhz Clk Div

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div is
    port (
        clk       : in  std_logic;
        rst       : in std_logic;
        pixel_clk : out std_logic
    );
end clk_div;

architecture bhv of clk_div is
    constant div_factor : natural := 50 / 25;
    signal count : unsigned(25 downto 0) := (others => '0');
    signal pixel_clk_i  : std_logic := '0';
begin
    pixel_clk <= pixel_clk_i;

    process(clk, rst)
    begin
        if rst = '1' then
        count <= (others => '0');
        pixel_clk_i <= '0';
        elsif rising_edge(clk) then
        if count = (div_factor/2) - 1 then
            pixel_clk_i <= not pixel_clk_i;
            count <= (others => '0');
        else
            count <= count + 1;
        end if;
        end if;
    end process;

end bhv;