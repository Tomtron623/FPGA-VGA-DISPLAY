--Name: Tomas Martinez Anderson
--Description: Generate appropriate addresses for rows

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity row_addr_gen is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        Vcount   : in  std_logic_vector(9 downto 0);
        pos      : in  std_logic_vector(2 downto 0);
        Row_Addr : out std_logic_vector(5 downto 0);
        Row_en   : out std_logic
    );
end row_addr_gen;

architecture bhv of row_addr_gen is

    signal Row_Addr_i : std_logic_vector(5 downto 0) := (others => '0');
    signal Row_en_i   : std_logic := '0';
    signal Y_start, Y_end    : unsigned(9 downto 0) := (others => '0');
begin

    Row_Addr <= Row_Addr_i;
    Row_en   <= Row_en_i;

    process(pos)
    begin
        case pos is

            when "000" =>
                Y_start <= to_unsigned(CENTERED_Y_START, 10);
                Y_end   <= to_unsigned(CENTERED_Y_END, 10);

            when "001" =>
                Y_start <= to_unsigned(TOP_LEFT_Y_START, 10);
                Y_end   <= to_unsigned(TOP_LEFT_Y_END, 10);

            when "010" =>
                Y_start <= to_unsigned(TOP_RIGHT_Y_START, 10);
                Y_end   <= to_unsigned(TOP_RIGHT_Y_END, 10);

            when "011" =>
                Y_start <= to_unsigned(BOTTOM_LEFT_Y_START, 10);
                Y_end   <= to_unsigned(BOTTOM_LEFT_Y_END, 10);

            when "100" =>
                Y_start <= to_unsigned(BOTTOM_RIGHT_Y_START, 10);
                Y_end   <= to_unsigned(BOTTOM_RIGHT_Y_END, 10);

            when others =>
                Y_start <= to_unsigned(CENTERED_Y_START, 10);
                Y_end   <= to_unsigned(CENTERED_Y_END, 10);

        end case;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            Row_Addr_i <= (others => '0');
            Row_en_i   <= '0';
        elsif rising_edge(clk) then
            if (unsigned(Vcount) >= Y_start) and (unsigned(Vcount) <= Y_end) then
                Row_en_i <= '1';
                Row_Addr_i <= std_logic_vector(resize((unsigned(Vcount) - Y_start) / 2, 6));

            else
                Row_en_i   <= '0';
                Row_Addr_i <= (others => '0');
            end if;

        end if;
    end process;

end bhv;