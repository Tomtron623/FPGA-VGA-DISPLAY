--Name: Tomas Martinez Anderson
--Description: Generate appropriate addresses for cols

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity col_addr_gen is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        Hcount   : in  std_logic_vector(9 downto 0);
        pos      : in  std_logic_vector(2 downto 0);
        Col_Addr : out std_logic_vector(5 downto 0);
        Col_en   : out std_logic
    );
end col_addr_gen;

architecture bhv of col_addr_gen is

    signal Col_Addr_i : std_logic_vector(5 downto 0) := (others => '0');
    signal Col_en_i   : std_logic := '0';
    signal X_start, X_end    : unsigned(9 downto 0) := (others => '0');
begin

    Col_Addr <= Col_Addr_i;
    Col_en   <= Col_en_i;

    process(pos)
    begin
        case pos is

            when "000" =>
                X_start <= to_unsigned(CENTERED_X_START, 10);
                X_end   <= to_unsigned(CENTERED_X_END, 10);

            when "001" =>
                X_start <= to_unsigned(TOP_LEFT_X_START, 10);
                X_end   <= to_unsigned(TOP_LEFT_X_END, 10);

            when "010" =>
                X_start <= to_unsigned(TOP_RIGHT_X_START, 10);
                X_end   <= to_unsigned(TOP_RIGHT_X_END, 10);

            when "011" =>
                X_start <= to_unsigned(BOTTOM_LEFT_X_START, 10);
                X_end   <= to_unsigned(BOTTOM_LEFT_X_END, 10);

            when "100" =>
                X_start <= to_unsigned(BOTTOM_RIGHT_X_START, 10);
                X_end   <= to_unsigned(BOTTOM_RIGHT_X_END, 10);

            when others =>
                X_start <= to_unsigned(CENTERED_X_START, 10);
                X_end   <= to_unsigned(CENTERED_X_END, 10);

        end case;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            Col_Addr_i <= (others => '0');
            Col_en_i   <= '0';
        elsif rising_edge(clk) then
            if (unsigned(Hcount) >= X_start) and (unsigned(Hcount) <= X_end) then
                Col_en_i <= '1';
                Col_Addr_i <= std_logic_vector(resize((unsigned(Hcount) - X_start) / 2, 6));
            else
                Col_en_i   <= '0';
                Col_Addr_i <= (others => '0');
            end if;

        end if;
    end process;
end bhv;