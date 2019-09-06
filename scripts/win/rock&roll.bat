set ERL=G:/erlang/bin/erl.exe
set SNAME=server_dev
set LogFile=\"../logs/winlog.log\"
cd ../
%ERL% -make
cd ./config/
%ERL%	+P 1024000 ^
	+spp true ^
	+sub true ^
	+pc unicode ^
	-hidden true ^
	-smp enable ^
	-pa ./ ../ebin ../ebin_mochi/ ../ebin_erlydtl/ ../ebin_server/ ../ebin_templates/ ../ebin_mysql/^
	-sname %SNAME% ^
	-setcookie abc ^
	-boot start_sasl ^
	-config server ^
	-kernel error_logger {file,"%LogFile%"} ^
	-s server ^
	-s reloader
	
pause