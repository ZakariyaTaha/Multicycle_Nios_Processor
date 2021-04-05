library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
signal enable : std_logic ;
signal rddata_BlockRom : std_logic_vector(31 downto 0) ;


component ROM_Block
	port (
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component;
begin
B1 : ROM_Block port map (
	address => address ,
	clock => clk ,
	q => rddata_BlockRom 
	);

readProcess : process(enable , rddata_BlockRom)
begin
if enable = '1'  then rddata <= rddata_BlockRom  ;
else rddata <= (others => 'Z') ; 
end if ;
	
end process ;

enableProcess : process(clk , cs ,read )
begin
	if rising_edge(clk) then enable <= cs and read ; 
	end if ;
end process ;
end synth;

