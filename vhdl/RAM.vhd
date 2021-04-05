library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is
type ram_type is array(0 to 1023) of std_logic_vector(31 downto 0);
signal ram: ram_type := (others => (others => '0'));
signal enable : std_logic ;
signal s_address : std_logic_vector(9 downto 0) ;
begin

	writeProcess : process (clk,write,wrdata,address,cs) 
begin
	if rising_edge(clk) then
		if((write = '1') and (cs = '1')) then ram(to_integer(unsigned(address))) <= wrdata ;  
        end if ;
    end if ;

end process ;

readProcess : process(enable , s_address)
begin
if enable = '1'  then rddata <= ram(to_integer(unsigned(s_address))) ;
else rddata <= (others => 'Z') ; 
end if ;
	
end process ;

enableProcess : process(clk , cs ,read)
begin
	if rising_edge(clk) then enable <= cs and read ; s_address <= address ;
	end if ;
end process ;

end synth;