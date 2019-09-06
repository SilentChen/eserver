set ERL=G:\erlang\bin\erl.exe
set HRL_PATH=..\include\
set BEAM_PATH=..\ebin_protobuf\

echo.Input The Compile File Name: 
set /p FILE=

%ERL% -pa ebin ^
	-noshell ^
	-eval "protobuffs_compile:scan_file(\"%FILE%.proto\")" ^
	-eval "init:stop()"
	
if exist "%FILE%_pb.hrl" move %FILE%_pb.hrl %HRL_PATH%

if exist "%FILE%_pb.beam" move %FILE%_pb.beam %BEAM_PATH%
	
pause