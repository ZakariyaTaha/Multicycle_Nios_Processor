library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is

signal counter : std_logic_vector(15 downto 0) ;
begin

    addr <= "0000000000000000" & counter ;
process(clk , reset_n , en)
begin
if(reset_n = '0') then counter <= std_logic_vector(to_unsigned(0,16)) ;
 elsif(rising_edge(clk)) then
    if (en ='1' and add_imm = '0' and sel_imm = '0' and sel_a = '0') then counter <= std_logic_vector(unsigned(counter) + 4) ;
    elsif (en ='1' and add_imm = '1' and sel_imm = '0' and sel_a = '0') then counter <= std_logic_vector(unsigned(counter) + unsigned(imm(15 downto 2) & "00"));
    elsif(en ='1' and add_imm = '0' and sel_imm = '1' and sel_a = '0') then counter <= std_logic_vector(shift_left(unsigned(imm),2));
    elsif(en ='1' and add_imm = '0' and sel_imm = '0' and sel_a = '1') then counter <= (a(15 downto 2) & "00");
    end if ;
 end if ;
end process ;

end synth;

